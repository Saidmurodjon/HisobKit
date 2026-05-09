import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import 'trust_providers.dart';
import 'debt_sync_service.dart';

class IncomingRequestsScreen extends ConsumerWidget {
  const IncomingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pendingAsync = ref.watch(pendingDebtsProvider);
    final myPkAsync = ref.watch(myPublicKeyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.incomingRequests),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            tooltip: l10n.scanQR,
            onPressed: () => _showQrScanner(context, ref),
          ),
        ],
      ),
      body: pendingAsync.when(
        data: (debts) {
          if (debts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noIncomingRequests,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: debts.length,
            itemBuilder: (ctx, i) {
              final debt = debts[i];
              final isLent = debt.type == 'lent';

              return myPkAsync.when(
                data: (myPk) {
                  // Find contact name for lender PK
                  final lenderPkTrunc = debt.lenderPublicKey != null
                      ? '${debt.lenderPublicKey!.substring(0, 16.clamp(0, debt.lenderPublicKey!.length))}...'
                      : '—';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
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
                      title: Text(debt.personName,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CurrencyFormatter.format(
                                debt.amount, debt.currency),
                          ),
                          Text(lenderPkTrunc,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      trailing: _StatusChip(status: debt.status),
                      onTap: () => context.push('/debts/${debt.id}/verify'),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showQrScanner(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(ctx)!.scanQR,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) async {
                  final code = capture.barcodes.firstOrNull?.rawValue;
                  if (code == null) return;
                  Navigator.pop(ctx);
                  final syncService = ref.read(debtSyncServiceProvider);
                  try {
                    await syncService.importFromQR(code);
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(
                              AppLocalizations.of(ctx)!.savedSuccessfully),
                        ),
                      );
                    }
                  } catch (e) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${AppLocalizations.of(ctx)!.errorOccurred}: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = switch (status) {
      'pending' => (l10n.debtPending, Colors.orange),
      'confirmed' => (l10n.debtConfirmed, AppTheme.incomeColor),
      'rejected' => (l10n.debtRejected, AppTheme.expenseColor),
      'expired' => (l10n.debtExpired, Colors.grey),
      'settled' => (l10n.debtSettled, AppTheme.accent),
      _ => ('draft', Colors.blueGrey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
