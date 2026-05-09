import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/currency_formatter.dart';
import 'house_providers.dart';

class SettlementScreen extends ConsumerWidget {
  final int groupId;

  const SettlementScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';
    final settlementAsync = ref.watch(settlementProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settlement),
      ),
      body: settlementAsync.when(
        data: (transfers) {
          if (transfers.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 72,
                      color: AppTheme.accent.withOpacity(0.6)),
                  const SizedBox(height: 16),
                  Text(l10n.settlementDone,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600,
                          )),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n.minTransfers,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accent,
                              )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Transfer items
              ...transfers.map((t) => _TransferCard(
                    transfer: t,
                    currency: currency,
                    onSettle: () => _confirmSettle(context, ref, t, currency),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  Future<void> _confirmSettle(
      BuildContext context, WidgetRef ref, SettlementTransfer transfer, String currency) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmSettlement),
        content: Text(
          '${transfer.from.name} → ${transfer.to.name}: ${CurrencyFormatter.format(transfer.amount, currency)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.houseDao.insertSettlement(
        HouseSettlementsCompanion.insert(
          groupId: groupId,
          fromMemberId: transfer.from.id,
          toMemberId: transfer.to.id,
          amount: Value(transfer.amount),
        ),
      );
      ref.invalidate(settlementProvider(groupId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settlementDone),
            backgroundColor: AppTheme.accent,
          ),
        );
      }
    }
  }
}

class _TransferCard extends StatelessWidget {
  final SettlementTransfer transfer;
  final String currency;
  final VoidCallback onSettle;

  const _TransferCard({
    required this.transfer,
    required this.currency,
    required this.onSettle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            // From member
            _MemberBadge(name: transfer.from.name, color: transfer.from.color),
            const SizedBox(width: 8),
            Column(
              children: [
                const Icon(Icons.arrow_forward, color: AppTheme.accent, size: 18),
                Text(
                  CurrencyFormatter.format(transfer.amount, currency),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // To member
            _MemberBadge(name: transfer.to.name, color: transfer.to.color),
            const Spacer(),
            OutlinedButton(
              onPressed: onSettle,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                side: const BorderSide(color: AppTheme.accent),
                foregroundColor: AppTheme.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Icon(Icons.check, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberBadge extends StatelessWidget {
  final String name;
  final String color;

  const _MemberBadge({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.colorFromHex(color),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 4),
        Text(name,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
