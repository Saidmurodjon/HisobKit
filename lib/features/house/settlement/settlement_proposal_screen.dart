import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/settlement_dao.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/providers/settings_provider.dart';
import 'settlement_providers.dart';

extension _StringExt on String {
  String? get nullIfEmpty => trim().isEmpty ? null : trim();
}

/// Hisob-kitobni taklif qilish va a'zolar tasdiqlash ekrani.
/// Status: draft → proposed → confirming → disputed/signed → archived
class SettlementProposalScreen extends ConsumerStatefulWidget {
  final int periodId;
  const SettlementProposalScreen({super.key, required this.periodId});

  @override
  ConsumerState<SettlementProposalScreen> createState() =>
      _SettlementProposalScreenState();
}

class _SettlementProposalScreenState
    extends ConsumerState<SettlementProposalScreen> {
  bool _proposing = false;
  int? _selectedMemberId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balancesAsync = ref.watch(periodBalancesProvider(widget.periodId));
    final transfersAsync = ref.watch(periodTransfersProvider(widget.periodId));
    final membersAsync = ref.watch(periodMembersProvider(widget.periodId));
    final totalAsync = ref.watch(periodTotalProvider(widget.periodId));
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisob-kitob taklifi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Jami
          totalAsync.when(
            data: (total) => _TotalCard(total: total, currency: currency),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),

          // Balanslar jadval
          Text('Balanslar',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          balancesAsync.when(
            data: (balances) => _BalancesTable(
                balances: balances, currency: currency),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (e, _) => Text('Xato: $e'),
          ),
          const SizedBox(height: 20),

          // Minimal o'tkazmalar
          Text("Minimal o'tkazmalar",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          transfersAsync.when(
            data: (transfers) => transfers.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.accent),
                        SizedBox(width: 8),
                        Text('Hamma barobar!',
                            style: TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : Column(
                    children: transfers
                        .asMap()
                        .entries
                        .map((e) => _TransferRow(
                              index: e.key + 1,
                              transfer: e.value,
                              currency: currency,
                            ))
                        .toList(),
                  ),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (e, _) => Text('Xato: $e'),
          ),
          const SizedBox(height: 24),

          // Tasdiqlash sektsiyasi
          Text("Tasdiqlash",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          membersAsync.when(
            data: (members) {
              if (_selectedMemberId == null && members.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() => _selectedMemberId = members.first.id));
              }
              return _ConfirmSection(
                members: members,
                selectedMemberId: _selectedMemberId,
                periodId: widget.periodId,
                onMemberSelected: (id) =>
                    setState(() => _selectedMemberId = id),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('Xato: $e'),
          ),
          const SizedBox(height: 24),

          // Yakunlash / Arxivlash tugmalar
          _ActionButtons(
            periodId: widget.periodId,
            proposing: _proposing,
            onPropose: () => _saveProposal(context),
            onArchive: () => _archive(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _saveProposal(BuildContext context) async {
    setState(() => _proposing = true);
    try {
      final db = ref.read(databaseProvider);
      final balances =
          await db.settlementDao.computeBalances(widget.periodId);
      final transfers = SettlementDao.calcMinimalTransfers(balances);
      final members =
          await db.settlementDao.getMembersForPeriod(widget.periodId);

      // Save minimal transfers to local DB
      await db.settlementDao
          .saveTransfers(widget.periodId, transfers);

      // Initialize confirmations (all pending)
      await db.settlementDao.initConfirmations(
          widget.periodId, members.map((m) => m.id).toList());

      // Update status to 'proposed'
      await db.settlementDao
          .updatePeriodStatus(widget.periodId, 'proposed');

      // Refresh providers
      ref.invalidate(periodConfirmationsProvider(widget.periodId));
      ref.invalidate(periodBalancesProvider(widget.periodId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hisob-kitob taklif qilindi ✓'),
            backgroundColor: AppTheme.accent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xato: $e')));
      }
    }
    setState(() => _proposing = false);
  }

  Future<void> _archive(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Arxivlash'),
        content: const Text(
            'Bu davrni arxivlashni tasdiqlaysizmi? Davr yopiladi.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Bekor qilish')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Arxivlash'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(periodNotifierProvider.notifier)
          .updateStatus(widget.periodId, 'archived');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Davr arxivlandi')),
      );
      Navigator.pop(context);
    }
  }
}

// ── Jami summa ────────────────────────────────────────────────────────────────

class _TotalCard extends StatelessWidget {
  final double total;
  final String currency;

  const _TotalCard({required this.total, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1A3A5C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined,
              color: Colors.white70, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jami xarajat',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
              Text(
                CurrencyFormatter.format(total, currency),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Balanslar jadval ──────────────────────────────────────────────────────────

class _BalancesTable extends StatelessWidget {
  final List<MemberBalance> balances;
  final String currency;

  const _BalancesTable({required this.balances, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: balances.asMap().entries.map((entry) {
          final i = entry.key;
          final b = entry.value;
          final isCreditor = b.balance > 0;
          final isDebtor = b.balance < 0;
          final color = isCreditor
              ? AppTheme.accent
              : isDebtor
                  ? AppTheme.danger
                  : theme.colorScheme.onSurfaceVariant;

          Color avatarColor;
          try {
            avatarColor =
                Color(int.parse(b.color.replaceAll('#', '0xFF')));
          } catch (_) {
            avatarColor = AppTheme.accent;
          }

          return Column(
            children: [
              if (i > 0)
                Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: avatarColor,
                  radius: 18,
                  child: Text(
                    b.name.isNotEmpty ? b.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                title: Text(b.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'To\'ladi: ${CurrencyFormatter.format(b.paid, currency)}'
                  '\nUlushi: ${CurrencyFormatter.format(b.consumed, currency)}',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (isCreditor ? '+' : isDebtor ? '−' : '') +
                          CurrencyFormatter.format(b.balance.abs(), currency),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: color, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      isCreditor
                          ? 'Oladi'
                          : isDebtor
                              ? 'Beradi'
                              : 'Barobar',
                      style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── O'tkazma qatori ───────────────────────────────────────────────────────────

class _TransferRow extends StatelessWidget {
  final int index;
  final TransferResult transfer;
  final String currency;

  const _TransferRow({
    required this.index,
    required this.transfer,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: AppTheme.transferColor.withOpacity(0.15),
              child: Text('$index',
                  style: const TextStyle(
                      color: AppTheme.transferColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: transfer.fromName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const TextSpan(text: ' → '),
                    TextSpan(
                        text: transfer.toName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            Text(
              CurrencyFormatter.format(transfer.amount, currency),
              style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: AppTheme.transferColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tasdiqlash sektsiyasi ─────────────────────────────────────────────────────

class _ConfirmSection extends ConsumerStatefulWidget {
  final List<PeriodMember> members;
  final int? selectedMemberId;
  final int periodId;
  final void Function(int) onMemberSelected;

  const _ConfirmSection({
    required this.members,
    required this.selectedMemberId,
    required this.periodId,
    required this.onMemberSelected,
  });

  @override
  ConsumerState<_ConfirmSection> createState() => _ConfirmSectionState();
}

class _ConfirmSectionState extends ConsumerState<_ConfirmSection> {
  bool _confirming = false;
  final _disputeCtrl = TextEditingController();

  @override
  void dispose() {
    _disputeCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm(bool isConfirm) async {
    if (widget.selectedMemberId == null) return;
    setState(() => _confirming = true);

    try {
      final db = ref.read(databaseProvider);
      await db.settlementDao.updateConfirmation(
        widget.periodId,
        widget.selectedMemberId!,
        isConfirm ? 'confirmed' : 'disputed',
        disputeReason:
            isConfirm ? null : _disputeCtrl.text.trim().nullIfEmpty,
      );

      // Check if all confirmed → 'signed', any disputed → 'disputed'
      final confs = await db.settlementDao
          .getConfirmationsForPeriod(widget.periodId);
      final hasDispute = confs.any((c) => c.status == 'disputed');
      final allConfirmed =
          confs.isNotEmpty && confs.every((c) => c.status == 'confirmed');

      if (hasDispute) {
        await db.settlementDao
            .updatePeriodStatus(widget.periodId, 'disputed');
      } else if (allConfirmed) {
        await db.settlementDao
            .updatePeriodStatus(widget.periodId, 'signed');
      } else {
        await db.settlementDao
            .updatePeriodStatus(widget.periodId, 'confirming');
      }

      ref.invalidate(periodConfirmationsProvider(widget.periodId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isConfirm
              ? 'Tasdiqlandi ✓'
              : 'Ixtilof yuborildi'),
          backgroundColor: isConfirm ? AppTheme.accent : AppTheme.danger,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xato: $e')));
      }
    }
    setState(() => _confirming = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.members.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Siz qaysi a\'zosiz? Hisob-kitobni tasdiqlash uchun o\'zingizni tanlang:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.members.map((m) {
                final selected = widget.selectedMemberId == m.id;
                return ChoiceChip(
                  label: Text(m.name),
                  selected: selected,
                  onSelected: (_) => widget.onMemberSelected(m.id),
                  selectedColor: AppTheme.primary.withOpacity(0.12),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _confirming
                        ? null
                        : () => _showDisputeDialog(context),
                    icon: const Icon(Icons.error_outline, color: AppTheme.danger),
                    label: const Text('Ixtilof bildirish',
                        style: TextStyle(color: AppTheme.danger)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.danger),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _confirming ? null : () => _confirm(true),
                    icon: const Icon(Icons.check),
                    label: const Text('Tasdiqlash'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDisputeDialog(BuildContext context) async {
    _disputeCtrl.clear();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ixtilof sababi'),
        content: TextField(
          controller: _disputeCtrl,
          decoration: const InputDecoration(
            hintText: 'Ixtilof sababini yozing...',
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Bekor qilish')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Ixtilof yuborish'),
          ),
        ],
      ),
    );
    if (confirm == true) _confirm(false);
  }
}

// ── Harakat tugmalari ─────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final int periodId;
  final bool proposing;
  final VoidCallback onPropose;
  final VoidCallback onArchive;

  const _ActionButtons({
    required this.periodId,
    required this.proposing,
    required this.onPropose,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: proposing ? null : onPropose,
          icon: proposing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.send_outlined),
          label: Text(proposing ? 'Yuklanmoqda...' : 'Taklif sifatida saqlash'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onArchive,
          icon: const Icon(Icons.archive_outlined),
          label: const Text('Arxivlash'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}
