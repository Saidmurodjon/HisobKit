import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../debt_providers.dart';
import 'trust_providers.dart';
import 'sync_method_sheet.dart';

class SendDebtScreen extends ConsumerWidget {
  final int debtId;
  const SendDebtScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final debtsAsync = ref.watch(allDebtsProvider);

    return debtsAsync.when(
      data: (debts) {
        final debtList = debts.where((d) => d.id == debtId).toList();
        if (debtList.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.signAndSend)),
            body: Center(child: Text(l10n.noDebts)),
          );
        }
        final debt = debtList.first;
        final isLent = debt.type == 'lent';

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.signAndSend),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Status badge
              if (debt.status != 'draft')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _statusColor(debt.status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _statusColor(debt.status).withOpacity(0.3)),
                  ),
                  child: Text(
                    debt.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(debt.status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),

              // Debt details card (read-only)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                Text(
                                  debt.personName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  CurrencyFormatter.format(
                                      debt.amount, debt.currency),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isLent
                                        ? AppTheme.incomeColor
                                        : AppTheme.expenseColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (debt.dueDate != null) ...[
                        const Divider(height: 24),
                        Text(
                          '${l10n.dueDate}: ${DateFormatter.format(debt.dueDate!)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                      if (debt.note.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(debt.note,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ],
                  ),
                ),
              ),

              // Content hash preview
              if (debt.contentHash != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.contentHash,
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 4),
                        Text(
                          '${debt.contentHash!.substring(0, 16)}...',
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Sign & Send button
              FilledButton.icon(
                onPressed: debt.status == 'draft'
                    ? () => _signAndSend(context, ref, l10n)
                    : () => _showSyncSheet(context),
                icon: const Icon(Icons.send_outlined),
                label: Text(debt.status == 'draft'
                    ? l10n.signAndSend
                    : l10n.syncMethod),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'pending' => Colors.orange,
      'confirmed' => AppTheme.incomeColor,
      'rejected' => AppTheme.expenseColor,
      'expired' => Colors.grey,
      'settled' => AppTheme.accent,
      _ => Colors.transparent,
    };
  }

  Future<void> _signAndSend(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final signingService = ref.read(debtSigningServiceProvider);
    final debtsAsync = ref.read(allDebtsProvider);
    final debt = debtsAsync.value?.firstWhere((d) => d.id == debtId);
    try {
      if (debt?.type == 'borrowed') {
        await signingService.signAsBorrowerFirst(debtId);
      } else {
        await signingService.signAsLender(debtId);
      }
      if (context.mounted) _showSyncSheet(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorOccurred}: $e')),
        );
      }
    }
  }

  void _showSyncSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SyncMethodSheet(debtId: debtId),
    );
  }
}
