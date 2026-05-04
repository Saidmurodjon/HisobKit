import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/category_utils.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/transaction_providers.dart';

final _reportRangeProvider = StateProvider<(DateTime, DateTime)>((ref) {
  final now = DateTime.now();
  return (
    DateTime(now.year, now.month, 1),
    DateTime(now.year, now.month + 1, 0, 23, 59, 59)
  );
});

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';
    final range = ref.watch(_reportRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () => _showRangePicker(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _RangeLabel(range: range),
          const SizedBox(height: 16),
          _SummaryRow(range: range, currency: currency),
          const SizedBox(height: 24),
          _MonthlyBarChart(currency: currency),
          const SizedBox(height: 24),
          _ExpenseDonutChart(range: range, currency: currency),
          const SizedBox(height: 24),
          _TopCategoriesSection(range: range, currency: currency),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _showRangePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _RangePickerSheet(ref: ref),
    );
  }
}

class _RangeLabel extends StatelessWidget {
  final (DateTime, DateTime) range;
  const _RangeLabel({required this.range});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.date_range, size: 18),
          const SizedBox(width: 8),
          Text(
            '${DateFormatter.formatShort(range.$1)} – ${DateFormatter.formatShort(range.$2)}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends ConsumerWidget {
  final (DateTime, DateTime) range;
  final String currency;

  const _SummaryRow({required this.range, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final incomeAsync = ref.watch(
        monthlyTotalProvider(('income', range.$1, range.$2)));
    final expenseAsync = ref.watch(
        monthlyTotalProvider(('expense', range.$1, range.$2)));

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: l10n.income,
            valueAsync: incomeAsync,
            currency: currency,
            color: AppTheme.incomeColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: l10n.expense,
            valueAsync: expenseAsync,
            currency: currency,
            color: AppTheme.expenseColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: incomeAsync.when(
            data: (inc) => expenseAsync.when(
              data: (exp) => _MetricCard(
                label: 'Net',
                valueAsync: AsyncData(inc - exp),
                currency: currency,
                color: inc >= exp
                    ? AppTheme.incomeColor
                    : AppTheme.expenseColor,
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final AsyncValue<double> valueAsync;
  final String currency;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.valueAsync,
    required this.currency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            valueAsync.when(
              data: (v) => Text(
                CurrencyFormatter.formatCompact(v.abs(), currency),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              loading: () => const Text('...'),
              error: (_, __) => const Text('---'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bar Chart (last 12 months) ────────────────────────────────────────────────
class _MonthlyBarChart extends ConsumerWidget {
  final String currency;
  const _MonthlyBarChart({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(monthlySummaryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.incomeVsExpense,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 16),
            summaryAsync.when(
              data: (data) => SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: List.generate(data.length, (i) {
                      final d = data[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (d['income'] as double),
                            color: AppTheme.incomeColor,
                            width: 8,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                          ),
                          BarChartRodData(
                            toY: (d['expense'] as double),
                            color: AppTheme.expenseColor,
                            width: 8,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, m) {
                            final idx = v.toInt();
                            if (idx < 0 || idx >= data.length) {
                              return const SizedBox();
                            }
                            final d = data[idx];
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                DateFormatter.formatMonth(DateTime(
                                    d['year'] as int,
                                    d['month'] as int)),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: null,
                      drawVerticalLine: false,
                    ),
                  ),
                ),
              ),
              loading: () => const SizedBox(
                  height: 200,
                  child: Center(
                      child: CircularProgressIndicator.adaptive())),
              error: (_, __) => const SizedBox(height: 200),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                    width: 12,
                    height: 12,
                    color: AppTheme.incomeColor),
                const SizedBox(width: 4),
                Text(l10n.income, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Container(
                    width: 12,
                    height: 12,
                    color: AppTheme.expenseColor),
                const SizedBox(width: 4),
                Text(l10n.expense, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Donut Chart ───────────────────────────────────────────────────────────────
class _ExpenseDonutChart extends ConsumerWidget {
  final (DateTime, DateTime) range;
  final String currency;

  const _ExpenseDonutChart(
      {required this.range, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final byCategory =
        ref.watch(expenseByCategoryProvider((range.$1, range.$2)));
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.expenseByCategory,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 16),
            byCategory.when(
              data: (catMap) {
                if (catMap.isEmpty) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.noData),
                  ));
                }

                final total = catMap.values.fold(0.0, (s, v) => s + v);
                final colors = [
                  AppTheme.expenseColor,
                  AppTheme.secondaryColor,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                  Colors.indigo,
                  Colors.brown,
                  Colors.cyan,
                ];

                return categoriesAsync.when(
                  data: (cats) {
                    final sections = catMap.entries.map((e) {
                      final cat = cats.firstWhere(
                        (c) => c.id == e.key,
                        orElse: () => cats.first,
                      );
                      final pct = e.value / total;
                      final idx = catMap.keys.toList().indexOf(e.key);

                      return PieChartSectionData(
                        value: e.value,
                        color: colors[idx % colors.length],
                        title: '${(pct * 100).toStringAsFixed(1)}%',
                        radius: 60,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();

                    return Column(
                      children: [
                        SizedBox(
                          height: 180,
                          child: PieChart(PieChartData(
                            sections: sections,
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          )),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: catMap.entries.map((e) {
                            final cat = cats.firstWhere(
                              (c) => c.id == e.key,
                              orElse: () => cats.first,
                            );
                            final idx =
                                catMap.keys.toList().indexOf(e.key);
                            return Chip(
                              avatar: CircleAvatar(
                                backgroundColor:
                                    colors[idx % colors.length],
                                radius: 6,
                              ),
                              label: Text(
                                '${cat.localizedName(language)}: ${CurrencyFormatter.formatCompact(e.value, currency)}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                      height: 180,
                      child: Center(
                          child: CircularProgressIndicator.adaptive())),
                  error: (_, __) => const SizedBox(),
                );
              },
              loading: () => const SizedBox(
                  height: 180,
                  child: Center(
                      child: CircularProgressIndicator.adaptive())),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top Categories ────────────────────────────────────────────────────────────
class _TopCategoriesSection extends ConsumerWidget {
  final (DateTime, DateTime) range;
  final String currency;

  const _TopCategoriesSection(
      {required this.range, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    final byCategory =
        ref.watch(expenseByCategoryProvider((range.$1, range.$2)));
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.topCategories,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            byCategory.when(
              data: (catMap) {
                if (catMap.isEmpty) return Text(l10n.noData);
                final sorted = catMap.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
                final total = catMap.values.fold(0.0, (s, v) => s + v);

                return categoriesAsync.when(
                  data: (cats) => Column(
                    children: sorted.take(5).map((e) {
                      final cat = cats.firstWhere(
                        (c) => c.id == e.key,
                        orElse: () => cats.first,
                      );
                      final pct = total > 0 ? e.value / total : 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(cat.localizedName(language),
                                  style: const TextStyle(fontSize: 13)),
                            ),
                            Expanded(
                              flex: 3,
                              child: LinearProgressIndicator(
                                value: pct.toDouble(),
                                backgroundColor: Colors.grey.shade200,
                                valueColor:
                                    const AlwaysStoppedAnimation(
                                        AppTheme.expenseColor),
                                minHeight: 6,
                                borderRadius:
                                    BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.formatCompact(
                                  e.value, currency),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Range Picker Sheet ────────────────────────────────────────────────────────
class _RangePickerSheet extends ConsumerWidget {
  final WidgetRef ref;
  const _RangePickerSheet({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.selectDateRange,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...[
              (
                l10n.thisMonthRange,
                (
                  DateTime(now.year, now.month, 1),
                  DateTime(now.year, now.month + 1, 0, 23, 59, 59)
                )
              ),
              (
                l10n.lastMonth,
                (
                  DateTime(now.year, now.month - 1, 1),
                  DateTime(now.year, now.month, 0, 23, 59, 59)
                )
              ),
              (
                l10n.thisYear,
                (
                  DateTime(now.year, 1, 1),
                  DateTime(now.year, 12, 31, 23, 59, 59)
                )
              ),
              (
                'Last 3 Months',
                (
                  DateTime(now.year, now.month - 3, 1),
                  DateTime(now.year, now.month + 1, 0, 23, 59, 59)
                )
              ),
            ].map(
              (preset) => ListTile(
                title: Text(preset.$1),
                onTap: () {
                  ref.read(_reportRangeProvider.notifier).state =
                      preset.$2;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
