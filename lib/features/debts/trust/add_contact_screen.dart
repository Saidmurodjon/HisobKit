import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class AddContactScreen extends ConsumerStatefulWidget {
  const AddContactScreen({super.key});

  @override
  ConsumerState<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends ConsumerState<AddContactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameController = TextEditingController();
  final _pkController = TextEditingController();
  bool _scanned = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _pkController.dispose();
    super.dispose();
  }

  void _onQrDetected(BarcodeCapture capture) {
    if (_scanned) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null) return;
    try {
      final map = jsonDecode(code) as Map<String, dynamic>;
      final name = map['name'] as String? ?? '';
      final pk = map['pk'] as String? ?? '';
      if (pk.isNotEmpty) {
        setState(() {
          _scanned = true;
          _nameController.text = name;
          _pkController.text = pk;
        });
        _tabController.animateTo(1);
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final pk = _pkController.text.trim();
    if (name.isEmpty || pk.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final db = ref.read(databaseProvider);
      await db.debtsDao.insertContact(KnownContactsCompanion(
        displayName: Value(name),
        publicKey: Value(pk),
      ));
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.savedSuccessfully)),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addContact),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.scanQR),
            Tab(text: l10n.addContact),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // QR Scanner tab
          Stack(
            children: [
              MobileScanner(onDetect: _onQrDetected),
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.accent, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_scanned)
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '${_nameController.text} — ${_pkController.text.substring(0, 16)}...',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Manual entry tab
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.memberName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pkController,
                  decoration: InputDecoration(
                    labelText: l10n.myPublicKey,
                    prefixIcon: const Icon(Icons.key_outlined),
                    hintText: 'base64...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(l10n.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
