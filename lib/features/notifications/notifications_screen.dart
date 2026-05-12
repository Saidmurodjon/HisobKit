import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../auth/providers/auth_flow_provider.dart';
import 'notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(allNotificationsProvider);
    final notifier = ref.read(notificationsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xabarnomalar'),
        actions: [
          TextButton.icon(
            onPressed: () => notifier.markAllRead(),
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text('Barchasini o\'q'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yangilash',
            onPressed: () => notifier.syncFromServer(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Xato: $e')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none,
                      size: 72, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Xabarnomalar yo\'q',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: notifier.syncFromServer,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final n = notifications[i];
                return _NotifTile(
                  notif: n,
                  onTap: () => notifier.markRead(n),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;

  const _NotifTile({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notif.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread
            ? AppTheme.primary.withOpacity(0.04)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotifIcon(type: notif.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notif.body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notif.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  // Action buttons for debt requests
                  if (_isActionable(notif.type))
                    _DebtActionButtons(notif: notif),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isActionable(String type) =>
      type == 'debt_request' || type == 'debt_offer';

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Hozirgina';
    if (diff.inHours < 1) return '${diff.inMinutes} daqiqa oldin';
    if (diff.inDays < 1) return '${diff.inHours} soat oldin';
    if (diff.inDays < 7) return '${diff.inDays} kun oldin';
    return DateFormat('dd.MM.yyyy').format(dt);
  }
}

class _NotifIcon extends StatelessWidget {
  final String type;
  const _NotifIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (type) {
      case 'debt_request':
        icon = Icons.request_page;
        color = Colors.orange;
        break;
      case 'debt_offer':
        icon = Icons.handshake;
        color = AppTheme.primary;
        break;
      case 'debt_accepted':
        icon = Icons.check_circle;
        color = AppTheme.accent;
        break;
      case 'debt_rejected':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.blueGrey;
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.12),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _DebtActionButtons extends ConsumerWidget {
  final AppNotification notif;
  const _DebtActionButtons({required this.notif});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(notif.data) as Map<String, dynamic>;
    } catch (_) {}

    final requestId = data['debtRequestId'] as String?;
    if (requestId == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => _reject(context, ref, requestId),
            icon: const Icon(Icons.close, size: 14),
            label: const Text('Rad etish'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _accept(context, ref, requestId),
            icon: const Icon(Icons.check, size: 14),
            label: const Text('Qabul qilish'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.accent,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _accept(
      BuildContext context, WidgetRef ref, String requestId) async {
    try {
      final api = ref.read(authApiServiceProvider);
      await api.acceptDebtRequest(requestId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Qabul qilindi ✓'),
            backgroundColor: AppTheme.accent,
          ),
        );
      }
      // Mark notification as read
      await ref.read(notificationsNotifierProvider.notifier).markRead(notif);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xato: $e')));
      }
    }
  }

  Future<void> _reject(
      BuildContext context, WidgetRef ref, String requestId) async {
    try {
      final api = ref.read(authApiServiceProvider);
      await api.rejectDebtRequest(requestId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rad etildi')),
        );
      }
      await ref.read(notificationsNotifierProvider.notifier).markRead(notif);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xato: $e')));
      }
    }
  }
}
