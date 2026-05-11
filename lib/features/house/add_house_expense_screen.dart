import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/settings_provider.dart';
import 'house_providers.dart';

class AddHouseExpenseScreen extends ConsumerStatefulWidget {
  final int groupId;

  const AddHouseExpenseScreen({super.key, required this.groupId});

  @override
  ConsumerState<AddHouseExpenseScreen> createState() => _AddHouseExpenseScreenState();
}

class _AddHouseExpenseScreenState extends ConsumerState<AddHouseExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  int? _payerMemberId;
  final Set<int> _selectedParticipants = {};
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save(List<HouseMember> members) async {
    if (!_formKey.currentState!.validate()) return;
    if (_payerMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.paidBy)),
      );
      return;
    }
    if (_selectedParticipants.isEmpty) {
      // Default: all members
      _selectedParticipants.addAll(members.map((m) => m.id));
    }

    setState(() => _isSaving = true);
    final db = ref.read(databaseProvider);
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    final shareAmount = _selectedParticipants.isEmpty
        ? 0.0
        : amount / _selectedParticipants.length;

    try {
      final expenseId = await db.houseDao.insertExpense(
        HouseExpensesCompanion.insert(
          groupId: widget.groupId,
          paidByMemberId: _payerMemberId!,
          title: _titleController.text.trim(),
          amount: Value(amount),
          note: Value(_noteController.text.trim()),
        ),
      );

      for (final memberId in _selectedParticipants) {
        await db.houseDao.insertSplit(
          HouseExpenseSplitsCompanion.insert(
            expenseId: expenseId,
            memberId: memberId,
            shareAmount: Value(shareAmount),
          ),
        );
      }

      if (mounted) {
        // Invalidate settlement cache so it recalculates after new expense
        ref.invalidate(settlementProvider(widget.groupId));
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(houseMembersProvider(widget.groupId));
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addHouseExpense),
      ),
      body: membersAsync.when(
        data: (members) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.category),
                validator: (v) => v == null || v.trim().isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.amount,
                  suffixText: currency,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.requiredField;
                  final d = double.tryParse(v.replaceAll(',', '.'));
                  if (d == null || d <= 0) return l10n.amountMustBePositive;
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Payer selector
              Text(l10n.paidBy,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: members.map((m) {
                  final selected = _payerMemberId == m.id;
                  return GestureDetector(
                    onTap: () => setState(() => _payerMemberId = m.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.colorFromHex(m.color)
                            : AppTheme.colorFromHex(m.color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.colorFromHex(m.color),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Text(m.name,
                          style: TextStyle(
                            color: selected ? Colors.white : AppTheme.colorFromHex(m.color),
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Participants
              Text(l10n.presentMembers,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                '${l10n.perPerson}: ${_selectedParticipants.isEmpty ? '' : _formatShare(members)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: members.map((m) {
                  final selected = _selectedParticipants.contains(m.id);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (selected) {
                        _selectedParticipants.remove(m.id);
                      } else {
                        _selectedParticipants.add(m.id);
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.accent.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppTheme.accent : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selected)
                            const Icon(Icons.check, size: 14, color: AppTheme.accent),
                          if (selected) const SizedBox(width: 4),
                          Text(m.name,
                              style: TextStyle(
                                color: selected
                                    ? AppTheme.accent
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: l10n.note),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _isSaving ? null : () => _save(members),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  String _formatShare(List<HouseMember> members) {
    if (_selectedParticipants.isEmpty) return '';
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0) return '';
    final share = amount / _selectedParticipants.length;
    return share.toStringAsFixed(0);
  }
}
