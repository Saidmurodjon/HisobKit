import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import 'trust_providers.dart';
import 'trust_exceptions.dart';

class SyncMethodSheet extends ConsumerStatefulWidget {
  final int debtId;
  const SyncMethodSheet({super.key, required this.debtId});

  @override
  ConsumerState<SyncMethodSheet> createState() => _SyncMethodSheetState();
}

class _SyncMethodSheetState extends ConsumerState<SyncMethodSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contactsAsync = ref.watch(knownContactsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.syncMethod,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // QR option
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0x1A00C896),
                child: Icon(Icons.qr_code_outlined, color: AppTheme.accent),
              ),
              title: Text(l10n.showQR),
              subtitle: Text(l10n.syncViaQr),
              onTap: _isLoading
                  ? null
                  : () => _handleQR(context, contactsAsync),
            ),

            // File option
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0x1A1E88E5),
                child: Icon(Icons.attach_file_outlined,
                    color: Color(0xFF1E88E5)),
              ),
              title: Text(l10n.sendViaFile),
              subtitle: const Text('.hkd'),
              onTap: _isLoading
                  ? null
                  : () => _handleFile(context, contactsAsync),
            ),

            // PocketBase option
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0x1AFF4D4F),
                child: Icon(Icons.cloud_upload_outlined,
                    color: AppTheme.expenseColor),
              ),
              title: Text(l10n.sendViaPocketBase),
              subtitle: Text(l10n.syncMethod),
              onTap: _isLoading
                  ? null
                  : () => _handlePocketBase(context),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
          ],
        ),
      ),
    );
  }

  Future<String?> _pickRecipient(
      BuildContext context, AsyncValue contactsValue) async {
    final contacts = contactsValue.value ?? [];
    if (contacts.isEmpty) return null;

    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(AppLocalizations.of(ctx)!.trustContacts),
        children: contacts
            .map((c) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, c.publicKey),
                  child: Text(c.displayName),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _handleQR(
      BuildContext context, AsyncValue contactsValue) async {
    final l10n = AppLocalizations.of(context)!;
    final recipientPk = await _pickRecipient(context, contactsValue);
    if (recipientPk == null || !context.mounted) return;

    setState(() => _isLoading = true);
    try {
      final syncService = ref.read(debtSyncServiceProvider);
      final qrData = await syncService.exportAsQR(
        debtId: widget.debtId,
        recipientPublicKey: recipientPk,
      );

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.showQR),
          content: SizedBox(
            width: 280,
            height: 280,
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 280,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.close)),
          ],
        ),
      );
    } on QrTooLargeException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.tampered}: ${e.bytes} bytes > 2800'),
            backgroundColor: AppTheme.expenseColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorOccurred}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleFile(
      BuildContext context, AsyncValue contactsValue) async {
    final l10n = AppLocalizations.of(context)!;
    final recipientPk = await _pickRecipient(context, contactsValue);
    if (recipientPk == null || !context.mounted) return;

    setState(() => _isLoading = true);
    try {
      final syncService = ref.read(debtSyncServiceProvider);
      await syncService.exportAsFile(
        debtId: widget.debtId,
        recipientPublicKey: recipientPk,
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorOccurred}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePocketBase(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final syncService = ref.read(debtSyncServiceProvider);
    final isConfigured = await syncService.isPocketBaseConfigured();

    if (!context.mounted) return;

    if (!isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.sendViaPocketBase),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // If configured, contacts needed for recipient
    final contactsAsync = ref.read(knownContactsProvider);
    final recipientPk = await _pickRecipient(context, contactsAsync);
    if (recipientPk == null || !context.mounted) return;

    setState(() => _isLoading = true);
    try {
      await syncService.sendViaPocketBase(
        debtId: widget.debtId,
        recipientPublicKey: recipientPk,
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorOccurred}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
