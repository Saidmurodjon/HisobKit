import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/contract_pdf_generator.dart';
import '../../core/theme/app_theme.dart';

/// Shows a form for creating / viewing an Islamic contract for a given debt,
/// with PDF generation + share.
class IslamicContractScreen extends ConsumerStatefulWidget {
  final Debt debt;
  const IslamicContractScreen({super.key, required this.debt});

  @override
  ConsumerState<IslamicContractScreen> createState() =>
      _IslamicContractScreenState();
}

class _IslamicContractScreenState
    extends ConsumerState<IslamicContractScreen> {
  final _signerCtrl = TextEditingController();
  final _borrowerCtrl = TextEditingController();
  final _witness1Ctrl = TextEditingController();
  final _witness2Ctrl = TextEditingController();
  final _guarantorCtrl = TextEditingController();
  final _collateralCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _scheduleCtrl = TextEditingController();

  String _contractType = 'qarz_ul_hasan';
  String _quranRef = 'Al-Baqarah 2:282';
  bool _confirmed = false;
  bool _generating = false;
  bool _saved = false;

  IslamicContract? _existing;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final db = ref.read(databaseProvider);
    final c = await db.islamicContractsDao.getContractByDebtId(widget.debt.id);
    if (c != null && mounted) {
      setState(() {
        _existing = c;
        _contractType = c.contractType;
        _quranRef = c.quranVerseRef;
        _signerCtrl.text = c.signerName;
        _borrowerCtrl.text = c.borrowerName;
        _witness1Ctrl.text = c.witnessOne;
        _witness2Ctrl.text = c.witnessTwo;
        _guarantorCtrl.text = c.guarantorName ?? '';
        _collateralCtrl.text = c.collateralDesc ?? '';
        _noteCtrl.text = c.contractNote;
        _scheduleCtrl.text = c.paymentScheduleJson ?? '';
        _confirmed = c.isConfirmedByBoth;
        _saved = true;
      });
    } else if (mounted) {
      // Pre-fill names from debt
      _signerCtrl.text =
          widget.debt.type == 'lent' ? 'Men' : widget.debt.personName;
      _borrowerCtrl.text =
          widget.debt.type == 'lent' ? widget.debt.personName : 'Men';
    }
  }

  @override
  void dispose() {
    _signerCtrl.dispose();
    _borrowerCtrl.dispose();
    _witness1Ctrl.dispose();
    _witness2Ctrl.dispose();
    _guarantorCtrl.dispose();
    _collateralCtrl.dispose();
    _noteCtrl.dispose();
    _scheduleCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final companion = IslamicContractsCompanion(
      id: _existing != null ? Value(_existing!.id) : const Value.absent(),
      debtId: Value(widget.debt.id),
      contractType: Value(_contractType),
      signerName: Value(_signerCtrl.text.trim()),
      borrowerName: Value(_borrowerCtrl.text.trim()),
      witnessOne: Value(_witness1Ctrl.text.trim()),
      witnessTwo: Value(_witness2Ctrl.text.trim()),
      guarantorName: Value(_guarantorCtrl.text.trim().isEmpty
          ? null
          : _guarantorCtrl.text.trim()),
      collateralDesc: Value(_collateralCtrl.text.trim().isEmpty
          ? null
          : _collateralCtrl.text.trim()),
      paymentScheduleJson: Value(_scheduleCtrl.text.trim().isEmpty
          ? null
          : _scheduleCtrl.text.trim()),
      quranVerseRef: Value(_quranRef),
      contractNote: Value(_noteCtrl.text.trim()),
      isConfirmedByBoth: Value(_confirmed),
    );

    if (_existing != null) {
      await db.islamicContractsDao.updateContract(companion);
    } else {
      final id = await db.islamicContractsDao.insertContract(companion);
      final updated = await db.islamicContractsDao.getContractByDebtId(widget.debt.id);
      if (mounted) setState(() => _existing = updated);
    }

    if (mounted) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shartnoma saqlandi')),
      );
    }
  }

  Future<void> _generateAndShare() async {
    if (!_saved) {
      await _save();
    }
    final c = _existing ?? await ref.read(databaseProvider).islamicContractsDao.getContractByDebtId(widget.debt.id);
    if (c == null) return;

    setState(() => _generating = true);
    try {
      final file = await ContractPdfGenerator.generate(
        contract: c,
        debt: widget.debt,
      );
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Qarz Shartnomasi — ${widget.debt.personName}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xato: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Islomiy Shartnoma',
          style: GoogleFonts.sora(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Saqlash',
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF163A5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بِسۡمِ اللّٰہِ الرَّحۡمٰنِ الرَّحِیۡمِ',
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"Rahmon va Rahim Alloh nomi bilan"',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Qarz ul-Hasan (Al-Baqarah 2:282)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Contract type
          _sectionLabel('Shartnoma turi'),
          _typeDropdown(),
          const SizedBox(height: 16),

          // Parties
          _sectionLabel('Tomonlar'),
          _field('Qarz beruvchi ismi', _signerCtrl),
          const SizedBox(height: 10),
          _field('Qarz oluvchi ismi', _borrowerCtrl),
          const SizedBox(height: 16),

          // Witnesses
          _sectionLabel('Guvohlar'),
          _field('1-Guvoh ismi', _witness1Ctrl),
          const SizedBox(height: 10),
          _field('2-Guvoh ismi', _witness2Ctrl),
          const SizedBox(height: 16),

          // Optional
          _sectionLabel('Qo\'shimcha (ixtiyoriy)'),
          _field('Kafil ismi', _guarantorCtrl),
          const SizedBox(height: 10),
          _field('Garov tavsifi', _collateralCtrl),
          const SizedBox(height: 16),

          // Payment schedule
          _sectionLabel("To'lov jadvali (ixtiyoriy)"),
          TextField(
            controller: _scheduleCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Misol:\n500000|2024-03-01\n500000|2024-04-01',
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              helperText: 'Har qator: miqdor|sana (YYYY-MM-DD formatida)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          _sectionLabel('Izoh'),
          TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Qo\'shimcha shartlar...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quran ref
          _sectionLabel("Qur'on oyati"),
          DropdownButtonFormField<String>(
            value: _quranRef,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(
                  value: 'Al-Baqarah 2:282',
                  child: Text('Al-Baqarah 2:282')),
              DropdownMenuItem(
                  value: 'Al-Baqarah 2:280',
                  child: Text('Al-Baqarah 2:280')),
              DropdownMenuItem(
                  value: 'Al-Hadid 57:11',
                  child: Text('Al-Hadid 57:11')),
            ],
            onChanged: (v) => setState(() => _quranRef = v!),
          ),
          const SizedBox(height: 16),

          // Confirmation
          CheckboxListTile(
            value: _confirmed,
            onChanged: (v) => setState(() => _confirmed = v!),
            title: const Text('Har ikki tomon shartnoma shartlarini tasdiqladi'),
            subtitle: const Text(
              'Ikkala tomon ham shartlarni o\'qib, rozi bo\'lgandan keyin belgilang',
              style: TextStyle(fontSize: 12),
            ),
            activeColor: AppTheme.accent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Saqlash'),
                  onPressed: _save,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: _generating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF Ulashish'),
                  onPressed: _generating ? null : _generateAndShare,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppTheme.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _typeDropdown() {
    return DropdownButtonFormField<String>(
      value: _contractType,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: const [
        DropdownMenuItem(
            value: 'qarz_ul_hasan',
            child: Text('Qarz ul-Hasan (Foizsiz qarz)')),
        DropdownMenuItem(
            value: 'murabaha',
            child: Text('Murabaha')),
        DropdownMenuItem(
            value: 'ijara',
            child: Text('Ijara')),
      ],
      onChanged: (v) => setState(() => _contractType = v!),
    );
  }
}
