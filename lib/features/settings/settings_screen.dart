import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';
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
      appBar: AppBar(title: Text(l10n.settings)),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(8),
          children: [
            _SectionHeader(l10n.language),
            _LanguageTile(settings: settings, ref: ref),
            _CurrencyTile(settings: settings, ref: ref),
            _ThemeTile(settings: settings, ref: ref),
            const Divider(),
            _SectionHeader(l10n.biometrics),
            _BiometricsTile(settings: settings, ref: ref),
            _AutoLockTile(settings: settings, ref: ref),
            _ChangePinTile(ref: ref),
            const Divider(),
            _SectionHeader(l10n.exchangeRates),
            _ExchangeRatesTile(ref: ref),
            const Divider(),
            _SectionHeader(l10n.backupData),
            _BackupTile(ref: ref),
            _RestoreTile(ref: ref),
            _ExportSectionTile(ref: ref),
            const Divider(),
            _SectionHeader(l10n.about),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.version),
              trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
            ),
            const Divider(),
            _SectionHeader(l10n.dangerZone, color: AppTheme.expenseColor),
            _ClearDataTile(ref: ref),
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;
  const _SectionHeader(this.title, {this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color ?? Theme.of(context).colorScheme.primary,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ── Language ──────────────────────────────────────────────────────────────────
class _LanguageTile extends StatelessWidget {
  final AppSettingsState settings;
  final WidgetRef ref;
  const _LanguageTile({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {'uz': l10n.uzbek, 'ru': l10n.russian, 'en': l10n.english};
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      trailing: Text(labels[settings.language] ?? settings.language,
          style: const TextStyle(color: Colors.grey)),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l10n.language),
          children: labels.entries
              .map((e) => RadioListTile<String>(
                    value: e.key,
                    groupValue: settings.language,
                    title: Text(e.value),
                    onChanged: (v) {
                      ref.read(appSettingsProvider.notifier).setLanguage(v!);
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Base Currency ─────────────────────────────────────────────────────────────
class _CurrencyTile extends StatelessWidget {
  final AppSettingsState settings;
  final WidgetRef ref;
  const _CurrencyTile({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const currencies = ['UZS', 'USD', 'EUR', 'RUB', 'GBP', 'KZT'];
    return ListTile(
      leading: const Icon(Icons.monetization_on_outlined),
      title: Text(l10n.baseCurrency),
      trailing: Text(settings.baseCurrency,
          style: const TextStyle(color: Colors.grey)),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l10n.baseCurrency),
          children: currencies
              .map((c) => RadioListTile<String>(
                    value: c,
                    groupValue: settings.baseCurrency,
                    title: Text(c),
                    onChanged: (v) {
                      ref
                          .read(appSettingsProvider.notifier)
                          .setBaseCurrency(v!);
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Theme ─────────────────────────────────────────────────────────────────────
class _ThemeTile extends StatelessWidget {
  final AppSettingsState settings;
  final WidgetRef ref;
  const _ThemeTile({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      ThemeMode.system: l10n.system,
      ThemeMode.light: l10n.light,
      ThemeMode.dark: l10n.dark,
    };
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.theme),
      trailing: Text(labels[settings.themeMode] ?? l10n.system,
          style: const TextStyle(color: Colors.grey)),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l10n.theme),
          children: labels.entries
              .map((e) => RadioListTile<ThemeMode>(
                    value: e.key,
                    groupValue: settings.themeMode,
                    title: Text(e.value),
                    onChanged: (v) {
                      ref.read(appSettingsProvider.notifier).setTheme(v!);
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Biometrics ────────────────────────────────────────────────────────────────
class _BiometricsTile extends ConsumerWidget {
  final AppSettingsState settings;
  final WidgetRef ref;
  const _BiometricsTile({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<bool>(
      future: BiometricService.isAvailable(),
      builder: (ctx, snap) {
        final available = snap.data ?? false;
        return SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: Text(l10n.biometrics),
          subtitle: available
              ? null
              : Text(l10n.biometricsDisabled),
          value: settings.biometricsEnabled && available,
          onChanged: available
              ? (v) => ref
                  .read(appSettingsProvider.notifier)
                  .setBiometrics(v)
              : null,
        );
      },
    );
  }
}

// ── Auto Lock ─────────────────────────────────────────────────────────────────
class _AutoLockTile extends StatelessWidget {
  final AppSettingsState settings;
  final WidgetRef ref;
  const _AutoLockTile({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = {0: l10n.never, 1: l10n.minute1, 5: l10n.minutes5, 10: l10n.minutes10, 30: l10n.minutes30};
    return ListTile(
      leading: const Icon(Icons.lock_clock_outlined),
      title: Text(l10n.autoLock),
      trailing: Text(options[settings.autoLockMinutes] ?? '${settings.autoLockMinutes}',
          style: const TextStyle(color: Colors.grey)),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l10n.autoLock),
          children: options.entries
              .map((e) => RadioListTile<int>(
                    value: e.key,
                    groupValue: settings.autoLockMinutes,
                    title: Text(e.value),
                    onChanged: (v) {
                      ref
                          .read(appSettingsProvider.notifier)
                          .setAutoLock(v!);
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Change PIN ────────────────────────────────────────────────────────────────
class _ChangePinTile extends StatelessWidget {
  final WidgetRef ref;
  const _ChangePinTile({required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.pin_outlined),
      title: Text(l10n.changePin),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showChangePinDialog(context),
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.changePin),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(labelText: l10n.currentPin),
              ),
              TextField(
                controller: newCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(labelText: l10n.newPin),
              ),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(labelText: l10n.confirmPin),
              ),
              if (error != null)
                Text(error!,
                    style: const TextStyle(color: AppTheme.expenseColor)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel)),
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
                  ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text(l10n.pinSet)));
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Exchange Rates ────────────────────────────────────────────────────────────
class _ExchangeRatesTile extends ConsumerWidget {
  final WidgetRef ref;
  const _ExchangeRatesTile({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.currency_exchange),
      title: Text(l10n.exchangeRates),
      subtitle: Text(l10n.updateRate),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showRatesDialog(context, ref),
    );
  }

  void _showRatesDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ExchangeRatesSheet(ref: ref),
    );
  }
}

class _ExchangeRatesSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _ExchangeRatesSheet({required this.ref});

  @override
  ConsumerState<_ExchangeRatesSheet> createState() =>
      _ExchangeRatesSheetState();
}

class _ExchangeRatesSheetState extends ConsumerState<_ExchangeRatesSheet> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    final db = ref.read(databaseProvider);
    final currencies = await db.currenciesDao.getAllCurrencies();
    for (final c in currencies) {
      if (c.code != 'UZS') {
        _controllers[c.code] =
            TextEditingController(text: c.exchangeRate.toString());
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.exchangeRates,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ..._controllers.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: e.value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '1 ${e.key} = ? UZS',
                  ),
                ),
              )),
          FilledButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              for (final e in _controllers.entries) {
                final rate = double.tryParse(e.value.text) ?? 1.0;
                await db.currenciesDao.updateExchangeRate(e.key, rate);
              }
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.savedSuccessfully)));
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

// ── Backup ────────────────────────────────────────────────────────────────────
class _BackupTile extends ConsumerWidget {
  final WidgetRef ref;
  const _BackupTile({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.backup_outlined),
      title: const Text('Backup Data'),
      subtitle: const Text('Export all data as JSON'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _backup(context, ref),
    );
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    try {
      final db = ref.read(databaseProvider);
      final accounts = await db.accountsDao.getAllAccounts();
      final transactions = await db.transactionsDao.getAllTransactions();
      final categories = await db.categoriesDao.getAllCategories();
      final budgets = await db.budgetsDao.getAllBudgets();
      final debts = await db.debtsDao.getAllDebts();
      final settings = await db.settingsDao.getAllSettings();

      final backup = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'accounts': accounts
            .map((a) => {
                  'id': a.id,
                  'name': a.name,
                  'type': a.type,
                  'currency': a.currency,
                  'balance': a.balance,
                  'icon': a.icon,
                  'color': a.color,
                })
            .toList(),
        'transactions': transactions
            .map((t) => {
                  'id': t.id,
                  'accountId': t.accountId,
                  'categoryId': t.categoryId,
                  'type': t.type,
                  'amount': t.amount,
                  'currency': t.currency,
                  'note': t.note,
                  'date': t.date.toIso8601String(),
                  'isRecurring': t.isRecurring,
                  'recurrenceRule': t.recurrenceRule,
                })
            .toList(),
        'settings': settings,
      };

      final json = jsonEncode(backup);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/hisobkit_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(json);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'HisobKit Backup',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Backup failed: $e')));
      }
    }
  }
}

// ── Restore ───────────────────────────────────────────────────────────────────
class _RestoreTile extends ConsumerWidget {
  final WidgetRef ref;
  const _RestoreTile({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.restore_outlined),
      title: const Text('Restore Data'),
      subtitle: const Text('Import from JSON backup file'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _restore(context, ref),
    );
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final json = await file.readAsString();
      final data = jsonDecode(json) as Map<String, dynamic>;

      if (data['version'] != 1) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid backup file')));
        }
        return;
      }

      // Show confirmation
      if (context.mounted) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Restore Data'),
            content: const Text(
                'This will replace all current data. Continue?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Restore')),
            ],
          ),
        );
        if (confirmed != true) return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data restored successfully')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Restore failed: $e')));
      }
    }
  }
}

// ── Export ────────────────────────────────────────────────────────────────────
class _ExportSectionTile extends StatelessWidget {
  final WidgetRef ref;
  const _ExportSectionTile({required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_download_outlined),
      title: const Text('Export'),
      subtitle: const Text('Export to PDF or Excel'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/export'),
    );
  }
}

// ── Clear Data ────────────────────────────────────────────────────────────────
class _ClearDataTile extends ConsumerWidget {
  final WidgetRef ref;
  const _ClearDataTile({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: AppTheme.expenseColor),
      title: const Text('Clear All Data',
          style: TextStyle(color: AppTheme.expenseColor)),
      subtitle: const Text('Delete all accounts, transactions and settings'),
      onTap: () => _confirmClear(context, ref),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
            'This will permanently delete ALL data including accounts, transactions, and settings. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTheme.expenseColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Delete and regenerate DB key forces a fresh encrypted DB
      await EncryptionService.deleteKey();
      await PinService.clearPin();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All data cleared. Please restart the app.')));
      }
    }
  }
}
