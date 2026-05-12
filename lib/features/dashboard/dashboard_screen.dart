import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../auth/providers/auth_flow_provider.dart';
import '../auth/models/auth_state.dart' show AuthFlowSuccess;
import '../notifications/notifications_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(accountsStreamProvider),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _HeroBalanceCard(currency: currency),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _QuickActions(),
                  const SizedBox(height: 20),
                  _MonthlySummaryRow(currency: currency),
                  const SizedBox(height: 20),
                  _ActiveBudgetsSection(currency: currency),
                  const SizedBox(height: 20),
                  _UpcomingDebtsSection(currency: currency),
                  const SizedBox(height: 20),
                  _RecentTransactionsSection(currency: currency),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
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

// ── Hero Balance Card ─────────────────────────────────────────────────────────
class _HeroBalanceCard extends ConsumerWidget {
  final String currency;
  const _HeroBalanceCard({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accountsAsync = ref.watch(accountsStreamProvider);
    final authState = ref.watch(authFlowProvider);
    final user = authState is AuthFlowSuccess ? authState.user : null;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, Color(0xFF163A5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // ── Profil avatar (chap burchak) ─────────────────────
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 1.5),
                          ),
                          child: ClipOval(
                            child: user?.avatarUrl != null
                                ? Image.network(user!.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _avatarInitials(user.displayName))
                                : _avatarInitials(user?.displayName),
                          ),
                        ),
                        // Logged-in dot
                        if (user != null)
                          Positioned(
                            right: 0, bottom: 0,
                            child: Container(
                              width: 10, height: 10,
                              decoration: BoxDecoration(
                                color: AppTheme.accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppTheme.primary, width: 1.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.appTitle,
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // ── Notification bell ────────────────────────────────
                  _NotifBell(),
                  IconButton(
                    icon: const Icon(Icons.account_balance_wallet_outlined,
                        color: Colors.white70),
                    tooltip: l10n.accounts,
                    onPressed: () => context.push('/accounts'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.totalBalance,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 6),
              accountsAsync.when(
                data: (accounts) {
                  final total = accounts.fold<double>(0, (s, a) => s + a.balance);
                  return Text(
                    CurrencyFormatter.format(total, currency),
                    style: AppTheme.balanceStyle,
                  );
                },
                loading: () => Text('---', style: AppTheme.balanceStyle),
                error: (_, __) => Text('---', style: AppTheme.balanceStyle),
              ),
              const SizedBox(height: 16),
              // Account pills
              accountsAsync.when(
                data: (accounts) => accounts.isEmpty
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: accounts
                              .map((a) => _AccountPill(account: a, currency: currency))
                              .toList(),
                        ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarInitials(String? name) {
    final initials = (name != null && name.trim().isNotEmpty)
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'H';
    return Container(
      color: AppTheme.accent.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.sora(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _AccountPill extends StatelessWidget {
  final Account account;
  final String currency;

  const _AccountPill({required this.account, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.colorFromHex(account.color),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${account.name}: ${CurrencyFormatter.format(account.balance, account.currency)}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actions = [
      (Icons.add_circle_outline, l10n.income, AppTheme.accent, '/transactions/add'),
      (Icons.remove_circle_outline, l10n.expense, AppTheme.danger, '/transactions/add'),
      (Icons.swap_horiz_outlined, l10n.transfer, AppTheme.transferColor, '/transactions/add'),
      (Icons.pie_chart_outline, l10n.budgets, AppTheme.warning, '/budgets'),
    ];

    return Row(
      children: actions.map((a) {
        final (icon, label, color, route) = a;
        return Expanded(
          child: GestureDetector(
            onTap: () => context.push(route),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Monthly Summary ───────────────────────────────────────────────────────────
class _MonthlySummaryRow extends ConsumerWidget {
  final String currency;
  const _MonthlySummaryRow({required this.currency});

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
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: l10n.expense,
            valueAsync: expenseAsync,
            currency: currency,
            color: AppTheme.expenseColor,
            icon: Icons.arrow_upward_rounded,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 8),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
            ],
          ),
          const SizedBox(height: 8),
          valueAsync.when(
            data: (v) => Text(
              CurrencyFormatter.format(v, currency),
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            loading: () => Text('---',
                style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
            error: (_, __) => const Text('---'),
          ),
        ],
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
        _SectionHeader(
          title: l10n.activeBudgets,
          onSeeAll: () => context.push('/budgets'),
          seeAllLabel: l10n.all,
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
                  .map((b) => _BudgetProgressTile(budget: b, currency: currency))
                  .toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

class _BudgetProgressTile extends ConsumerWidget {
  final Budget budget;
  final String currency;

  const _BudgetProgressTile({required this.budget, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final spentAsync = ref.watch(
        budgetSpentProvider((budget.categoryId, budget.startDate, budget.endDate)));
    final categoryAsync = ref.watch(categoryByIdProvider(budget.categoryId));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          ),
        ),
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
                            backgroundColor: AppTheme.colorFromHex(cat.color),
                            child: Icon(IconMap.get(cat.icon), size: 14, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(cat.localizedName(language),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  )),
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
            const SizedBox(height: 10),
            spentAsync.when(
              data: (spent) {
                final pct = budget.amount > 0
                    ? (spent / budget.amount).clamp(0.0, 1.0)
                    : 0.0;
                Color barColor = AppTheme.incomeColor;
                if (pct >= 1.0) barColor = AppTheme.expenseColor;
                else if (pct >= 0.8) barColor = AppTheme.warning;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: barColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(barColor),
                    minHeight: 8,
                  ),
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
        _SectionHeader(
          title: l10n.upcomingDebts,
          onSeeAll: () => context.push('/debts'),
          seeAllLabel: l10n.all,
        ),
        const SizedBox(height: 8),
        debtsAsync.when(
          data: (debts) {
            if (debts.isEmpty) return const SizedBox.shrink();
            final upcoming = debts
                .where((d) => d.dueDate != null)
                .toList()
              ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

            if (upcoming.isEmpty) return const SizedBox.shrink();

            return Column(
              children: upcoming.take(3).map((d) {
                final isOverdue = d.dueDate!.isBefore(DateTime.now());
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isOverdue
                            ? AppTheme.danger.withOpacity(0.2)
                            : (Theme.of(context).dividerTheme.color ?? Colors.transparent),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: d.type == 'lent'
                            ? AppTheme.incomeColor.withOpacity(0.15)
                            : AppTheme.expenseColor.withOpacity(0.15),
                        child: Icon(
                          d.type == 'lent'
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: d.type == 'lent'
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                          size: 16,
                        ),
                      ),
                      title: Text(d.personName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      subtitle: Text(
                        DateFormatter.format(d.dueDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue
                              ? AppTheme.expenseColor
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: Text(
                        CurrencyFormatter.format(d.amount, d.currency),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: d.type == 'lent'
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                        ),
                      ),
                      onTap: () => context.push('/debts/${d.id}'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
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
        _SectionHeader(
          title: l10n.recentTransactions,
          onSeeAll: () => context.go('/transactions'),
          seeAllLabel: l10n.all,
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
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
                ),
              ),
              child: Column(
                children: txs.asMap().entries.map((entry) {
                  final isLast = entry.key == txs.length - 1;
                  return Column(
                    children: [
                      _TransactionRow(
                        transaction: entry.value,
                        currency: currency,
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).dividerTheme.color,
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

class _TransactionRow extends ConsumerWidget {
  final Transaction transaction;
  final String currency;

  const _TransactionRow({required this.transaction, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final tx = transaction;
    final isIncome = tx.type == 'income';
    final isTransfer = tx.type == 'transfer';

    final color = isTransfer
        ? AppTheme.transferColor
        : (isIncome ? AppTheme.incomeColor : AppTheme.expenseColor);

    final categoryAsync = tx.categoryId != null
        ? ref.watch(categoryByIdProvider(tx.categoryId as int))
        : const AsyncData(null);

    return InkWell(
      onTap: () => context.push('/transactions/${tx.id}'),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            categoryAsync.when(
              data: (cat) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (cat != null ? AppTheme.colorFromHex(cat.color) : color)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  cat != null
                      ? IconMap.get(cat.icon)
                      : (isTransfer
                          ? Icons.swap_horiz
                          : (isIncome ? Icons.add : Icons.remove)),
                  color: cat != null ? AppTheme.colorFromHex(cat.color) : color,
                  size: 18,
                ),
              ),
              loading: () => const SizedBox(width: 40, height: 40),
              error: (_, __) => const SizedBox(width: 40, height: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  categoryAsync.when(
                    data: (cat) => Text(
                      cat?.localizedName(language) ??
                          (isTransfer ? l10n.transfer : l10n.transactions),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    loading: () => const Text('...'),
                    error: (_, __) => Text(l10n.transactions),
                  ),
                  Text(
                    DateFormatter.relativeDate(tx.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : isTransfer ? '→' : '-'}${CurrencyFormatter.format(tx.amount, tx.currency)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;

  const _SectionHeader({required this.title, this.onSeeAll, this.seeAllLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const Spacer(),
        if (onSeeAll != null && seeAllLabel != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(seeAllLabel!,
                style: const TextStyle(color: AppTheme.accent, fontSize: 13)),
          ),
      ],
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
            Icon(icon,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            const SizedBox(height: 4),
            Text(hint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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

// ── Notification Bell (badge) ─────────────────────────────────────────────────
class _NotifBell extends ConsumerWidget {
  const _NotifBell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(unreadNotifCountProvider);
    final count = countAsync.value ?? 0;

    return IconButton(
      tooltip: 'Xabarnomalar',
      onPressed: () => context.push('/notifications'),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(count > 99 ? '99+' : '$count',
            style: const TextStyle(fontSize: 10)),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.notifications_outlined, color: Colors.white70),
      ),
    );
  }
}
