import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/theme/app_theme.dart';
import 'house_providers.dart';

/// QR / JSON sync screen for sharing house group data between devices.
class HouseSyncScreen extends ConsumerStatefulWidget {
  final int groupId;
  const HouseSyncScreen({super.key, required this.groupId});

  @override
  ConsumerState<HouseSyncScreen> createState() => _HouseSyncScreenState();
}

class _HouseSyncScreenState extends ConsumerState<HouseSyncScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  String? _qrData;
  bool _loading = false;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _buildExportData();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _buildExportData() async {
    setState(() => _loading = true);
    try {
      final db = ref.read(databaseProvider);
      final members = await db.houseDao.getMembersByGroup(widget.groupId);
      final expenses = await db.houseDao.getExpensesByGroup(widget.groupId);

      final payload = {
        'v': 1,
        'gid': widget.groupId,
        't': DateTime.now().millisecondsSinceEpoch,
        'members': members.map((m) => {
          'id': m.id,
          'name': m.name,
          'color': m.color,
        }).toList(),
        'expenses': expenses.map((e) => {
          'id': e.id,
          'paidBy': e.paidByMemberId,
          'title': e.title,
          'amount': e.amount,
          'currency': e.currency,
          'date': e.date.toIso8601String(),
          'note': e.note,
          'settled': e.isSettled,
        }).toList(),
      };

      final json = jsonEncode(payload);
      setState(() {
        _qrData = json;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _shareJson() async {
    if (_qrData == null) return;
    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/house_group_${widget.groupId}_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(_qrData!);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Uy Hisobi — Sinxronizatsiya',
    );
  }

  Future<void> _importFromJson(String raw) async {
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['v'] != 1) throw 'Versiya mos kelmaydi';

      final db = ref.read(databaseProvider);
      final members = (data['members'] as List).cast<Map<String, dynamic>>();
      final expenses = (data['expenses'] as List).cast<Map<String, dynamic>>();

      // Upsert members
      for (final m in members) {
        await db.houseDao.insertMember(HouseMembersCompanion(
          groupId: Value(widget.groupId),
          name: Value(m['name'] as String),
          color: Value(m['color'] as String? ?? '#00C896'),
        ));
      }

      // Upsert expenses
      for (final e in expenses) {
        await db.houseDao.insertExpense(HouseExpensesCompanion(
          groupId: Value(widget.groupId),
          paidByMemberId: Value(e['paidBy'] as int),
          title: Value(e['title'] as String),
          amount: Value((e['amount'] as num).toDouble()),
          currency: Value(e['currency'] as String? ?? 'UZS'),
          date: Value(DateTime.parse(e['date'] as String)),
          note: Value(e['note'] as String? ?? ''),
          isSettled: Value(e['settled'] as bool? ?? false),
        ));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${members.length} a\'zo, ${expenses.length} xarajat import qilindi'),
            backgroundColor: AppTheme.accent,
          ),
        );
        setState(() => _scanning = false);
        _buildExportData(); // Refresh QR
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import xatosi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sinxronizatsiya',
          style: GoogleFonts.sora(fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code), text: 'Ulashish'),
            Tab(icon: Icon(Icons.qr_code_scanner), text: 'Qabul qilish'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _ShareTab(
            loading: _loading,
            qrData: _qrData,
            onShare: _shareJson,
          ),
          _ScanTab(
            scanning: _scanning,
            onStartScan: () => setState(() => _scanning = true),
            onStopScan: () => setState(() => _scanning = false),
            onDetected: _importFromJson,
          ),
        ],
      ),
    );
  }
}

// ── Share Tab ─────────────────────────────────────────────────────────────────
class _ShareTab extends StatelessWidget {
  final bool loading;
  final String? qrData;
  final VoidCallback onShare;

  const _ShareTab({
    required this.loading,
    required this.qrData,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final data = qrData;
    if (data == null) {
      return const Center(child: Text('Ma\'lumot yo\'q'));
    }

    // QR code can hold ~2953 bytes. If data is too large, show JSON share only.
    final tooLarge = data.length > 2800;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tooLarge
                      ? 'Ma\'lumot hajmi katta — JSON faylini ulashing.'
                      : 'QR kodni boshqa qurilmada skanerlang yoki JSON faylni ulashing.',
                  style: GoogleFonts.inter(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // QR Code
        if (!tooLarge) ...[
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: data,
                size: 220,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppTheme.primary,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${data.length} bytes',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Share JSON button
        FilledButton.icon(
          icon: const Icon(Icons.share),
          label: const Text('JSON Faylni Ulashish'),
          onPressed: onShare,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'JSON fayl orqali qurilmalar o\'rtasida ma\'lumot almashishingiz mumkin.',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Scan Tab ──────────────────────────────────────────────────────────────────
class _ScanTab extends StatefulWidget {
  final bool scanning;
  final VoidCallback onStartScan;
  final VoidCallback onStopScan;
  final Future<void> Function(String) onDetected;

  const _ScanTab({
    required this.scanning,
    required this.onStartScan,
    required this.onStopScan,
    required this.onDetected,
  });

  @override
  State<_ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<_ScanTab> {
  bool _processed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.scanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.qr_code_scanner,
                  size: 48, color: AppTheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'QR kodni skanerlash',
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Boshqa qurilmadagi QR kodni\nskanerlang yoki JSON fayl import qiling',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Kamerani Ochish'),
              onPressed: () {
                setState(() => _processed = false);
                widget.onStartScan();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    // Camera scanner view
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) async {
            if (_processed) return;
            final barcode = capture.barcodes.firstOrNull;
            if (barcode?.rawValue == null) return;
            _processed = true;
            await widget.onDetected(barcode!.rawValue!);
          },
        ),
        // Overlay frame
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.accent, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Cancel button
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: FilledButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Bekor qilish'),
              onPressed: widget.onStopScan,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
