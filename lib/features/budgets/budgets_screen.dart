import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/icon_map.dart';
import '../../core/utils/category_utils.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/transaction_providers.dart';
import 'budget_providers.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetsAsync = ref.watch(allBudgetsProvider);
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgets)),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pie_chart_outline,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noBudgets,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => _showBudgetForm(context, ref),
                    child: Text(l10n.addBudget),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: budgets.length,
            itemBuilder: (ctx, i) => _BudgetCard(
              budget: budgets[i],
              currency: currency,
              ref: ref,
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBudgetForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showBudgetForm(BuildContext context, WidgetRef ref,
      {Budget? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _BudgetForm(existing: existing, ref: ref),
    );
  }
}

class _BudgetCard extends ConsumerWidget {
  final Budget budget;
  final String currency;
  final WidgetRef ref;

  const _BudgetCard(
      {required this.budget,
      required this.currency,
      required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final spentAsync = ref.watch(budgetSpentProvider(
        (budget.categoryId, budget.startDate, budget.endDate)));
    final categoryAsync =
        ref.watch(categoryByIdProvider(budget.categoryId));
    final now = DateTime.now();
    final isActive = budget.startDate.isBefore(now) &&
        budget.endDate.isAfter(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                categoryAsync.when(
                  data: (cat) => cat != null
                      ? Row(children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                AppTheme.colorFromHex(cat.color),
                            child: Icon(IconMap.get(cat.icon),
                                size: 18, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(cat.localizedName(language),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium),
                        ])
                      : const SizedBox(),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
                const Spacer(),
                if (!isActive)
                  Chip(
                    label: Text(AppLocalizations.of(context)!.done),
                    backgroundColor: Colors.grey.shade200,
                  ),
                PopupMenuButton(
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context)!.edit)),
                    PopupMenuItem(
                        value: 'delete', child: Text(AppLocalizations.of(context)!.delete)),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) =>
                            _BudgetForm(existing: budget, ref: ref),
                      );
                    } else {
                      _deleteBudget(context, ref);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            spentAsync.when(
              data: (spent) {
                final pct = budget.amount > 0
                    ? (spent / budget.amount).clamp(0.0, 1.0)
                    : 0.0;
                final remaining = budget.amount - spent;
                Color barColor = AppTheme.incomeColor;
                if (pct >= 1.0) barColor = AppTheme.expenseColor;
                else if (pct >= (budget.alertAtPercent / 100)) barColor = Colors.orange;

                final l10n = AppLocalizations.of(context)!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.spent}: ${CurrencyFormatter.format(spent, currency)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${l10n.ofWord} ${CurrencyFormatter.format(budget.amount, currency)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            AlwaysStoppedAnimation(barColor),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      remaining >= 0
                          ? '${l10n.remaining}: ${CurrencyFormatter.format(remaining, currency)}'
                          : '${CurrencyFormatter.format(-remaining, currency)}',
                      style: TextStyle(
                        color: remaining >= 0
                            ? AppTheme.incomeColor
                            : AppTheme.expenseColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 8),
            Text(
              '${budget.period} • ${DateFormatter.formatShort(budget.startDate)} – ${DateFormatter.formatShort(budget.endDate)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteBudget(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteBudget),
        content: Text(l10n.deleteBudgetConfirm),
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
    if (confirmed == true && context.mounted) {
      final db = ref.read(databaseProvider);
      await db.budgetsDao.deleteBudget(budget.id);
    }
  }
}

class _BudgetForm extends ConsumerStatefulWidget {
  final Budget? existing;
  final WidgetRef ref;

  const _BudgetForm({this.existing, required this.ref});

  @override
  ConsumerState<_BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends ConsumerState<_BudgetForm> {
  final _amountController = TextEditingController();
  int? _categoryId;
  String _period = 'monthly';
  DateTime _startDate = DateTime.now();
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  int _alertPercent = 80;
  String _currency = 'UZS';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider).value;
    _currency = settings?.baseCurrency ?? 'UZS';

    if (widget.existing != null) {
      final b = widget.existing!;
      _amountController.text = b.amount.toString();
      _categoryId = b.categoryId;
      _period = b.period;
      _startDate = b.startDate;
      _endDate = b.endDate;
      _alertPercent = b.alertAtPercent;
      _currency = b.currency;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_amountController.text.isEmpty || _categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.requiredField)));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final amount = double.parse(_amountController.text);
      final companion = BudgetsCompanion(
        id: widget.existing != null
            ? Value(widget.existing!.id)
            : const Value.absent(),
        categoryId: Value(_categoryId!),
        amount: Value(amount),
        currency: Value(_currency),
        period: Value(_period),
        startDate: Value(_startDate),
        endDate: Value(_endDate),
        alertAtPercent: Value(_alertPercent),
      );

      if (widget.existing != null) {
        await db.budgetsDao.updateBudget(companion);
      } else {
        await db.budgetsDao.insertBudget(companion);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final categoriesAsync =
        ref.watch(categoriesByTypeProvider('expense'));

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
            Text(
              widget.existing != null ? l10n.editBudget : l10n.addBudget,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            categoriesAsync.when(
              data: (cats) => DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: InputDecoration(labelText: l10n.category),
                items: cats
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.localizedName(language)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l10n.budgetAmount),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _period,
              decoration: InputDecoration(labelText: l10n.budgetPeriod),
              items: [
                DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
                DropdownMenuItem(value: 'yearly', child: Text(l10n.yearly)),
              ],
              onChanged: (v) => setState(() => _period = v!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _startDate = d);
                    },
                    child: InputDecorator(
                      decoration:
                          InputDecoration(labelText: l10n.startDate),
                      child: Text(DateFormatter.formatShort(_startDate)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _endDate = d);
                    },
                    child: InputDecorator(
                      decoration:
                          InputDecoration(labelText: l10n.endDate),
                      child: Text(DateFormatter.formatShort(_endDate)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('${l10n.alertAt}: $_alertPercent%'),
            Slider(
              value: _alertPercent.toDouble(),
              min: 50,
              max: 100,
              divisions: 10,
              label: '$_alertPercent%',
              onChanged: (v) => setState(() => _alertPercent = v.round()),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child:
                  Text(widget.existing != null ? l10n.save : l10n.addBudget),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
