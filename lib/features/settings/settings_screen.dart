import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../core/services/update_checker.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../auth/providers/auth_flow_provider.dart';
import '../auth/models/auth_state.dart' show AuthFlowSuccess;
import '../../core/security/biometric_service.dart';
import '../../core/security/pin_service.dart';
import '../../core/security/encryption_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: _bgColor(context),
      body: settingsAsync.when(
        data: (settings) => CustomScrollView(
          slivers: [
            // ── Payme-style profile header ────────────────────────────
            SliverToBoxAdapter(child: _ProfileHeader()),
            // ── Settings list ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

            // ── Appearance ───────────────────────────────────────────────
            _GroupLabel(l10n.language),
            _GroupCard(children: [
              _PickerTile(
                icon: Icons.language,
                title: l10n.language,
                value: {'uz': l10n.uzbek, 'ru': l10n.russian, 'en': l10n.english}[settings.language] ?? settings.language,
                onTap: () => _pickLanguage(context, ref, settings),
              ),
              _divider(),
              _PickerTile(
                icon: Icons.monetization_on_outlined,
                title: l10n.baseCurrency,
                value: settings.baseCurrency,
                onTap: () => _pickCurrency(context, ref, settings),
              ),
              _divider(),
              _PickerTile(
                icon: Icons.palette_outlined,
                title: l10n.theme,
                value: {
                  ThemeMode.system: l10n.system,
                  ThemeMode.light: l10n.light,
                  ThemeMode.dark: l10n.dark,
                }[settings.themeMode] ?? l10n.system,
                onTap: () => _pickTheme(context, ref, settings),
              ),
            ]),
            const SizedBox(height: 20),

            // ── Security ─────────────────────────────────────────────────
            _GroupLabel(l10n.biometrics),
            _GroupCard(children: [
              _BiometricRow(settings: settings),
              _divider(),
              _PickerTile(
                icon: Icons.lock_clock_outlined,
                title: l10n.autoLock,
                value: {
                  0: l10n.never,
                  1: l10n.minute1,
                  5: l10n.minutes5,
                  10: l10n.minutes10,
                  30: l10n.minutes30,
                }[settings.autoLockMinutes] ?? '${settings.autoLockMinutes} min',
                onTap: () => _pickAutoLock(context, ref, settings),
              ),
              _divider(),
              _ArrowTile(
                icon: Icons.pin_outlined,
                title: l10n.changePin,
                onTap: () => _showChangePinSheet(context, ref),
              ),
            ]),
            const SizedBox(height: 20),

            // ── Exchange Rates ────────────────────────────────────────────
            _GroupLabel(l10n.exchangeRates),
            _GroupCard(children: [
              _ArrowTile(
                icon: Icons.currency_exchange,
                title: l10n.exchangeRates,
                subtitle: l10n.updateRate,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => _ExchangeRatesSheet(),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // ── Data ─────────────────────────────────────────────────────
            _GroupLabel(l10n.backupData),
            _GroupCard(children: [
              _ArrowTile(
                icon: Icons.backup_outlined,
                title: 'Backup',
                subtitle: 'JSON sifatida eksport qilish',
                onTap: () => _backup(context, ref),
              ),
              _divider(),
              _ArrowTile(
                icon: Icons.restore_outlined,
                title: 'Restore',
                subtitle: 'JSON fayldan tiklash',
                onTap: () => _restore(context, ref),
              ),
              _divider(),
              _ArrowTile(
                icon: Icons.file_download_outlined,
                title: 'Export (PDF/Excel)',
                onTap: () => context.push('/export'),
              ),
            ]),
            const SizedBox(height: 20),

            // ── About ─────────────────────────────────────────────────────
            _GroupLabel(l10n.about),
            _GroupCard(children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.info_outline,
                      color: AppTheme.primary, size: 20),
                ),
                title: Text(l10n.version,
                    style: GoogleFonts.inter(fontSize: 15)),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(UpdateChecker.currentVersion,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accent)),
                ),
              ),
              _divider(),
              _UpdateCheckerTile(),
            ]),
            const SizedBox(height: 20),

            // ── Danger Zone ───────────────────────────────────────────────
            _GroupLabel(l10n.dangerZone, color: AppTheme.danger),
            _GroupCard(
              borderColor: AppTheme.danger.withOpacity(0.3),
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_forever,
                        color: AppTheme.danger, size: 20),
                  ),
                  title: Text(
                    "Barcha ma'lumotlarni o'chirish",
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppTheme.danger,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Hisoblar, tranzaksiyalar va sozlamalar o'chadi",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () => _confirmClear(context, ref),
                ),
              ],
            ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Color _bgColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? const Color(0xFF0F0F0F)
        : const Color(0xFFF2F3F7);
  }

  static Widget _divider() => const Divider(height: 1, indent: 56);

  // ── Pickers ──────────────────────────────────────────────────────────────────

  void _pickLanguage(
      BuildContext context, WidgetRef ref, AppSettingsState settings) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {'uz': l10n.uzbek, 'ru': l10n.russian, 'en': l10n.english};
    _showActionSheet(
      context,
      title: l10n.language,
      options: labels.entries
          .map((e) => _SheetOption(
                label: e.value,
                selected: e.key == settings.language,
                onTap: () =>
                    ref.read(appSettingsProvider.notifier).setLanguage(e.key),
              ))
          .toList(),
    );
  }

  void _pickCurrency(
      BuildContext context, WidgetRef ref, AppSettingsState settings) {
    final l10n = AppLocalizations.of(context)!;
    const currencies = ['UZS', 'USD', 'EUR', 'RUB', 'GBP', 'KZT'];
    _showActionSheet(
      context,
      title: l10n.baseCurrency,
      options: currencies
          .map((c) => _SheetOption(
                label: c,
                selected: c == settings.baseCurrency,
                onTap: () =>
                    ref.read(appSettingsProvider.notifier).setBaseCurrency(c),
              ))
          .toList(),
    );
  }

  void _pickTheme(
      BuildContext context, WidgetRef ref, AppSettingsState settings) {
    final l10n = AppLocalizations.of(context)!;
    final modes = {
      ThemeMode.system: l10n.system,
      ThemeMode.light: l10n.light,
      ThemeMode.dark: l10n.dark,
    };
    _showActionSheet(
      context,
      title: l10n.theme,
      options: modes.entries
          .map((e) => _SheetOption(
                label: e.value,
                selected: e.key == settings.themeMode,
                onTap: () =>
                    ref.read(appSettingsProvider.notifier).setTheme(e.key),
              ))
          .toList(),
    );
  }

  void _pickAutoLock(
      BuildContext context, WidgetRef ref, AppSettingsState settings) {
    final l10n = AppLocalizations.of(context)!;
    final opts = {0: l10n.never, 1: l10n.minute1, 5: l10n.minutes5, 10: l10n.minutes10, 30: l10n.minutes30};
    _showActionSheet(
      context,
      title: l10n.autoLock,
      options: opts.entries
          .map((e) => _SheetOption(
                label: e.value,
                selected: e.key == settings.autoLockMinutes,
                onTap: () =>
                    ref.read(appSettingsProvider.notifier).setAutoLock(e.key),
              ))
          .toList(),
    );
  }

  void _showActionSheet(BuildContext context,
      {required String title, required List<_SheetOption> options}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(title,
                  style: GoogleFonts.sora(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...options.map((o) => ListTile(
                    title: Text(o.label, style: GoogleFonts.inter(fontSize: 15)),
                    trailing: o.selected
                        ? const Icon(Icons.check, color: AppTheme.accent)
                        : null,
                    onTap: () {
                      o.onTap();
                      Navigator.pop(ctx);
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Change PIN ────────────────────────────────────────────────────────────────
  void _showChangePinSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.changePin,
                  style: GoogleFonts.sora(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              TextField(
                controller: currentCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: l10n.currentPin,
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: l10n.newPin,
                  prefixIcon: const Icon(Icons.pin_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: l10n.confirmPin,
                  prefixIcon: const Icon(Icons.pin_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!,
                    style: const TextStyle(color: AppTheme.danger, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  final ok = await PinService.verifyPin(currentCtrl.text);
                  if (!ok) {
                    setState(() => error = l10n.wrongPin);
                    return;
                  }
                  if (newCtrl.text.length < 4) {
                    setState(() => error = l10n.pinMismatch);
                    return;
                  }
                  if (newCtrl.text != confirmCtrl.text) {
                    setState(() => error = l10n.pinMismatch);
                    return;
                  }
                  await PinService.setPin(newCtrl.text);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.pinSet)));
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Backup / Restore ──────────────────────────────────────────────────────────
  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    try {
      final db = ref.read(databaseProvider);
      final accounts = await db.accountsDao.getAllAccounts();
      final transactions = await db.transactionsDao.getAllTransactions();
      final settings = await db.settingsDao.getAllSettings();

      final backup = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'accounts': accounts.map((a) => {
              'id': a.id,
              'name': a.name,
              'type': a.type,
              'currency': a.currency,
              'balance': a.balance,
            }).toList(),
        'transactions': transactions.map((t) => {
              'id': t.id,
              'accountId': t.accountId,
              'categoryId': t.categoryId,
              'type': t.type,
              'amount': t.amount,
              'currency': t.currency,
              'note': t.note,
              'date': t.date.toIso8601String(),
            }).toList(),
        'settings': settings,
      };

      final json = jsonEncode(backup);
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/hisobkit_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(json);
      await Share.shareXFiles([XFile(file.path)], subject: 'HisobKit Backup');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Backup failed: $e')));
      }
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (result == null || result.files.single.path == null) return;

      final json = await File(result.files.single.path!).readAsString();
      final data = jsonDecode(json) as Map<String, dynamic>;

      if (data['version'] != 1) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid backup file')));
        }
        return;
      }

      if (context.mounted) {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Ma'lumotlarni tiklash"),
            content: const Text(
                "Bu barcha mavjud ma'lumotlarni almashtiradi. Davom etasizmi?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Bekor')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Tiklash')),
            ],
          ),
        );
        if (ok != true) return;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ma'lumotlar tiklandi")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Restore failed: $e')));
      }
    }
  }

  // ── Clear data ────────────────────────────────────────────────────────────────
  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    // First ask for PIN confirmation
    final l10n = AppLocalizations.of(context)!;
    final pinCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dangerZone),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Barcha ma'lumotlarni o'chirish uchun PIN kiriting.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 8,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'PIN'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () async {
              final verified = await PinService.verifyPin(pinCtrl.text);
              if (verified && ctx.mounted) {
                Navigator.pop(ctx, true);
              } else if (ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(l10n.wrongPin)));
              }
            },
            child: Text("O'chirish",
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      await EncryptionService.deleteKey();
      await PinService.clearPin();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Barcha ma'lumotlar o'chirildi. Ilovani qayta ishga tushiring.")));
      }
    }
  }
}

