import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_flow_provider.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class FoundUser {
  final String id;
  final String displayName;
  final String? email;
  final String? telegramUsername;
  final String? avatarUrl;

  const FoundUser({
    required this.id,
    required this.displayName,
    this.email,
    this.telegramUsername,
    this.avatarUrl,
  });
}

// ── Provider ──────────────────────────────────────────────────────────────────
final _userSearchQueryProvider = StateProvider<String>((ref) => '');

final _userSearchResultProvider =
    FutureProvider.autoDispose<FoundUser?>((ref) async {
  final q = ref.watch(_userSearchQueryProvider);
  if (q.trim().length < 3) return null;

  final api = ref.watch(authApiServiceProvider);
  try {
    final res = await api.searchUser(q.trim());
    final u = res['user'] as Map<String, dynamic>?;
    if (u == null) return null;
    return FoundUser(
      id: u['id'] as String,
      displayName: u['displayName'] as String? ?? '',
      email: u['email'] as String?,
      telegramUsername: u['telegramUsername'] as String?,
      avatarUrl: u['avatarUrl'] as String?,
    );
  } catch (_) {
    return null;
  }
});

// ── Widget ────────────────────────────────────────────────────────────────────
/// Foydalanuvchini email/Telegram orqali qidiradi.
/// [onUserSelected] — HisobKit'da topilgan foydalanuvchi tanlanganda chaqiriladi.
/// [onInvite] — topilmasa "Taklif qilish" bosilganda chaqiriladi.
/// [onEmailEntered] — minimal holat: faqat email kiritilsa (HisobKit yo'q).
class UserSearchWidget extends ConsumerStatefulWidget {
  final void Function(FoundUser user)? onUserSelected;
  final void Function(String email)? onInvite;
  final void Function(String email)? onEmailEntered;
  final String labelText;
  final String hintText;

  const UserSearchWidget({
    super.key,
    this.onUserSelected,
    this.onInvite,
    this.onEmailEntered,
    this.labelText = 'Email yoki @telegram',
    this.hintText = 'Email yoki Telegram username kiriting',
  });

  @override
  ConsumerState<UserSearchWidget> createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends ConsumerState<UserSearchWidget> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    // Debounce: update query after 600ms idle
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_ctrl.text == value && mounted) {
        ref.read(_userSearchQueryProvider.notifier).state = value.trim();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _ctrl.text.trim();
    final resultAsync = ref.watch(_userSearchResultProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _ctrl,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      ref.read(_userSearchQueryProvider.notifier).state = '';
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: _onChanged,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
        ),
        // Results
        if (query.length >= 3) ...[
          const SizedBox(height: 8),
          resultAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (user) {
              if (user != null) {
                return _FoundUserCard(
                  user: user,
                  onTap: () {
                    widget.onUserSelected?.call(user);
                    _ctrl.clear();
                    ref.read(_userSearchQueryProvider.notifier).state = '';
                    setState(() {});
                  },
                );
              } else {
                // Not found — offer invite
                return _NotFoundCard(
                  email: query,
                  onInvite: () {
                    widget.onInvite?.call(query);
                    widget.onEmailEntered?.call(query);
                    _ctrl.clear();
                    ref.read(_userSearchQueryProvider.notifier).state = '';
                    setState(() {});
                  },
                  onUseAnyway: () {
                    widget.onEmailEntered?.call(query);
                    _ctrl.clear();
                    ref.read(_userSearchQueryProvider.notifier).state = '';
                    setState(() {});
                  },
                );
              }
            },
          ),
        ],
      ],
    );
  }
}

// ── Found user card ───────────────────────────────────────────────────────────
class _FoundUserCard extends StatelessWidget {
  final FoundUser user;
  final VoidCallback onTap;

  const _FoundUserCard({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.accent.withOpacity(0.15),
          child: user.avatarUrl != null
              ? ClipOval(
                  child: Image.network(user.avatarUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _initials(user.displayName)))
              : _initials(user.displayName),
        ),
        title: Text(user.displayName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(user.email ?? user.telegramUsername ?? '',
            style: const TextStyle(fontSize: 12)),
        trailing: FilledButton.tonal(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.accent.withOpacity(0.15),
            foregroundColor: AppTheme.accent,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: const Text('Qo\'shish'),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _initials(String name) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase();
    return Text(initials,
        style: const TextStyle(
            color: AppTheme.accent, fontWeight: FontWeight.bold));
  }
}

// ── Not found card ────────────────────────────────────────────────────────────
class _NotFoundCard extends StatelessWidget {
  final String email;
  final VoidCallback onInvite;
  final VoidCallback onUseAnyway;

  const _NotFoundCard({
    required this.email,
    required this.onInvite,
    required this.onUseAnyway,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_search, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"$email" HisobKit\'da topilmadi',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onUseAnyway,
                    icon: const Icon(Icons.person_add_outlined, size: 16),
                    label: const Text('Qo\'shish'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onInvite,
                    icon: const Icon(Icons.send, size: 16),
                    label: const Text('Taklif'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
