import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/app_database.dart';
import '../../features/auth/providers/auth_flow_provider.dart';

// ── Local unread count (DB stream) ───────────────────────────────────────────
final unreadNotifCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.notificationsDao.watchUnreadCount();
});

// ── All notifications (DB stream) ────────────────────────────────────────────
final allNotificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.notificationsDao.watchAll();
});

// ── Notifier: fetch from Neon + mark read ─────────────────────────────────────
class NotificationsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  Timer? _pollTimer;

  NotificationsNotifier(this._ref) : super(const AsyncData(null)) {
    // Start polling every 60 seconds
    _startPolling();
  }

  void _startPolling() {
    // Fetch immediately
    syncFromServer();
    // Then every 60 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      syncFromServer();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Neon dan xabarnomalarni tortib DB ga saqlash
  Future<void> syncFromServer() async {
    final api = _ref.read(authApiServiceProvider);
    final db = _ref.read(databaseProvider);

    try {
      final res = await api.getNotifications();
      final list = (res['notifications'] as List<dynamic>? ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList();

      if (list.isNotEmpty) {
        await db.notificationsDao.upsertFromRemote(list);
        await db.notificationsDao.pruneOld();
      }
    } catch (_) {
      // Offline bo'lsa — jimgina o'tkazib yuboriladi
    }
  }

  Future<void> markRead(AppNotification notif) async {
    final db = _ref.read(databaseProvider);
    final api = _ref.read(authApiServiceProvider);
    await db.notificationsDao.markRead(notif.id);
    if (notif.remoteId != null) {
      await api.markNotificationRead(notif.remoteId!);
    }
  }

  Future<void> markAllRead() async {
    final db = _ref.read(databaseProvider);
    final api = _ref.read(authApiServiceProvider);
    await db.notificationsDao.markAllRead();
    await api.markAllNotificationsRead();
  }
}

final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, AsyncValue<void>>((ref) {
  return NotificationsNotifier(ref);
});
