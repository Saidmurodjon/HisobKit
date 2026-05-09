import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/database/app_database.dart';

/// Generates a professional Islamic contract (Qarz ul-Hasan) PDF.
class ContractPdfGenerator {
  static const _primaryColor = PdfColor.fromInt(0xFF0A2540);
  static const _accentColor = PdfColor.fromInt(0xFF00C896);
  static const _lightGrey = PdfColor.fromInt(0xFFF5F6FA);
  static const _textGrey = PdfColor.fromInt(0xFF6B7280);

  static Future<File> generate({
    required IslamicContract contract,
    required Debt debt,
  }) async {
    final pdf = pw.Document();

    // Load font (fallback to built-in if custom unavailable)
    pw.Font? ttf;
    try {
      final data =
          await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
      ttf = pw.Font.ttf(data.buffer.asByteData());
    } catch (_) {
      // Font not available — PDF will use built-in Helvetica
    }

    final baseStyle = pw.TextStyle(font: ttf, fontSize: 11);
    final boldStyle =
        pw.TextStyle(font: ttf, fontSize: 11, fontWeight: pw.FontWeight.bold);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: _primaryColor,
    );

    final isLent = debt.type == 'lent';
    final lenderName = isLent ? contract.signerName : contract.borrowerName;
    final borrowerName = isLent ? contract.borrowerName : contract.signerName;
    final dateStr = DateFormat('dd.MM.yyyy').format(contract.createdAt);
    final amountStr =
        '${debt.amount.toStringAsFixed(2)} ${debt.currency}';
    final dueDateStr = debt.dueDate != null
        ? DateFormat('dd.MM.yyyy').format(debt.dueDate!)
        : '—';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (_) => _buildHeader(titleStyle, contract, dateStr),
        footer: (ctx) => _buildFooter(baseStyle, ctx),
        build: (context) => [
          pw.SizedBox(height: 24),

          // Bismillah
          pw.Center(
            child: pw.Text(
              'بِسۡمِ اللّٰہِ الرَّحۡمٰنِ الرَّحِیۡمِ',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 16,
                color: _primaryColor,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              '"Rahmon va Rahim Alloh nomi bilan"',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
                color: _textGrey,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Quran reference box
          _buildQuranBox(contract, baseStyle, ttf),
          pw.SizedBox(height: 20),

          // Parties
          _buildSection('SHARTNOMA TOMONLARI', titleStyle: boldStyle, accentColor: _accentColor),
          pw.SizedBox(height: 8),
          _buildInfoTable([
            ['Qarz beruvchi (Lender)', lenderName],
            ['Qarz oluvchi (Borrower)', borrowerName],
            if (contract.witnessOne.isNotEmpty) ['1-guvoh (Witness I)', contract.witnessOne],
            if (contract.witnessTwo.isNotEmpty) ['2-guvoh (Witness II)', contract.witnessTwo],
            if (contract.guarantorName != null && contract.guarantorName!.isNotEmpty)
              ['Kafil (Guarantor)', contract.guarantorName!],
          ], baseStyle: baseStyle, boldStyle: boldStyle),
          pw.SizedBox(height: 20),

          // Loan details
          _buildSection('QARZ SHARTLARI', titleStyle: boldStyle, accentColor: _accentColor),
          pw.SizedBox(height: 8),
          _buildInfoTable([
            ['Shartnoma turi', _contractTypeLabel(contract.contractType)],
            ['Qarz miqdori (Amount)', amountStr],
            ['Shartnoma sanasi (Date)', dateStr],
            ['Qaytarish muddati (Due)', dueDateStr],
            if (contract.collateralDesc != null && contract.collateralDesc!.isNotEmpty)
              ['Garov (Collateral)', contract.collateralDesc!],
          ], baseStyle: baseStyle, boldStyle: boldStyle),
          pw.SizedBox(height: 20),

          // Payment schedule if exists
          if (contract.paymentScheduleJson != null &&
              contract.paymentScheduleJson!.isNotEmpty)
            ..._buildPaymentSchedule(
                contract.paymentScheduleJson!, baseStyle, boldStyle),

          // Notes
          if (contract.contractNote.isNotEmpty) ...[
            _buildSection('IZOHLAR / NOTES', titleStyle: boldStyle, accentColor: _accentColor),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGrey,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(contract.contractNote, style: baseStyle),
            ),
            pw.SizedBox(height: 20),
          ],

          // Islamic principles
          _buildIslamicPrinciples(baseStyle, ttf),
          pw.SizedBox(height: 32),

          // Signatures
          _buildSignatureSection(
              lenderName, borrowerName,
              contract.witnessOne, contract.witnessTwo,
              boldStyle, baseStyle),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final fileName =
        'islamic_contract_${debt.personName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
      pw.TextStyle titleStyle, IslamicContract contract, String dateStr) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: _accentColor, width: 2),
        ),
      ),
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('QARZ SHARTNOMASI', style: titleStyle),
              pw.Text(
                _contractTypeLabel(contract.contractType),
                style: pw.TextStyle(
                  fontSize: 12,
                  color: _textGrey,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('HisobKit',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: _accentColor,
                  )),
              pw.Text('Sana: $dateStr',
                  style: pw.TextStyle(fontSize: 10, color: _textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.TextStyle style, pw.Context ctx) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _lightGrey, width: 1)),
      ),
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('HisobKit — Shaxsiy Moliya Ilovasi',
              style: pw.TextStyle(fontSize: 9, color: _textGrey)),
          pw.Text('Sahifa ${ctx.pageNumber} / ${ctx.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: _textGrey)),
        ],
      ),
    );
  }

  static pw.Widget _buildQuranBox(
      IslamicContract contract, pw.TextStyle style, pw.Font? ttf) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _accentColor, width: 1.5),
        borderRadius: pw.BorderRadius.circular(8),
        color: const PdfColor.fromInt(0xFFE6FBF5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            '"Ey iymon keltirganlar! Muayyan muddatga qarz berganingizda uni yozing."',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 11,
              fontStyle: pw.FontStyle.italic,
              color: _primaryColor,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '— ${contract.quranVerseRef}',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 10,
              color: _textGrey,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSection(String title,
      {required pw.TextStyle titleStyle,
      required PdfColor accentColor}) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 18,
          color: accentColor,
        ),
        pw.SizedBox(width: 8),
        pw.Text(title, style: titleStyle),
      ],
    );
  }

  static pw.Widget _buildInfoTable(
    List<List<String>> rows, {
    required pw.TextStyle baseStyle,
    required pw.TextStyle boldStyle,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: _lightGrey, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(160),
        1: const pw.FlexColumnWidth(),
      },
      children: rows.map((row) {
        return pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[0], style: boldStyle),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[1], style: baseStyle),
            ),
          ],
        );
      }).toList(),
    );
  }

  static List<pw.Widget> _buildPaymentSchedule(
      String scheduleJson, pw.TextStyle base, pw.TextStyle bold) {
    // scheduleJson: simple list of "amount|date" strings separated by \n
    final lines = scheduleJson.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.isEmpty) return [];

    return [
      _buildSection("TO'LOV JADVALI / PAYMENT SCHEDULE",
          titleStyle: bold, accentColor: _accentColor),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(color: _lightGrey, width: 0.5),
        columnWidths: {
          0: const pw.FixedColumnWidth(40),
          1: const pw.FlexColumnWidth(),
          2: const pw.FlexColumnWidth(),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: _primaryColor),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('#', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Miqdor', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Sana', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10))),
            ],
          ),
          ...lines.asMap().entries.map((e) {
            final parts = e.value.split('|');
            return pw.TableRow(
              decoration: pw.BoxDecoration(
                color: e.key.isEven ? PdfColors.white : _lightGrey,
              ),
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('${e.key + 1}', style: base)),
                pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(parts.isNotEmpty ? parts[0] : '', style: base)),
                pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(parts.length > 1 ? parts[1] : '', style: base)),
              ],
            );
          }),
        ],
      ),
      pw.SizedBox(height: 20),
    ];
  }

  static pw.Widget _buildIslamicPrinciples(
      pw.TextStyle style, pw.Font? ttf) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _lightGrey,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Islomiy qarz tamoyillari:',
              style: pw.TextStyle(
                  font: ttf,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: _primaryColor)),
          pw.SizedBox(height: 6),
          pw.Text(
            '• Qarz ul-Hasan — foizsiz qarz bo\'lib, beruvchi uchun sadaqadir.\n'
            '• Qarz oluvchi to\'liq va o\'z vaqtida qaytarishga majbur.\n'
            '• Har qanday foiz (ribo) olish haromdir (Al-Baqarah 2:275).\n'
            '• Ikki guvoh ishtiroki shartnomani islomiy huquq nuqtai nazaridan to\'liq qiladi.',
            style: pw.TextStyle(font: ttf, fontSize: 9, color: _textGrey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureSection(
      String lender, String borrower,
      String witness1, String witness2,
      pw.TextStyle bold, pw.TextStyle base) {
    return pw.Row(
      children: [
        pw.Expanded(child: _buildSignBox('Qarz beruvchi\n$lender', bold, base)),
        pw.SizedBox(width: 16),
        pw.Expanded(child: _buildSignBox('Qarz oluvchi\n$borrower', bold, base)),
        if (witness1.isNotEmpty) ...[
          pw.SizedBox(width: 16),
          pw.Expanded(child: _buildSignBox('1-Guvoh\n$witness1', bold, base)),
        ],
        if (witness2.isNotEmpty) ...[
          pw.SizedBox(width: 16),
          pw.Expanded(child: _buildSignBox('2-Guvoh\n$witness2', bold, base)),
        ],
      ],
    );
  }

  static pw.Widget _buildSignBox(
      String label, pw.TextStyle bold, pw.TextStyle base) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _lightGrey),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 9, color: _textGrey),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 32),
          pw.Container(
            height: 1,
            color: _primaryColor,
          ),
          pw.SizedBox(height: 4),
          pw.Text('Imzo / Signature',
              style: pw.TextStyle(fontSize: 8, color: _textGrey)),
        ],
      ),
    );
  }

  static String _contractTypeLabel(String type) {
    switch (type) {
      case 'qarz_ul_hasan':
        return 'Qarz ul-Hasan (Foizsiz qarz)';
      case 'murabaha':
        return 'Murabaha (Sotish orqali moliyalashtirish)';
      case 'ijara':
        return 'Ijara (Ijarachilik moliyasi)';
      default:
        return type;
    }
  }
}

