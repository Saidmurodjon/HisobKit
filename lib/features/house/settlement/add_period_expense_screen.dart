import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import 'settlement_providers.dart';

class AddPeriodExpenseScreen extends ConsumerStatefulWidget {
  final int periodId;
  const AddPeriodExpenseScreen({super.key, required this.periodId});

  @override
  ConsumerState<AddPeriodExpenseScreen> createState() =>
      _AddPeriodExpenseScreenState();
}

class _AddPeriodExpenseScreenState
    extends ConsumerState<AddPeriodExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  int? _selectedPayer;
  DateTime _date = DateTime.now();
  String _category = 'other';
  String _splitMode = 'equal'; // equal | custom
  Map<int, TextEditingController> _customSplitCtrs = {};
  bool _saving = false;

  static const _categories = [
    ('food', 'Oziq-ovqat', Icons.restaurant),
    ('transport', 'Transport', Icons.directions_car),
    ('utilities', 'Kommunal', Icons.bolt),
    ('entertainment', 'Ko\'ngilochar', Icons.sports_esports),
    ('health', 'Sog\'liq', Icons.favorite),
    ('other', 'Boshqa', Icons.more_horiz),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    for (final c in _customSplitCtrs.values) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(periodMembersProvider(widget.periodId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xarajat qo\'shish'),
      ),
      body: membersAsync.when(
        data: (members) {
          // Initialize controllers for custom splits
          for (final m in members) {
            if (!_customSplitCtrs.containsKey(m.id)) {
              _customSplitCtrs[m.id] = TextEditingController();
            }
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Title
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Xarajat nomi',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nom kiritish shart' : null,
                ),
                const SizedBox(height: 12),

                // Amount
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Summa',
                    prefixIcon: Icon(Icons.attach_money),
                    suffixText: 'UZS',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Summa kiritish shart';
                    final n = double.tryParse(v.replaceAll(',', '.'));
                    if (n == null || n <= 0) return 'To\'g\'ri summa kiriting';
                    return null;
                  },
                  onChanged: (_) {
                    if (_splitMode == 'equal') _recalcEqual(members);
                  },
                ),
                const SizedBox(height: 12),

                // Date
                InkWell(
                  onTap: () => _pickDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Sana',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat('dd.MM.yyyy').format(_date)),
                  ),
                ),
                const SizedBox(height: 12),

                // Category
                const Text('Kategoriya',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((cat) {
                    final selected = _category == cat.$1;
                    return FilterChip(
                      avatar: Icon(cat.$3, size: 16),
                      label: Text(cat.$2),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _category = cat.$1),
                      selectedColor: AppTheme.accent.withOpacity(0.15),
                      checkmarkColor: AppTheme.accent,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Payer
                const Text('Kim to\'ladi?',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: members.map((m) {
                    Color avatarColor;
                    try {
                      avatarColor = Color(
                          int.parse(m.color.replaceAll('#', '0xFF')));
                    } catch (_) {
                      avatarColor = AppTheme.accent;
                    }
                    final selected = _selectedPayer == m.id;
                    return ChoiceChip(
                      avatar: CircleAvatar(
                        backgroundColor: avatarColor,
                        radius: 12,
                        child: Text(m.name[0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11)),
                      ),
                      label: Text(m.name),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedPayer = m.id),
                      selectedColor: AppTheme.primary.withOpacity(0.12),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Split mode
                const Text('Qanday bo\'linadi?',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: 'equal',
                        label: Text('Teng taqsimlanadi'),
                        icon: Icon(Icons.balance)),
                    ButtonSegment(
                        value: 'custom',
                        label: Text('Shaxsiy'),
                        icon: Icon(Icons.tune)),
                  ],
                  selected: {_splitMode},
                  onSelectionChanged: (s) {
                    setState(() {
                      _splitMode = s.first;
                      if (_splitMode == 'equal') _recalcEqual(members);
                    });
                  },
                ),
                if (_splitMode == 'custom') ...[
                  const SizedBox(height: 12),
                  ...members.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          controller: _customSplitCtrs[m.id],
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: '${m.name} ulushi',
                            prefixText: 'UZS  ',
                            isDense: true,
                          ),
                        ),
                      )),
                ],

                const SizedBox(height: 12),

                // Note
                TextFormField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Izoh (ixtiyoriy)',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Save button
                FilledButton.icon(
                  onPressed: _saving ? null : () => _save(members),
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save),
                  label:
                      Text(_saving ? 'Saqlanmoqda...' : 'Xarajatni saqlash'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Xato: $e')),
      ),
    );
  }

  void _recalcEqual(List<PeriodMember> members) {
    if (members.isEmpty) return;
    final amount =
        double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? 0;
    final share = amount / members.length;
    for (final m in members) {
      _customSplitCtrs[m.id]?.text = share.toStringAsFixed(0);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save(List<PeriodMember> members) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kim to'laganini tanlang")));
      return;
    }

    final amount =
        double.parse(_amountCtrl.text.trim().replaceAll(',', '.'));

    // Build splits
    Map<int, double> splits;
    if (_splitMode == 'equal') {
      final share = amount / members.length;
      splits = {for (final m in members) m.id: share};
    } else {
      splits = {};
      for (final m in members) {
        final v = double.tryParse(
                _customSplitCtrs[m.id]?.text.replaceAll(',', '.') ?? '') ??
            0;
        if (v > 0) splits[m.id] = v;
      }
      if (splits.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamida bitta ulush kiriting')));
        return;
      }
    }

    setState(() => _saving = true);

    await ref.read(expenseNotifierProvider.notifier).addExpense(
          periodId: widget.periodId,
          paidByMemberId: _selectedPayer!,
          title: _titleCtrl.text.trim(),
          amount: amount,
          currency: 'UZS',
          date: _date,
          category: _category,
          note: _noteCtrl.text.trim(),
          splits: splits,
        );

    setState(() => _saving = false);

    // Refresh balances
    ref.invalidate(periodBalancesProvider(widget.periodId));
    ref.invalidate(periodTotalProvider(widget.periodId));
    ref.invalidate(periodExpensesProvider(widget.periodId));

    if (mounted) Navigator.pop(context);
  }
}
