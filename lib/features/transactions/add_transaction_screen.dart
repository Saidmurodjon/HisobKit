import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/icon_map.dart';
import '../../core/utils/category_utils.dart';
import '../../core/providers/settings_provider.dart';
import 'transaction_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final int? transactionId;

  const AddTransactionScreen({super.key, this.transactionId});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = 'expense';
  int? _accountId;
  int? _toAccountId;
  int? _categoryId;
  DateTime _date = DateTime.now();
  String _currency = 'UZS';
  bool _isRecurring = false;
  String _recurrenceRule = 'monthly';
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      _loadExisting();
    }
    final settings = ref.read(appSettingsProvider).value;
    _currency = settings?.baseCurrency ?? 'UZS';
  }

  Future<void> _loadExisting() async {
    final db = ref.read(databaseProvider);
    final all = await db.transactionsDao.getAllTransactions();
    final tx =
        all.firstWhere((t) => t.id == widget.transactionId!, orElse: () => throw Exception());
    setState(() {
      _isEditing = true;
      _type = tx.type;
      _amountController.text = tx.amount.toString();
      _noteController.text = tx.note;
      _accountId = tx.accountId;
      _toAccountId = tx.toAccountId;
      _categoryId = tx.categoryId;
      _date = tx.date;
      _currency = tx.currency;
      _isRecurring = tx.isRecurring;
      _recurrenceRule = tx.recurrenceRule ?? 'monthly';
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.requiredField)));
      return;
    }
    if (_type != 'transfer' && _categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.requiredField)));
      return;
    }
    if (_type == 'transfer' && _toAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.requiredField)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      final amount = double.parse(_amountController.text.replaceAll(',', '.'));

      final companion = TransactionsCompanion(
        id: _isEditing
            ? Value(widget.transactionId!)
            : const Value.absent(),
        accountId: Value(_accountId!),
        categoryId: Value(_categoryId),
        toAccountId: Value(_toAccountId),
        type: Value(_type),
        amount: Value(amount),
        currency: Value(_currency),
        note: Value(_noteController.text.trim()),
        date: Value(_date),
        isRecurring: Value(_isRecurring),
        recurrenceRule:
            Value(_isRecurring ? _recurrenceRule : null),
      );

      if (_isEditing) {
        await db.transactionsDao.updateTransaction(companion);
        // Update account balance
        await _updateBalances(db, amount, isEdit: true);
      } else {
        await db.transactionsDao.insertTransaction(companion);
        await _updateBalances(db, amount);
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        // Invalidate future providers so they refresh on next watch
        ref.invalidate(monthlyTotalProvider);
        ref.invalidate(recentTransactionsProvider);
        ref.invalidate(accountsStreamProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n.savedSuccessfully)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorOccurred}: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateBalances(dynamic db, double amount,
      {bool isEdit = false}) async {
    final account = await db.accountsDao.getAccountById(_accountId!);
    if (account == null) return;

    if (_type == 'income') {
      await db.accountsDao
          .updateBalance(_accountId!, account.balance + amount);
    } else if (_type == 'expense') {
      await db.accountsDao
          .updateBalance(_accountId!, account.balance - amount);
    } else if (_type == 'transfer' && _toAccountId != null) {
      final toAccount = await db.accountsDao.getAccountById(_toAccountId!);
      if (toAccount != null) {
        await db.accountsDao
            .updateBalance(_accountId!, account.balance - amount);
        await db.accountsDao
            .updateBalance(_toAccountId!, toAccount.balance + amount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accountsAsync = ref.watch(accountsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editTransaction : l10n.addTransaction),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(l10n.save),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                        value: 'expense',
                        label: Text(l10n.expense),
                        icon: const Icon(Icons.arrow_upward)),
                    ButtonSegment(
                        value: 'income',
                        label: Text(l10n.income),
                        icon: const Icon(Icons.arrow_downward)),
                    ButtonSegment(
                        value: 'transfer',
                        label: Text(l10n.transfer),
                        icon: const Icon(Icons.swap_horiz)),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) =>
                      setState(() => _type = s.first),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixIcon: const Icon(Icons.attach_money),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.requiredField;
                final n = double.tryParse(v.replaceAll(',', '.'));
                if (n == null || n <= 0) return l10n.amountMustBePositive;
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Currency
            _CurrencySelector(
              selected: _currency,
              onChanged: (c) => setState(() => _currency = c),
            ),
            const SizedBox(height: 16),

            // Account selector
            accountsAsync.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addAccount),
                    onPressed: () => context.push('/accounts/add'),
                  );
                }
                return DropdownButtonFormField<int>(
                  value: _accountId,
                  decoration: InputDecoration(
                    labelText: l10n.account,
                    prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  ),
                  items: accounts
                      .map((a) => DropdownMenuItem(
                            value: a.id,
                            child: Text(
                                '${a.name} (${CurrencyFormatter.format(a.balance, a.currency)})'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _accountId = v),
                  validator: (v) => v == null ? l10n.requiredField : null,
                );
              },
              loading: () => const CircularProgressIndicator.adaptive(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 16),

            // To account (transfer only)
            if (_type == 'transfer')
              accountsAsync.when(
                data: (accounts) => DropdownButtonFormField<int>(
                  value: _toAccountId,
                  decoration: InputDecoration(
                    labelText: l10n.toAccount,
                    prefixIcon: const Icon(Icons.account_balance_outlined),
                  ),
                  items: accounts
                      .where((a) => a.id != _accountId)
                      .map((a) => DropdownMenuItem(
                            value: a.id,
                            child: Text(a.name),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _toAccountId = v),
                  validator: (v) =>
                      _type == 'transfer' && v == null
                          ? l10n.requiredField
                          : null,
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            if (_type == 'transfer') const SizedBox(height: 16),

            // Category (not for transfer)
            if (_type != 'transfer')
              _CategorySelector(
                type: _type,
                selectedId: _categoryId,
                onChanged: (id) => setState(() => _categoryId = id),
              ),
            if (_type != 'transfer') const SizedBox(height: 16),

            // Date picker
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.date,
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(DateFormatter.format(_date)),
              ),
            ),
            const SizedBox(height: 16),

            // Note
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: l10n.note,
                prefixIcon: const Icon(Icons.note_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Recurring
            SwitchListTile(
              value: _isRecurring,
              onChanged: (v) => setState(() => _isRecurring = v),
              title: Text(l10n.recurring),
              subtitle: Text(l10n.recurrenceRule),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _recurrenceRule,
                decoration:
                    InputDecoration(labelText: l10n.recurrenceRule),
                items: [
                  DropdownMenuItem(value: 'daily', child: Text(l10n.daily)),
                  DropdownMenuItem(value: 'weekly', child: Text(l10n.weekly)),
                  DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
                  DropdownMenuItem(value: 'yearly', child: Text(l10n.yearly)),
                ],
                onChanged: (v) =>
                    setState(() => _recurrenceRule = v!),
              ),
            ],
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: Text(_isEditing ? l10n.save : l10n.addTransaction),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }
}

class _CurrencySelector extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;

  const _CurrencySelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const currencies = ['UZS', 'USD', 'EUR', 'RUB', 'GBP', 'KZT'];
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(
        labelText: l10n.currency,
        prefixIcon: const Icon(Icons.monetization_on_outlined),
      ),
      items: currencies
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) => onChanged(v!),
    );
  }
}

class _CategorySelector extends ConsumerWidget {
  final String type;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _CategorySelector({
    required this.type,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final categoriesAsync = ref.watch(categoriesByTypeProvider(type));

    return categoriesAsync.when(
      data: (cats) => DropdownButtonFormField<int>(
        value: selectedId,
        decoration: InputDecoration(
          labelText: l10n.category,
          prefixIcon: const Icon(Icons.category_outlined),
        ),
        items: cats.map((c) {
          return DropdownMenuItem(
            value: c.id,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppTheme.colorFromHex(c.color),
                  child: Icon(IconMap.get(c.icon),
                      size: 14, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(c.localizedName(language)),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? l10n.requiredField : null,
      ),
      loading: () => const CircularProgressIndicator.adaptive(),
      error: (_, __) => const SizedBox(),
    );
  }
}
