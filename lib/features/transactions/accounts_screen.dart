import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/icon_map.dart';
import '../../core/providers/settings_provider.dart';
import 'transaction_providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accountsAsync = ref.watch(accountsStreamProvider);
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accounts)),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noAccounts,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => _showAccountForm(context, ref),
                    child: Text(l10n.addAccount),
                  ),
                ],
              ),
            );
          }

          final total =
              accounts.fold(0.0, (sum, a) => sum + a.balance);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: Colors.white),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.totalBalance,
                                style: const TextStyle(color: Colors.white70)),
                            Text(
                              CurrencyFormatter.format(total, currency),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: accounts.length,
                  itemBuilder: (ctx, i) => _AccountCard(
                    account: accounts[i],
                    ref: ref,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAccountForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAccountForm(BuildContext context, WidgetRef ref,
      {Account? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AccountForm(existing: existing, ref: ref),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  final Account account;
  final WidgetRef ref;

  const _AccountCard({required this.account, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = AppTheme.colorFromHex(account.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(IconMap.get(account.icon),
              color: Colors.white, size: 22),
        ),
        title: Text(account.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(account.type),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(account.balance, account.currency),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: account.balance >= 0
                    ? AppTheme.incomeColor
                    : AppTheme.expenseColor,
              ),
            ),
            Text(account.currency,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => _AccountForm(existing: account, ref: ref),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AccountForm extends ConsumerStatefulWidget {
  final Account? existing;
  final WidgetRef ref;

  const _AccountForm({this.existing, required this.ref});

  @override
  ConsumerState<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<_AccountForm> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _type = 'cash';
  String _currency = 'UZS';
  String _icon = 'account_balance_wallet';
  Color _color = AppTheme.primaryColor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final a = widget.existing!;
      _nameController.text = a.name;
      _balanceController.text = a.balance.toString();
      _type = a.type;
      _currency = a.currency;
      _icon = a.icon;
      _color = AppTheme.colorFromHex(a.color);
    } else {
      final settings = ref.read(appSettingsProvider).value;
      _currency = settings?.baseCurrency ?? 'UZS';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final balance =
          double.tryParse(_balanceController.text) ?? 0.0;
      final companion = AccountsCompanion(
        id: widget.existing != null
            ? Value(widget.existing!.id)
            : const Value.absent(),
        name: Value(_nameController.text.trim()),
        type: Value(_type),
        currency: Value(_currency),
        balance: Value(balance),
        icon: Value(_icon),
        color: Value(AppTheme.hexFromColor(_color)),
      );

      if (widget.existing != null) {
        await db.accountsDao.updateAccount(companion);
      } else {
        await db.accountsDao.insertAccount(companion);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
    if (widget.existing == null) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final db = ref.read(databaseProvider);
      await db.accountsDao.deleteAccount(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.existing != null ? l10n.editAccount : l10n.addAccount,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                if (widget.existing != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outlined,
                        color: AppTheme.expenseColor),
                    onPressed: _delete,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: l10n.accountName),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _type,
              decoration:
                  InputDecoration(labelText: l10n.accountType),
              items: [
                DropdownMenuItem(value: 'cash', child: Text(l10n.cash)),
                DropdownMenuItem(value: 'card', child: Text(l10n.card)),
                DropdownMenuItem(
                    value: 'savings', child: Text(l10n.savings)),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'))
                    ],
                    decoration: InputDecoration(
                        labelText: l10n.initialBalance),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _currency,
                    decoration:
                        InputDecoration(labelText: l10n.currency),
                    items: ['UZS', 'USD', 'EUR', 'RUB', 'GBP', 'KZT']
                        .map((c) => DropdownMenuItem(
                            value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _currency = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('${l10n.color}: '),
                GestureDetector(
                  onTap: () => _pickColor(context),
                  child: CircleAvatar(
                      backgroundColor: _color, radius: 18),
                ),
                const SizedBox(width: 16),
                Text('${l10n.icon}: '),
                GestureDetector(
                  onTap: () => _pickIcon(context),
                  child: CircleAvatar(
                    backgroundColor: _color,
                    child: Icon(IconMap.get(_icon),
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child:
                  Text(widget.existing != null ? l10n.save : l10n.addAccount),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickColor(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    Color tmp = _color;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.color),
        content: BlockPicker(
          pickerColor: _color,
          onColorChanged: (c) => tmp = c,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              setState(() => _color = tmp);
              Navigator.pop(ctx);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIcon(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final icons = IconMap.allIconNames;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.icon),
        content: SizedBox(
          width: 300,
          height: 300,
          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: icons.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                setState(() => _icon = icons[i]);
                Navigator.pop(ctx);
              },
              child: CircleAvatar(
                backgroundColor: _icon == icons[i]
                    ? _color
                    : Colors.grey.shade200,
                child: Icon(IconMap.get(icons[i]),
                    size: 20,
                    color: _icon == icons[i]
                        ? Colors.white
                        : Colors.grey.shade700),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
        ],
      ),
    );
  }
}
