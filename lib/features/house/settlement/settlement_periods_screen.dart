import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import 'settlement_providers.dart';

class SettlementPeriodsScreen extends ConsumerWidget {
  final int groupId;
  const SettlementPeriodsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodsAsync = ref.watch(settlementPeriodsProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisob-kitob davrlari'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Yangi davr',
            onPressed: () => _showCreatePeriodDialog(context, ref),
          ),
        ],
      ),
      body: periodsAsync.when(
        data: (periods) {
          if (periods.isEmpty) {
            return _EmptyState(
                onAdd: () => _showCreatePeriodDialog(context, ref));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: periods.length,
            itemBuilder: (ctx, i) => _PeriodCard(
              period: periods[i],
              onTap: () => context.push(
                '/house/periods/${periods[i].id}',
                extra: periods[i],
              ),
              onDelete: () => _confirmDelete(ctx, ref, periods[i].id),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Xato: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePeriodDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Yangi davr'),
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showCreatePeriodDialog(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CreatePeriodSheet(groupId: groupId),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, int periodId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Davrni o\'chirish'),
        content: const Text(
            'Bu davrni o\'chirish barcha xarajatlar va ma\'lumotlarni o\'chiradi. Davom etasizmi?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Bekor qilish')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('O\'chirish',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      ref.read(periodNotifierProvider.notifier).deletePeriod(periodId);
    }
  }
}

// ── Karta ─────────────────────────────────────────────────────────────────────

class _PeriodCard extends StatelessWidget {
  final SettlementPeriod period;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PeriodCard({
    required this.period,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('dd.MM.yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      period.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  _StatusBadge(status: period.status),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    visualDensity: VisualDensity.compact,
                    color: AppTheme.danger,
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${fmt.format(period.startDate)} – ${fmt.format(period.endDate)}',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'draft' => ('Qoralama', Colors.grey),
      'proposed' => ('Taklif qilingan', Colors.blue),
      'confirming' => ('Tasdiqlanmoqda', Colors.orange),
      'disputed' => ('Ixtilof', AppTheme.danger),
      'signed' => ('Imzolangan', AppTheme.accent),
      'archived' => ('Arxivlangan', Colors.purple),
      _ => (status, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          )),
    );
  }
}

// ── Bo'sh holat ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calculate_outlined,
              size: 80, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'Hali hisob-kitob davrlari yo\'q',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Yangi davr yarating va xarajatlarni kuzating',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Yangi davr yaratish'),
          ),
        ],
      ),
    );
  }
}

// ── Yangi davr yaratish sheet ─────────────────────────────────────────────────

class _CreatePeriodSheet extends ConsumerStatefulWidget {
  final int groupId;
  const _CreatePeriodSheet({required this.groupId});

  @override
  ConsumerState<_CreatePeriodSheet> createState() => _CreatePeriodSheetState();
}

class _CreatePeriodSheetState extends ConsumerState<_CreatePeriodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  final List<TextEditingController> _memberCtrs = [
    TextEditingController(),
  ];
  final List<String> _memberColors = ['#00C896'];
  bool _saving = false;

  static const _palette = [
    '#00C896', '#1E88E5', '#FF7043', '#AB47BC',
    '#FFB300', '#26A69A', '#EF5350', '#5C6BC0',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    for (final c in _memberCtrs) c.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) _endDate = _startDate;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final names = _memberCtrs.map((c) => c.text.trim()).toList();
    if (names.any((n) => n.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barcha a\'zo ismlarini kiriting')));
      return;
    }

    setState(() => _saving = true);
    final periodId =
        await ref.read(periodNotifierProvider.notifier).createPeriod(
              groupId: widget.groupId,
              title: _titleCtrl.text.trim(),
              startDate: _startDate,
              endDate: _endDate,
              memberNames: names,
              memberColors: _memberColors,
            );
    setState(() => _saving = false);

    if (mounted) {
      Navigator.pop(context);
      if (periodId != null) {
        // Navigate to the newly created period
        context.push('/house/periods/$periodId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('dd.MM.yyyy');

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text('Yangi davr yaratish',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Davr nomi',
                hintText: 'Masalan: Aprel 2025 uy xarajatlari',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Nom kiritish shart' : null,
            ),
            const SizedBox(height: 12),

            // Date range
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'Boshlanish',
                    date: fmt.format(_startDate),
                    onTap: () => _pickDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTile(
                    label: 'Tugash',
                    date: fmt.format(_endDate),
                    onTap: () => _pickDate(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Members
            Row(
              children: [
                Text("A'zolar",
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _memberCtrs.add(TextEditingController());
                      _memberColors.add(
                          _palette[_memberCtrs.length % _palette.length]);
                    });
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 16),
                  label: const Text("A'zo qo'shish"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _memberCtrs.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final idx = _palette.indexOf(_memberColors[i]);
                        setState(() {
                          _memberColors[i] =
                              _palette[(idx + 1) % _palette.length];
                        });
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            Color(int.parse(_memberColors[i].replaceAll('#', '0xFF'))),
                        child: const Icon(Icons.person,
                            size: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _memberCtrs[i],
                        decoration: InputDecoration(
                          labelText: "A'zo ${i + 1} ismi",
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_memberCtrs.length > 1)
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: AppTheme.danger, size: 20),
                        onPressed: () {
                          setState(() {
                            _memberCtrs.removeAt(i).dispose();
                            _memberColors.removeAt(i);
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Yaratish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;

  const _DateTile(
      {required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(date,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
