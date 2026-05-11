import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../debt_providers.dart';
import 'trust_providers.dart';

class DebtVerificationScreen extends ConsumerWidget {
  final int debtId;
  const DebtVerificationScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final debtsAsync = ref.watch(allDebtsProvider);
    final verificationAsync = ref.watch(signatureVerificationProvider(debtId));

    return debtsAsync.when(
      data: (debts) {
        final debtList = debts.where((d) => d.id == debtId).toList();
        if (debtList.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.verifyDebt)),
            body: Center(child: Text(l10n.noDebts)),
          );
        }
        final debt = debtList.first;
        final isLent = debt.type == 'lent';

        return Scaffold(
          appBar: AppBar(title: Text(l10n.verifyDebt)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Debt info card
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
                                Text(debt.personName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
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
                            '${l10n.dueDate}: ${DateFormatter.format(debt.dueDate!)}'),
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

              const SizedBox(height: 12),

              // Content hash card
              if (debt.contentHash != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(l10n.contentHash,
                                style:
                                    Theme.of(context).textTheme.labelSmall),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.copy_outlined, size: 18),
                              tooltip: l10n.copyKey,
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: debt.contentHash!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Copied!'),
                                      duration: Duration(seconds: 1)),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          debt.contentHash!,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Signature verification card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.verifySignatures,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      verificationAsync.when(
                        data: (result) => Column(
                          children: [
                            _VerifyRow(
                              label: l10n.lenderSignature,
                              ok: result.lenderOk,
                            ),
                            _VerifyRow(
                              label: l10n.borrowerSignature,
                              ok: result.borrowerOk,
                            ),
                            _VerifyRow(
                              label: l10n.contentHash,
                              ok: result.hashOk,
                            ),
                            const Divider(),
                            _VerifyRow(
                              label: result.isValid
                                  ? l10n.bothPartiesConfirmed
                                  : (result.errorMessage ?? l10n.signatureInvalid),
                              ok: result.isValid,
                              bold: true,
                            ),
                          ],
                        ),
                        loading: () =>
                            const CircularProgressIndicator.adaptive(),
                        error: (e, _) => Text('Error: $e'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              if (debt.status == 'pending') ...[
                FilledButton.icon(
                  onPressed: () => _confirmDebt(context, ref, l10n),
                  icon: const Icon(Icons.check_circle_outlined),
                  label: Text(l10n.confirmDebt),
                  style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.incomeColor),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _rejectDebt(context, ref, l10n),
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(l10n.rejectDebtAction),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.expenseColor),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Future<void> _confirmDebt(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final signingService = ref.read(debtSigningServiceProvider);
    final debtsAsync = ref.read(allDebtsProvider);
    final debt = debtsAsync.value?.firstWhere((d) => d.id == debtId);
    // Borrower-initiated: has borrowerPublicKey but no lenderPublicKey
    final isBorrowerInitiated = debt != null
        && debt.borrowerPublicKey != null
        && (debt.lenderPublicKey == null || debt.lenderPublicKey!.isEmpty);
    try {
      if (isBorrowerInitiated) {
        await signingService.confirmAsLenderForBorrowerRequest(debtId);
      } else {
        await signingService.signAsBorrower(debtId);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.debtConfirmed)),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${l10n.errorOccurred}: $e'),
              backgroundColor: AppTheme.expenseColor),
        );
      }
    }
  }

  Future<void> _rejectDebt(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.rejectDebtAction),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(labelText: l10n.rejectionReason),
          maxLines: 2,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                FilledButton.styleFrom(backgroundColor: AppTheme.expenseColor),
            child: Text(l10n.rejectDebtAction),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final signingService = ref.read(debtSigningServiceProvider);
      await signingService.rejectDebt(debtId, reasonController.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.debtRejected)),
        );
        context.pop();
      }
    }
  }
}

class _VerifyRow extends StatelessWidget {
  final String label;
  final bool ok;
  final bool bold;

  const _VerifyRow({
    required this.label,
    required this.ok,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_outlined : Icons.cancel_outlined,
            color: ok ? AppTheme.incomeColor : AppTheme.expenseColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
