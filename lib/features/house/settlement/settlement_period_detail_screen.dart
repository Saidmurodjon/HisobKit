import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/database/daos/settlement_dao.dart';
import 'settlement_providers.dart';

class SettlementPeriodDetailScreen extends ConsumerStatefulWidget {
  final int periodId;
  const SettlementPeriodDetailScreen({super.key, required this.periodId});

  @override
  ConsumerState<SettlementPeriodDetailScreen> createState() =>
      _SettlementPeriodDetailScreenState();
}

class _SettlementPeriodDetailScreenState
    extends ConsumerState<SettlementPeriodDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(periodExpensesProvider(widget.periodId));
    final membersAsync = ref.watch(periodMembersProvider(widget.periodId));
    final totalAsync = ref.watch(periodTotalProvider(widget.periodId));
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Davr tafsilotlari'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Xarajatlar'),
            Tab(icon: Icon(Icons.people_outline), text: 'Balanslar'),
            Tab(icon: Icon(Icons.swap_horiz_outlined), text: "O'tkazmalar"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Xarajat qo\'shish',
            onPressed: () => context.push(
              '/house/periods/${widget.periodId}/add-expense',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          totalAsync.when(
            data: (total) => _SummaryCard(
              total: total,
              currency: currency,
              periodId: widget.periodId,
              ref: ref,
            ),
            loading: () => const SizedBox(height: 4),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Tabs
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                // Tab 1: Xarajatlar
                _ExpensesTab(
                  periodId: widget.periodId,
                  expensesAsync: expensesAsync,
                  membersAsync: membersAsync,
                  currency: currency,
                ),

                // Tab 2: Balanslar
                _BalancesTab(periodId: widget.periodId, currency: currency),

                // Tab 3: Minimal o'tkazmalar
                _TransfersTab(periodId: widget.periodId, currency: currency),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          '/house/periods/${widget.periodId}/add-expense',
        ),
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Summary card ─────────────────────────────────────────────────────────────

class _SummaryCard extends ConsumerWidget {
  final double total;
  final String currency;
  final int periodId;
  final WidgetRef ref;

  const _SummaryCard({
    required this.total,
    required this.currency,
    required this.periodId,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(periodMembersProvider(periodId));
    final memberCount =
        membersAsync.value?.length ?? 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1A3A5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jami xarajat',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(total, currency),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "A'zolar",
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '$memberCount kishi',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Xarajatlar tab ────────────────────────────────────────────────────────────

class _ExpensesTab extends ConsumerWidget {
  final int periodId;
  final AsyncValue<List<PeriodExpense>> expensesAsync;
  final AsyncValue<List<PeriodMember>> membersAsync;
  final String currency;

  const _ExpensesTab({
    required this.periodId,
    required this.expensesAsync,
    required this.membersAsync,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 60,
                    color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 12),
                Text(
                  'Xarajatlar yo\'q',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () =>
                      context.push('/house/periods/$periodId/add-expense'),
                  icon: const Icon(Icons.add),
                  label: const Text('Xarajat qo\'shish'),
                ),
              ],
            ),
          );
        }

        final members = membersAsync.value ?? [];
        final memberMap = {for (final m in members) m.id: m};

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: expenses.length,
          itemBuilder: (ctx, i) {
            final e = expenses[i];
            final payer = memberMap[e.paidByMemberId];
            return _ExpenseCard(
              expense: e,
              payerName: payer?.name ?? '?',
              payerColor: payer?.color ?? '#888888',
              currency: currency,
              onDelete: () async {
                final confirm = await showDialog<bool>(
                  context: ctx,
                  builder: (d) => AlertDialog(
                    title: const Text('Xarajatni o\'chirish'),
                    content: Text('"${e.title}" xarajatini o\'chirasizmi?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(d, false),
                          child: const Text('Yo\'q')),
                      TextButton(
                        onPressed: () => Navigator.pop(d, true),
                        child: Text('Ha, o\'chir',
                            style: TextStyle(color: AppTheme.danger)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref
                      .read(expenseNotifierProvider.notifier)
                      .deleteExpense(e.id);
                  // Refresh balances
                  ref.invalidate(periodBalancesProvider(periodId));
                  ref.invalidate(periodTotalProvider(periodId));
                }
              },
            );
          },
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Center(child: Text('Xato: $e')),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final PeriodExpense expense;
  final String payerName;
  final String payerColor;
  final String currency;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
    required this.payerName,
    required this.payerColor,
    required this.currency,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('dd.MM.yyyy');

    Color avatarColor;
    try {
      avatarColor =
          Color(int.parse(payerColor.replaceAll('#', '0xFF')));
    } catch (_) {
      avatarColor = AppTheme.accent;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: Text(
            payerName.isNotEmpty ? payerName[0].toUpperCase() : '?',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(expense.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${payerName} • ${fmt.format(expense.date)}',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CurrencyFormatter.format(expense.amount, currency),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.danger,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: AppTheme.danger,
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Balanslar tab ─────────────────────────────────────────────────────────────

class _BalancesTab extends ConsumerWidget {
  final int periodId;
  final String currency;

  const _BalancesTab({required this.periodId, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(periodBalancesProvider(periodId));

    return balancesAsync.when(
      data: (balances) {
        if (balances.isEmpty) {
          return const Center(child: Text('A\'zolar topilmadi'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: balances.length,
                itemBuilder: (ctx, i) => _BalanceCard(
                  balance: balances[i],
                  currency: currency,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () => context.push(
                  '/house/periods/$periodId/propose',
                ),
                icon: const Icon(Icons.gavel_outlined),
                label: const Text('Hisob-kitobni taklif qilish'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Center(child: Text('Xato: $e')),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final MemberBalance balance;
  final String currency;

  const _BalanceCard({required this.balance, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCreditor = balance.balance > 0;
    final isDebtor = balance.balance < 0;
    final balanceColor = isCreditor
        ? AppTheme.accent
        : isDebtor
            ? AppTheme.danger
            : theme.colorScheme.onSurfaceVariant;

    Color avatarColor;
    try {
      avatarColor = Color(int.parse(balance.color.replaceAll('#', '0xFF')));
    } catch (_) {
      avatarColor = AppTheme.accent;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: avatarColor,
              child: Text(
                balance.name.isNotEmpty
                    ? balance.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(balance.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    'To\'ladi: ${CurrencyFormatter.format(balance.paid, currency)}  •  '
                    'Ulushi: ${CurrencyFormatter.format(balance.consumed, currency)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(balance.balance.abs(), currency),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: balanceColor,
                  ),
                ),
                Text(
                  isCreditor
                      ? 'Oladi'
                      : isDebtor
                          ? 'Beradi'
                          : 'Barobar',
                  style: TextStyle(
                    fontSize: 11,
                    color: balanceColor,
                    fontWeight: FontWeight.w500,
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

// ── Minimal o'tkazmalar tab ───────────────────────────────────────────────────

class _TransfersTab extends ConsumerWidget {
  final int periodId;
  final String currency;

  const _TransfersTab({required this.periodId, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(periodTransfersProvider(periodId));

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: AppTheme.accent),
                  SizedBox(height: 12),
                  Text(
                    'Hamma barobar!\nHech kim hech kimga hech narsa bermaydi.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Minimal ${transfers.length} ta o\'tkazma bilan hisob-kitob qilinadi',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: transfers.length,
                itemBuilder: (ctx, i) => _TransferCard(
                  transfer: transfers[i],
                  currency: currency,
                  index: i + 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () =>
                    context.push('/house/periods/$periodId/propose'),
                icon: const Icon(Icons.gavel_outlined),
                label: const Text('Hisob-kitobni yakunlash'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Center(child: Text('Xato: $e')),
    );
  }
}

class _TransferCard extends StatelessWidget {
  final TransferResult transfer;
  final String currency;
  final int index;

  const _TransferCard(
      {required this.transfer, required this.currency, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.transferColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('$index',
                    style: const TextStyle(
                        color: AppTheme.transferColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(transfer.fromName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          size: 14, color: AppTheme.transferColor),
                      const SizedBox(width: 8),
                      Text(transfer.toName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${transfer.fromName} → ${transfer.toName} ga beradi',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(transfer.amount, currency),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.transferColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
