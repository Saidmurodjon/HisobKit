import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import 'trust_providers.dart';

class DebtAuditScreen extends ConsumerWidget {
  final int debtId;
  const DebtAuditScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final eventsAsync = ref.watch(debtEventsProvider(debtId));
    final verificationAsync = ref.watch(signatureVerificationProvider(debtId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auditLog),
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_outlined,
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
            itemCount: events.length,
            itemBuilder: (ctx, i) {
              final event = events[i];
              final actorTrunc = event.actorPublicKey != null
                  ? '${event.actorPublicKey!.substring(0, event.actorPublicKey!.length.clamp(0, 16))}...'
                  : '—';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        _eventColor(event.eventType).withOpacity(0.15),
                    child: Icon(
                      _eventIcon(event.eventType),
                      color: _eventColor(event.eventType),
                      size: 20,
                    ),
                  ),
                  title: Text(_eventLabel(event.eventType, l10n)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormatter.format(event.occurredAt),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        actorTrunc,
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showVerificationDialog(
            context, verificationAsync),
        icon: const Icon(Icons.verified_outlined),
        label: Text(AppLocalizations.of(context)!.verifySignatures),
      ),
    );
  }

  IconData _eventIcon(String type) {
    return switch (type) {
      'lender_signed' => Icons.edit_outlined,
      'confirmed' => Icons.check_circle_outlined,
      'rejected' => Icons.cancel_outlined,
      'expired' => Icons.timer_off_outlined,
      'received' => Icons.download_outlined,
      _ => Icons.info_outlined,
    };
  }

  Color _eventColor(String type) {
    return switch (type) {
      'lender_signed' => Colors.blue,
      'confirmed' => AppTheme.incomeColor,
      'rejected' => AppTheme.expenseColor,
      'expired' => Colors.grey,
      'received' => Colors.purple,
      _ => Colors.blueGrey,
    };
  }

  String _eventLabel(String type, AppLocalizations l10n) {
    return switch (type) {
      'lender_signed' => l10n.lenderSignature,
      'confirmed' => l10n.debtConfirmed,
      'rejected' => l10n.debtRejected,
      'expired' => l10n.debtExpired,
      'received' => l10n.incomingRequests,
      _ => type,
    };
  }

  void _showVerificationDialog(
      BuildContext context, AsyncValue verificationAsync) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.verifySignatures),
        content: verificationAsync.when(
          data: (result) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _VerifyRow(label: l10n.lenderSignature, ok: result.lenderOk),
                _VerifyRow(
                    label: l10n.borrowerSignature, ok: result.borrowerOk),
                _VerifyRow(label: l10n.contentHash, ok: result.hashOk),
                const Divider(),
                _VerifyRow(
                  label: result.isValid
                      ? l10n.bothPartiesConfirmed
                      : l10n.signatureInvalid,
                  ok: result.isValid,
                  bold: true,
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator.adaptive(),
          error: (e, _) => Text('Error: $e'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close)),
        ],
      ),
    );
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
