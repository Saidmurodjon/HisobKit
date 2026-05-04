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
import 'debt_providers.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final debtsAsync = ref.watch(allDebtsProvider);
    final summaryAsync = ref.watch(debtSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.debts)),
      body: Column(
        children: [
          // Summary header
          summaryAsync.when(
            data: (summary) => _DebtSummaryCard(summary: summary),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // List
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: l10n.lent),
                      Tab(text: l10n.borrowed),
                    ],
                  ),
                  Expanded(
                    child: debtsAsync.when(
                      data: (debts) => TabBarView(
                        children: [
                          _DebtList(
                            debts: debts
                                .where((d) => d.type == 'lent')
                                .toList(),
                            ref: ref,
                          ),
                          _DebtList(
                            debts: debts
                                .where((d) => d.type == 'borrowed')
                                .toList(),
                            ref: ref,
                          ),
                        ],
                      ),
                      loading: () => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDebtForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDebtForm(BuildContext context, WidgetRef ref,
      {Debt? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _DebtForm(existing: existing, ref: ref),
    );
  }
}

class _DebtSummaryCard extends StatelessWidget {
  final Map<String, double> summary;
  const _DebtSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: AppTheme.incomeColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.totalLent,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12)),
                    Text(
                      CurrencyFormatter.format(
                          summary['lent'] ?? 0, 'UZS'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              color: AppTheme.expenseColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.totalBorrowed,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12)),
                    Text(
                      CurrencyFormatter.format(
                          summary['borrowed'] ?? 0, 'UZS'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtList extends ConsumerWidget {
  final List<Debt> debts;
  final WidgetRef ref;

  const _DebtList({required this.debts, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (debts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handshake_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noDebts, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: debts.length,
      itemBuilder: (ctx, i) => _DebtCard(debt: debts[i], ref: ref),
    );
  }
}

class _DebtCard extends ConsumerWidget {
  final Debt debt;
  final WidgetRef ref;

  const _DebtCard({required this.debt, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paidAsync = ref.watch(totalPaidForDebtProvider(debt.id));
    final isLent = debt.type == 'lent';
    final isOverdue =
        debt.dueDate != null && debt.dueDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => context.push('/debts/${debt.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isLent
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                    child: Text(
                      debt.personName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(debt.personName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        if (debt.dueDate != null)
                          Text(
                            '${AppLocalizations.of(context)!.dueDate}: ${DateFormatter.format(debt.dueDate!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue
                                  ? AppTheme.expenseColor
                                  : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(
                            debt.amount, debt.currency),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isLent
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                        ),
                      ),
                      if (debt.isPaid)
                        Chip(
                          label: Text(AppLocalizations.of(context)!.paid,
                              style: const TextStyle(fontSize: 10)),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ],
              ),
              if (!debt.isPaid)
                paidAsync.when(
                  data: (paid) {
                    if (paid <= 0) return const SizedBox.shrink();
                    final remaining = debt.amount - paid;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: (paid / debt.amount).clamp(0.0, 1.0),
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(
                              isLent
                                  ? AppTheme.incomeColor
                                  : AppTheme.expenseColor,
                            ),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${AppLocalizations.of(context)!.remaining}: ${CurrencyFormatter.format(remaining, debt.currency)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Debt Detail Screen ────────────────────────────────────────────────────────
class DebtDetailScreen extends ConsumerWidget {
  final int debtId;
  const DebtDetailScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final debtsAsync = ref.watch(allDebtsProvider);
    final paymentsAsync = ref.watch(debtPaymentsProvider(debtId));

    return debtsAsync.when(
      data: (debts) {
        final debtList = debts.where((d) => d.id == debtId).toList();
        if (debtList.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.noDebts)),
          );
        }
        final debt = debtList.first;
        final isLent = debt.type == 'lent';

        return Scaffold(
          appBar: AppBar(
            title: Text(debt.personName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) =>
                      _DebtForm(existing: debt, ref: ref),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (_) => [
                  if (!debt.isPaid)
                    PopupMenuItem(
                        value: 'paid', child: Text(l10n.markAsPaid)),
                  PopupMenuItem(
                      value: 'delete', child: Text(l10n.delete)),
                ],
                onSelected: (v) async {
                  final db = ref.read(databaseProvider);
                  if (v == 'paid') {
                    await db.debtsDao.markAsPaid(debt.id);
                  } else {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.deleteDebt),
                        content: Text(l10n.deleteDebtConfirm),
                        actions: [
                          TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, false),
                              child: Text(l10n.cancel)),
                          FilledButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, true),
                              child: Text(l10n.delete)),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await db.debtsDao.deleteDebt(debt.id);
                      if (context.mounted) context.pop();
                    }
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: isLent ? AppTheme.incomeColor : AppTheme.expenseColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLent ? l10n.lent : l10n.borrowed,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        CurrencyFormatter.format(
                            debt.amount, debt.currency),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      if (debt.note.isNotEmpty)
                        Text(debt.note,
                            style: const TextStyle(color: Colors.white70)),
                      if (debt.dueDate != null)
                        Text(
                          '${l10n.dueDate}: ${DateFormatter.format(debt.dueDate!)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!debt.isPaid) ...[
                Row(
                  children: [
                    Text(l10n.payments,
                        style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.addPayment),
                      onPressed: () => _showAddPayment(context, ref, debt),
                    ),
                  ],
                ),
              ],
              paymentsAsync.when(
                data: (payments) {
                  if (payments.isEmpty) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noPayments),
                    ));
                  }
                  return Column(
                    children: payments
                        .map((p) => ListTile(
                              leading: const Icon(Icons.payment),
                              title: Text(CurrencyFormatter.format(
                                  p.amount, debt.currency)),
                              subtitle: p.note.isNotEmpty
                                  ? Text(p.note)
                                  : Text(DateFormatter.format(p.date)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outlined),
                                onPressed: () async {
                                  final db = ref.read(databaseProvider);
                                  await db.debtsDao.deletePayment(p.id);
                                },
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () =>
                    const CircularProgressIndicator.adaptive(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }

  void _showAddPayment(
      BuildContext context, WidgetRef ref, Debt debt) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addPayment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.paymentAmount),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: l10n.note),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              final amount =
                  double.tryParse(controller.text) ?? 0;
              if (amount <= 0) return;
              final db = ref.read(databaseProvider);
              await db.debtsDao.insertPayment(
                DebtPaymentsCompanion(
                  debtId: Value(debt.id),
                  amount: Value(amount),
                  note: Value(noteController.text),
                ),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }
}

// ── Debt Form ─────────────────────────────────────────────────────────────────
class _DebtForm extends ConsumerStatefulWidget {
  final Debt? existing;
  final WidgetRef ref;

  const _DebtForm({this.existing, required this.ref});

  @override
  ConsumerState<_DebtForm> createState() => _DebtFormState();
}

class _DebtFormState extends ConsumerState<_DebtForm> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'lent';
  String _currency = 'UZS';
  DateTime? _dueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final d = widget.existing!;
      _nameController.text = d.personName;
      _amountController.text = d.amount.toString();
      _noteController.text = d.note;
      _type = d.type;
      _currency = d.currency;
      _dueDate = d.dueDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _amountController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final amount = double.parse(_amountController.text);
      final companion = DebtsCompanion(
        id: widget.existing != null
            ? Value(widget.existing!.id)
            : const Value.absent(),
        personName: Value(_nameController.text.trim()),
        type: Value(_type),
        amount: Value(amount),
        currency: Value(_currency),
        dueDate: Value(_dueDate),
        note: Value(_noteController.text.trim()),
        isPaid: const Value(false),
      );

      if (widget.existing != null) {
        await db.debtsDao.updateDebt(companion);
      } else {
        await db.debtsDao.insertDebt(companion);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            Text(
              widget.existing != null ? l10n.editDebt : l10n.addDebt,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'lent', label: Text(l10n.lent)),
                ButtonSegment(
                    value: 'borrowed', label: Text(l10n.borrowed)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: l10n.personName),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    decoration:
                        InputDecoration(labelText: l10n.amount),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _currency,
                    decoration:
                        InputDecoration(labelText: l10n.currency),
                    items: ['UZS', 'USD', 'EUR', 'RUB', 'GBP', 'KZT']
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _currency = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate:
                      _dueDate ?? DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (d != null) setState(() => _dueDate = d);
              },
              child: InputDecorator(
                decoration: InputDecoration(labelText: l10n.dueDate),
                child: Text(_dueDate != null
                    ? DateFormatter.format(_dueDate!)
                    : l10n.noDebts),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: l10n.note),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: Text(widget.existing != null ? l10n.save : l10n.add),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
