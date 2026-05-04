import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/icon_map.dart';
import '../../core/utils/category_utils.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/transaction_providers.dart';
import '../budgets/budget_providers.dart';
import '../debts/debt_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: l10n.accounts,
            onPressed: () => context.push('/accounts'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(accountsStreamProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _BalanceCard(currency: currency),
            const SizedBox(height: 16),
            _MonthlySummaryCard(currency: currency),
            const SizedBox(height: 16),
            _ActiveBudgetsSection(currency: currency),
            const SizedBox(height: 16),
            _UpcomingDebtsSection(currency: currency),
            const SizedBox(height: 16),
            _RecentTransactionsSection(currency: currency),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions/add'),
        icon: const Icon(Icons.add),
        label: Text(l10n.quickAdd),
      ),
    );
  }
}

// ── Balance Card ──────────────────────────────────────────────────────────────
class _BalanceCard extends ConsumerWidget {
  final String currency;
  const _BalanceCard({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accountsAsync = ref.watch(accountsStreamProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.totalBalance,
              style: TextStyle(
                color: colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            accountsAsync.when(
              data: (accounts) {
                final total =
                    accounts.fold<double>(0.0, (sum, a) => sum + a.balance);
                return Text(
                  CurrencyFormatter.format(total, currency),
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              loading: () => Text(
                '---',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              error: (_, __) => const Text('Error'),
            ),
            const SizedBox(height: 16),
            accountsAsync.when(
              data: (accounts) => Wrap(
                spacing: 8,
                runSpacing: 4,
                children: accounts.map((a) => Chip(
                  label: Text(
                    '${a.name}: ${CurrencyFormatter.format(a.balance, a.currency)}',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: colorScheme.primary.withOpacity(0.7),
                  side: BorderSide(color: colorScheme.onPrimary.withOpacity(0.3)),
                )).toList(),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Monthly Summary ───────────────────────────────────────────────────────────
class _MonthlySummaryCard extends ConsumerWidget {
  final String currency;
  const _MonthlySummaryCard({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final incomeAsync = ref.watch(monthlyTotalProvider(('income', start, end)));
    final expenseAsync = ref.watch(monthlyTotalProvider(('expense', start, end)));

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: l10n.income,
            valueAsync: incomeAsync,
            currency: currency,
            color: AppTheme.incomeColor,
            icon: Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: l10n.expense,
            valueAsync: expenseAsync,
            currency: currency,
            color: AppTheme.expenseColor,
            icon: Icons.arrow_upward,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final AsyncValue<double> valueAsync;
  final String currency;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.valueAsync,
    required this.currency,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 4),
                Text(label, style: theme.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 8),
            valueAsync.when(
              data: (v) => Text(
                CurrencyFormatter.format(v, currency),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              loading: () => const Text('---'),
              error: (_, __) => const Text('---'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Active Budgets ────────────────────────────────────────────────────────────
class _ActiveBudgetsSection extends ConsumerWidget {
  final String currency;
  const _ActiveBudgetsSection({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetsAsync = ref.watch(activeBudgetsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.activeBudgets,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/budgets'),
              child: Text(l10n.all),
            ),
          ],
        ),
        const SizedBox(height: 8),
        budgetsAsync.when(
          data: (budgets) {
            if (budgets.isEmpty) {
              return _EmptyState(
                icon: Icons.pie_chart_outline,
                message: l10n.noBudgets,
                hint: l10n.noBudgetsHint,
                action: () => context.push('/budgets/add'),
                actionLabel: l10n.addBudget,
              );
            }
            return Column(
              children: budgets
                  .take(3)
                  .map((b) => _BudgetProgressTile(
                        budget: b,
                        currency: currency,
                        ref: ref,
                      ))
                  .toList(),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

class _BudgetProgressTile extends ConsumerWidget {
  final Budget budget;
  final String currency;
  final WidgetRef ref;

  const _BudgetProgressTile({
    required this.budget,
    required this.currency,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final spentAsync = ref.watch(
        budgetSpentProvider((budget.categoryId, budget.startDate, budget.endDate)));
    final categoryAsync = ref.watch(categoryByIdProvider(budget.categoryId));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                categoryAsync.when(
                  data: (cat) => cat != null
                      ? Row(children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor:
                                AppTheme.colorFromHex(cat.color),
                            child: Icon(IconMap.get(cat.icon),
                                size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(cat.localizedName(language),
                              style: Theme.of(context).textTheme.labelLarge),
                        ])
                      : const SizedBox(),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
                const Spacer(),
                spentAsync.when(
                  data: (spent) => Text(
                    '${CurrencyFormatter.format(spent, currency)} / ${CurrencyFormatter.format(budget.amount, currency)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            spentAsync.when(
              data: (spent) {
                final pct = budget.amount > 0
                    ? (spent / budget.amount).clamp(0.0, 1.0)
                    : 0.0;
                Color barColor = AppTheme.incomeColor;
                if (pct >= 1.0) barColor = AppTheme.expenseColor;
                else if (pct >= 0.8) barColor = Colors.orange;

                return LinearProgressIndicator(
                  value: pct,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(barColor),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Upcoming Debts ────────────────────────────────────────────────────────────
class _UpcomingDebtsSection extends ConsumerWidget {
  final String currency;
  const _UpcomingDebtsSection({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final debtsAsync = ref.watch(unpaidDebtsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.upcomingDebts,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/debts'),
              child: Text(l10n.all),
            ),
          ],
        ),
        const SizedBox(height: 8),
        debtsAsync.when(
          data: (debts) {
            if (debts.isEmpty) return const SizedBox.shrink();
            final upcoming = debts
                .where((d) => d.dueDate != null)
                .toList()
              ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

            return Column(
              children: upcoming.take(3).map((d) {
                final isOverdue = d.dueDate!.isBefore(DateTime.now());
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: d.type == 'lent'
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                    child: Icon(
                      d.type == 'lent' ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  title: Text(d.personName),
                  subtitle: Text(
                    DateFormatter.format(d.dueDate!),
                    style: TextStyle(
                      color: isOverdue ? AppTheme.expenseColor : null,
                    ),
                  ),
                  trailing: Text(
                    CurrencyFormatter.format(d.amount, d.currency),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: d.type == 'lent'
                          ? AppTheme.incomeColor
                          : AppTheme.expenseColor,
                    ),
                  ),
                  onTap: () => context.push('/debts/${d.id}'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

// ── Recent Transactions ───────────────────────────────────────────────────────
class _RecentTransactionsSection extends ConsumerWidget {
  final String currency;
  const _RecentTransactionsSection({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final txAsync = ref.watch(recentTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.recentTransactions,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/transactions'),
              child: Text(l10n.all),
            ),
          ],
        ),
        const SizedBox(height: 8),
        txAsync.when(
          data: (txs) {
            if (txs.isEmpty) {
              return _EmptyState(
                icon: Icons.receipt_long_outlined,
                message: l10n.noTransactions,
                hint: l10n.noTransactionsHint,
                action: () => context.push('/transactions/add'),
                actionLabel: l10n.addTransaction,
              );
            }
            return Column(
              children: txs.map((tx) => _TransactionTile(
                transaction: tx,
                currency: currency,
                ref: ref,
              )).toList(),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

class _TransactionTile extends ConsumerWidget {
  final Transaction transaction;
  final String currency;
  final WidgetRef ref;

  const _TransactionTile({
    required this.transaction,
    required this.currency,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final tx = transaction;
    final isIncome = tx.type == 'income';
    final isTransfer = tx.type == 'transfer';

    Color color = isTransfer
        ? AppTheme.transferColor
        : (isIncome ? AppTheme.incomeColor : AppTheme.expenseColor);

    final categoryAsync = tx.categoryId != null
        ? ref.watch(categoryByIdProvider(tx.categoryId as int))
        : const AsyncData(null);

    return ListTile(
      leading: categoryAsync.when(
        data: (cat) => CircleAvatar(
          backgroundColor: cat != null
              ? AppTheme.colorFromHex(cat.color)
              : (isTransfer ? AppTheme.transferColor : color),
          child: Icon(
            cat != null
                ? IconMap.get(cat.icon)
                : (isTransfer ? Icons.swap_horiz : (isIncome ? Icons.add : Icons.remove)),
            color: Colors.white,
            size: 18,
          ),
        ),
        loading: () => const CircleAvatar(),
        error: (_, __) => const CircleAvatar(),
      ),
      title: categoryAsync.when(
        data: (cat) => Text(cat?.localizedName(language) ?? (isTransfer ? l10n.transfer : l10n.transactions)),
        loading: () => const Text('...'),
        error: (_, __) => Text(l10n.transactions),
      ),
      subtitle: Text(DateFormatter.relativeDate(tx.date)),
      trailing: Text(
        '${isIncome ? '+' : isTransfer ? '→' : '-'}${CurrencyFormatter.format(tx.amount, tx.currency)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: () => context.push('/transactions/${tx.id}'),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String hint;
  final VoidCallback? action;
  final String? actionLabel;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.hint,
    this.action,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(hint,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: action,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