// ── UI Components ─────────────────────────────────────────────────────────────

/// Payme uslubidagi profil header — gradient fon, markazda katta doira avatar,
/// ism va email pastida, versiya badge va chiqish tugmasi.
class _ProfileHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authFlowProvider);
    final user = authState is AuthFlowSuccess ? authState.user : null;
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, Color(0xFF0D2B4A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          // Decorative circles (background)
          Positioned(
            right: -30, top: top - 10,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            left: -40, bottom: 20,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 12, 20, 28),
            child: Column(
              children: [
                // Top bar: title + house shortcut
                Row(
                  children: [
                    Text(
                      'Profil',
                      style: GoogleFonts.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    // Uy xarajatlari shortcut
                    GestureDetector(
                      onTap: () => context.push('/house'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.home_work_outlined,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (user != null) ...[
                  // ── LOGGED IN: Avatar + info ───────────────────────────
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: ClipOval(
                          child: user.avatarUrl != null
                              ? Image.network(
                                  user.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _defaultAvatar(user.displayName),
                                )
                              : _defaultAvatar(user.displayName),
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.check,
                            size: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.displayName.isNotEmpty ? user.displayName : 'Foydalanuvchi',
                    style: GoogleFonts.sora(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.maskedEmail,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                  // Provider chip (email / google)
                  if (user.providers.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.providers.contains('google')
                            ? '🔵 Google orqali kirgan'
                            : '📧 Email orqali kirgan',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: Colors.white70),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(icon: Icons.shield_outlined, label: 'AES-256'),
                      const SizedBox(width: 10),
                      _StatChip(icon: Icons.wifi_off_outlined, label: 'Offline'),
                      const SizedBox(width: 10),
                      _StatChip(
                          icon: Icons.new_releases_outlined,
                          label: 'v${UpdateChecker.currentVersion}'),
                    ],
                  ),
                  // Logout
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => ref.read(authFlowProvider.notifier).logout(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 15, color: Colors.red[300]),
                        const SizedBox(width: 6),
                        Text(
                          'Chiqish',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.red[300]),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // ── NOT LOGGED IN: Guest state ─────────────────────────
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(Icons.person_outline,
                        color: Colors.white54, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tizimga kirilmagan',
                    style: GoogleFonts.sora(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sinxronizatsiya va xavfsiz zaxira uchun kiring',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Kirish tugmasi
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/auth/welcome'),
                      icon: const Icon(Icons.login, size: 18),
                      label: Text(
                        'Kirish yoki Ro\'yxatdan o\'tish',
                        style: GoogleFonts.sora(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Stats (ham ko'rinadigan bo'lsin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(icon: Icons.shield_outlined, label: 'AES-256'),
                      const SizedBox(width: 10),
                      _StatChip(icon: Icons.wifi_off_outlined, label: 'Offline'),
                      const SizedBox(width: 10),
                      _StatChip(
                          icon: Icons.new_releases_outlined,
                          label: 'v${UpdateChecker.currentVersion}'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(String? name) {
    final initials = (name?.isNotEmpty == true)
        ? name!.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'H';
    return Container(
      color: AppTheme.accent.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.sora(
            fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;
  final Color? color;
  const _GroupLabel(this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color ?? AppTheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final List<Widget> children;
  final Color? borderColor;
  const _GroupCard({required this.children, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.0 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  const _PickerTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: _iconBox(icon),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _ArrowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _ArrowTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: _iconBox(icon),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey))
          : null,
      trailing:
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}

Widget _iconBox(IconData icon) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: AppTheme.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: AppTheme.primary, size: 20),
  );
}

class _BiometricRow extends ConsumerWidget {
  final AppSettingsState settings;
  const _BiometricRow({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<bool>(
      future: BiometricService.isAvailable(),
      builder: (ctx, snap) {
        final available = snap.data ?? false;
        return SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          secondary: _iconBox(Icons.fingerprint),
          title: Text(l10n.biometrics, style: GoogleFonts.inter(fontSize: 15)),
          subtitle: !available
              ? Text(l10n.biometricsDisabled,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey))
              : null,
          value: settings.biometricsEnabled && available,
          activeThumbColor: AppTheme.accent,
          onChanged: available
              ? (v) => ref.read(appSettingsProvider.notifier).setBiometrics(v)
              : null,
        );
      },
    );
  }
}

// ── Exchange Rates Sheet ──────────────────────────────────────────────────────
class _ExchangeRatesSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ExchangeRatesSheet> createState() =>
      _ExchangeRatesSheetState();
}

class _ExchangeRatesSheetState extends ConsumerState<_ExchangeRatesSheet> {
  final Map<String, TextEditingController> _ctrls = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final currencies = await db.currenciesDao.getAllCurrencies();
    for (final c in currencies) {
      if (c.code != 'UZS') {
        _ctrls[c.code] =
            TextEditingController(text: c.exchangeRate.toString());
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.exchangeRates,
              style:
                  GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ..._ctrls.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: e.value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '1 ${e.key} = ? UZS',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )),
          FilledButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              for (final e in _ctrls.entries) {
                final rate = double.tryParse(e.value.text) ?? 1.0;
                await db.currenciesDao.updateExchangeRate(e.key, rate);
              }
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.savedSuccessfully)));
              }
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

// ── Update Checker Tile ───────────────────────────────────────────────────────
class _UpdateCheckerTile extends StatefulWidget {
  @override
  State<_UpdateCheckerTile> createState() => _UpdateCheckerTileState();
}

class _UpdateCheckerTileState extends State<_UpdateCheckerTile> {
  bool _checking = false;

  Future<void> _check() async {
    if (_checking) return;
    setState(() => _checking = true);

    final l10n = AppLocalizations.of(context)!;

    try {
      final info = await UpdateChecker.checkForUpdate();

      if (!mounted) return;

      if (info == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.updateCheckFailed)),
        );
        return;
      }

      if (!info.isNewer) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.alreadyUpToDate),
            backgroundColor: AppTheme.accent,
          ),
        );
        return;
      }

      // Show update dialog
      await showDialog(
        context: context,
        builder: (ctx) => _UpdateDialog(info: info),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: _iconBox(Icons.system_update_outlined),
      title: Text(
        _checking ? l10n.checking : l10n.checkForUpdates,
        style: GoogleFonts.inter(fontSize: 15),
      ),
      trailing: _checking
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: _check,
    );
  }
}

class _UpdateDialog extends StatefulWidget {
  final ReleaseInfo info;
  const _UpdateDialog({required this.info});

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  // null = idle, 0.0–1.0 = downloading, -1 = error
  double? _progress;
  bool _installing = false;

  Future<void> _startDownload() async {
    setState(() => _progress = 0.0);

    final path = await UpdateChecker.downloadApk(
      widget.info.downloadUrl,
      onProgress: (p) {
        if (mounted) setState(() => _progress = p);
      },
    );

    if (!mounted) return;

    if (path == null) {
      setState(() => _progress = -1);
      return;
    }

    setState(() => _installing = true);
    await OpenFile.open(path);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notes = widget.info.body.length > 400
        ? '${widget.info.body.substring(0, 400)}…'
        : widget.info.body;

    final isDownloading = _progress != null && _progress! >= 0 && !_installing;
    final isError = _progress == -1;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient header ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, Color(0xFF163A5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.new_releases,
                        color: AppTheme.accent, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      l10n.newVersionAvailable,
                      style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _versionChip(l10n.currentVersionLabel,
                        UpdateChecker.currentVersion, Colors.white24),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward,
                        size: 16, color: Colors.white54),
                    const SizedBox(width: 8),
                    _versionChip(l10n.latestVersionLabel,
                        widget.info.version, AppTheme.accent),
                  ],
                ),
              ],
            ),
          ),

          // ── Progress / status ─────────────────────────────────────────
          if (isDownloading || _installing)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _installing
                            ? 'O\'rnatilmoqda...'
                            : 'Yuklanmoqda... ${((_progress ?? 0) * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary),
                      ),
                      if (!_installing)
                        Text(
                          '${((_progress ?? 0) * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.sora(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accent),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _installing ? null : _progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accent),
                    ),
                  ),
                ],
              ),
            ),

          if (isError)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Yuklab bo\'lmadi. Internet tekshiring.',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.red.shade700),
                  ),
                ],
              ),
            ),

          // ── Release notes ─────────────────────────────────────────────
          if (notes.isNotEmpty && !isDownloading && !_installing)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.releaseNotes,
                      style: GoogleFonts.sora(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary)),
                  const SizedBox(height: 8),
                  Text(
                    notes,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
      actions: [
        // "Keyinroq" faqat yuklanmayotganda ko'rsatiladi
        if (!isDownloading && !_installing)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keyinroq'),
          ),

        // Asosiy tugma
        if (!_installing)
          FilledButton.icon(
            icon: Icon(
              isError ? Icons.refresh : Icons.download,
              size: 18,
            ),
            label: Text(isDownloading
                ? 'Yuklanmoqda...'
                : isError
                    ? 'Qayta urinish'
                    : l10n.updateNow),
            onPressed: isDownloading ? null : _startDownload,
            style: FilledButton.styleFrom(
              backgroundColor: isError ? Colors.red : AppTheme.accent,
              disabledBackgroundColor: AppTheme.accent.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
      ],
    );
  }

  Widget _versionChip(String label, String version, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(fontSize: 9, color: Colors.white70)),
          Text(version,
              style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

// ── Helper ─────────────────────────────────────────────────────────────────────
class _SheetOption {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SheetOption(
      {required this.label, required this.selected, required this.onTap});
}
