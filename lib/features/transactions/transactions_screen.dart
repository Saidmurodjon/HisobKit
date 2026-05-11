import 'package:flutter/material.dart';
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

// Date range filter state
final _selectedRangeProvider =
    StateProvider<(DateTime, DateTime)>((ref) {
  final now = DateTime.now();
  return (DateTime(now.year, now.month, 1),
      DateTime(now.year, now.month + 1, 0, 23, 59, 59));
});

final _typeFilterProvider = StateProvider<String?>((ref) => null);

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final range = ref.watch(_selectedRangeProvider);
    final typeFilter = ref.watch(_typeFilterProvider);

    final txAsync = ref.watch(
        transactionsByRangeProvider((range.$1, range.$2)));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _DateRangeChips(ref: ref),
          Expanded(
            child: txAsync.when(
              data: (txs) {
                final filtered = typeFilter != null
                    ? txs.where((t) => t.type == typeFilter).toList()
                    : txs;

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(l10n.noTransactions,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey)),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: () => context.push('/transactions/add'),
                          child: Text(l10n.addTransaction),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _TransactionListTile(
                    transaction: filtered[i],
                    ref: ref,
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _FilterSheet(ref: ref),
    );
  }
}

class _DateRangeChips extends StatelessWidget {
  final WidgetRef ref;
  const _DateRangeChips({required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final range = ref.watch(_selectedRangeProvider);

    final presets = <String, (DateTime, DateTime)>{
      l10n.thisMonthRange: (
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 0, 23, 59, 59)
      ),
      l10n.lastMonth: (
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month, 0, 23, 59, 59)
      ),
      l10n.thisYear: (
        DateTime(now.year, 1, 1),
        DateTime(now.year, 12, 31, 23, 59, 59)
      ),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: presets.entries.map((e) {
          final isSelected =
              range.$1 == e.value.$1 && range.$2 == e.value.$2;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(e.key),
              selected: isSelected,
              onSelected: (_) => ref
                  .read(_selectedRangeProvider.notifier)
                  .state = e.value,
              selectedColor: AppTheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primary : Colors.transparent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterSheet extends ConsumerWidget {
  final WidgetRef ref;
  const _FilterSheet({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final typeFilter = ref.watch(_typeFilterProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.filter,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.all),
                  selected: typeFilter == null,
                  onSelected: (_) =>
                      ref.read(_typeFilterProvider.notifier).state = null,
                ),
                FilterChip(
                  label: Text(l10n.income),
                  selected: typeFilter == 'income',
                  onSelected: (_) =>
                      ref.read(_typeFilterProvider.notifier).state = 'income',
                ),
                FilterChip(
                  label: Text(l10n.expense),
                  selected: typeFilter == 'expense',
                  onSelected: (_) =>
                      ref.read(_typeFilterProvider.notifier).state = 'expense',
                ),
                FilterChip(
                  label: Text(l10n.transfer),
                  selected: typeFilter == 'transfer',
                  onSelected: (_) =>
                      ref.read(_typeFilterProvider.notifier).state = 'transfer',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionListTile extends ConsumerWidget {
  final Transaction transaction;
  final WidgetRef ref;

  const _TransactionListTile(
      {required this.transaction, required this.ref});

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

    return Dismissible(
      key: Key('tx_${tx.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppTheme.expenseColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.deleteTransaction),
            content: Text(l10n.deleteTransactionConfirm),
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
      },
      onDismissed: (_) async {
        final db = ref.read(databaseProvider);
        await db.transactionsDao.deleteTransaction(tx.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deletedSuccessfully)),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: categoryAsync.when(
            data: (cat) => CircleAvatar(
              backgroundColor: cat != null
                  ? AppTheme.colorFromHex(cat.color)
                  : color,
              child: Icon(
                cat != null
                    ? IconMap.get(cat.icon)
                    : (isTransfer
                        ? Icons.swap_horiz
                        : (isIncome ? Icons.add : Icons.remove)),
                color: Colors.white,
                size: 18,
              ),
            ),
            loading: () => const CircleAvatar(),
            error: (_, __) => const CircleAvatar(),
          ),
          title: categoryAsync.when(
            data: (cat) => Text(
                cat?.localizedName(language) ?? (isTransfer ? l10n.transfer : l10n.transactions)),
            loading: () => const Text('...'),
            error: (_, __) => Text(l10n.transactions),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormatter.format(tx.date)),
              if (tx.note.isNotEmpty)
                Text(tx.note,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
            ],
          ),
          isThreeLine: tx.note.isNotEmpty,
          trailing: Text(
            '${isIncome ? '+' : isTransfer ? '→' : '-'}${CurrencyFormatter.format(tx.amount, tx.currency)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          onTap: () => context.push('/transactions/${tx.id}'),
        ),
      ),
    );
  }
}
