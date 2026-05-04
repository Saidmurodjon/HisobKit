import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../core/database/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/transaction_providers.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 23, 59, 59);
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';

    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date Range',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setState(() => _startDate = d);
                          },
                          child: InputDecorator(
                            decoration:
                                const InputDecoration(labelText: 'From'),
                            child: Text(DateFormatter.formatShort(_startDate)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setState(() => _endDate = d);
                          },
                          child: InputDecorator(
                            decoration:
                                const InputDecoration(labelText: 'To'),
                            child: Text(DateFormatter.formatShort(_endDate)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isGenerating)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 12),
                  Text('Generating...'),
                ],
              ),
            )
          else ...[
            _ExportCard(
              icon: Icons.picture_as_pdf,
              title: 'Export to PDF',
              subtitle: 'Formatted report with transaction table',
              color: AppTheme.expenseColor,
              onTap: () => _exportPdf(currency),
            ),
            const SizedBox(height: 12),
            _ExportCard(
              icon: Icons.table_chart_outlined,
              title: 'Export to Excel',
              subtitle: 'Raw data spreadsheet with all fields',
              color: AppTheme.incomeColor,
              onTap: () => _exportExcel(currency),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _exportPdf(String currency) async {
    setState(() => _isGenerating = true);
    try {
      final db = ref.read(databaseProvider);
      final transactions = await db.transactionsDao
          .getTransactionsByDateRange(_startDate, _endDate);
      final categories = await db.categoriesDao.getAllCategories();
      final accounts = await db.accountsDao.getAllAccounts();

      final catMap = {for (final c in categories) c.id: c};
      final accMap = {for (final a in accounts) a.id: a};

      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('HisobKit Transaction Report',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 4),
            pw.Text(
                '${DateFormatter.formatShort(_startDate)} – ${DateFormatter.formatShort(_endDate)}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
            pw.Divider(),
          ],
        ),
        build: (ctx) {
          double totalIncome = 0;
          double totalExpense = 0;
          for (final t in transactions) {
            if (t.type == 'income') totalIncome += t.amount;
            if (t.type == 'expense') totalExpense += t.amount;
          }

          return [
            // Summary
            pw.Row(children: [
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Total Income',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                      pw.Text(CurrencyFormatter.format(totalIncome, currency),
                          style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800)),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.red50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Total Expense',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                      pw.Text(CurrencyFormatter.format(totalExpense, currency),
                          style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.red800)),
                    ],
                  ),
                ),
              ),
            ]),
            pw.SizedBox(height: 16),
            // Transaction table
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Type', 'Category', 'Account', 'Amount', 'Note'],
              data: transactions.map((t) {
                final cat = t.categoryId != null ? catMap[t.categoryId] : null;
                final acc = accMap[t.accountId];
                return [
                  DateFormatter.formatShort(t.date),
                  t.type,
                  cat?.nameEn ?? '-',
                  acc?.name ?? '-',
                  '${t.type == 'income' ? '+' : '-'}${CurrencyFormatter.format(t.amount, t.currency)}',
                  t.note.isEmpty ? '-' : t.note,
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
              oddRowDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey100),
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(2),
                5: const pw.FlexColumnWidth(2),
              },
            ),
          ];
        },
      ));

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/hisobkit_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'HisobKit Report',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _exportExcel(String currency) async {
    setState(() => _isGenerating = true);
    try {
      final db = ref.read(databaseProvider);
      final transactions = await db.transactionsDao
          .getTransactionsByDateRange(_startDate, _endDate);
      final categories = await db.categoriesDao.getAllCategories();
      final accounts = await db.accountsDao.getAllAccounts();

      final catMap = {for (final c in categories) c.id: c};
      final accMap = {for (final a in accounts) a.id: a};

      final excel = Excel.createExcel();
      final sheet = excel['Transactions'];

      // Header row
      final headers = [
        'Date', 'Type', 'Category', 'Account', 'Amount', 'Currency',
        'Note', 'Is Recurring'
      ];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(bold: true);
      }

      // Data rows
      for (var i = 0; i < transactions.length; i++) {
        final t = transactions[i];
        final cat = t.categoryId != null ? catMap[t.categoryId] : null;
        final acc = accMap[t.accountId];
        final row = i + 1;

        void setCell(int col, CellValue val) {
          sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: col, rowIndex: row)).value = val;
        }

        setCell(0, TextCellValue(DateFormatter.formatShort(t.date)));
        setCell(1, TextCellValue(t.type));
        setCell(2, TextCellValue(cat?.nameEn ?? '-'));
        setCell(3, TextCellValue(acc?.name ?? '-'));
        setCell(4, DoubleCellValue(t.amount));
        setCell(5, TextCellValue(t.currency));
        setCell(6, TextCellValue(t.note));
        setCell(7, TextCellValue(t.isRecurring ? 'Yes' : 'No'));
      }

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/hisobkit_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      final bytes = excel.encode();
      if (bytes != null) {
        await file.writeAsBytes(bytes);
        if (mounted) {
          await Share.shareXFiles(
            [XFile(file.path,
                mimeType:
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
            subject: 'HisobKit Data Export',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}

class _ExportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ExportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 28,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
