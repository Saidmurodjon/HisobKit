import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';

/// Professional formal legal debt agreement screen.
class DebtContractScreen extends ConsumerWidget {
  final Debt debt;
  const DebtContractScreen({super.key, required this.debt});

  String _contractHash() {
    final existing = debt.contentHash;
    if (existing != null && existing.isNotEmpty) return existing;
    final raw = '${debt.id}|${debt.personName}|${debt.amount}|${debt.currency}';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  String _qrData() {
    final map = {
      'app': 'HisobKit',
      'contract_id': debt.id,
      'amount': debt.amount,
      'currency': debt.currency,
      'person': debt.personName,
      'due': debt.dueDate?.toIso8601String(),
      'hash': debt.contentHash ?? 'pending',
      'verified': debt.status == 'confirmed',
    };
    return jsonEncode(map);
  }

  String _formatAmount() {
    return CurrencyFormatter.format(debt.amount, debt.currency);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Belgilanmagan';
    return DateFormatter.format(dt);
  }

  String _createdAt() {
    return DateFormatter.format(debt.createdAt);
  }

  String _lenderName() =>
      debt.type == 'lent' ? 'Siz' : debt.personName;

  String _borrowerName() =>
      debt.type == 'lent' ? debt.personName : 'Siz';

  bool get _lenderSigned => true; // creator always signed
  bool get _borrowerSigned => debt.status == 'confirmed';

  String _signStatus(bool signed) =>
      signed ? '✓ Imzolangan' : '⏳ Kutilmoqda';

  void _share(BuildContext context) {
    final hash = _contractHash();
    final text = '''
QARZ SHARTNOMASI
O\'zbekiston Respublikasi Fuqarolik kodeksi 732-735-moddalariga muvofiq

Shartnoma ID: #${debt.id}
Qarz beruvchi: ${_lenderName()}
Qarz oluvchi: ${_borrowerName()}
Qarz miqdori: ${_formatAmount()}
Qaytarish muddati: ${_formatDate(debt.dueDate)}
Sana: ${_createdAt()}

Shartlar:
1. Qarz oluvchi yuqorida ko\'rsatilgan miqdorni belgilangan muddatda to\'liq qaytarishga majburdir.
2. Kechiktirish holatida tomonlar o\'zaro kelishuv asosida muammo hal qilinadi.
3. Ushbu shartnoma O\'zbekiston Respublikasi qonunchiligiga muvofiq tuzilgan va yuridik kuchga ega.

Raqamli imzolar:
Qarz beruvchi: ${_signStatus(_lenderSigned)}
Qarz oluvchi:  ${_signStatus(_borrowerSigned)}

Shartnoma xeshi: ${hash.substring(0, 16)}
    '''.trim();

    Share.share(text, subject: 'Qarz Shartnomasi — ${debt.personName}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hash = _contractHash();
    final shortHash = hash.length >= 16 ? hash.substring(0, 16) : hash;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qarz Shartnomasi'),
        backgroundColor: const Color(0xFF1A2332),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Ulashish',
            onPressed: () => _share(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dark header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A2332), Color(0xFF243447)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppTheme.primary.withOpacity(0.5)),
                        ),
                        child: Text(
                          'YURIDIK HUJJAT',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '#${debt.id}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'QARZ SHARTNOMASI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "O'zbekiston Respublikasi Fuqarolik kodeksi\n732-735-moddalariga muvofiq",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Contract body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parties
                  _SectionTitle(title: 'TOMONLAR'),
                  _ContractRow(
                      label: 'Qarz beruvchi', value: _lenderName()),
                  _ContractRow(
                      label: 'Qarz oluvchi', value: _borrowerName()),
                  const SizedBox(height: 20),

                  // Debt details
                  _SectionTitle(title: 'QARZ TAFSILOTLARI'),
                  _ContractRow(
                      label: 'Qarz miqdori', value: _formatAmount()),
                  _ContractRow(
                      label: 'Qaytarish muddati',
                      value: _formatDate(debt.dueDate)),
                  _ContractRow(
                      label: 'Shartnoma sanasi', value: _createdAt()),
                  const SizedBox(height: 20),

                  // Terms
                  _SectionTitle(title: 'SHARTLAR'),
                  _TermItem(
                    index: 1,
                    text:
                        "Qarz oluvchi yuqorida ko'rsatilgan miqdorni belgilangan muddatda to'liq qaytarishga majburdir.",
                  ),
                  _TermItem(
                    index: 2,
                    text:
                        "Kechiktirish holatida tomonlar o'zaro kelishuv asosida muammo hal qilinadi.",
                  ),
                  _TermItem(
                    index: 3,
                    text:
                        "Ushbu shartnoma O'zbekiston Respublikasi qonunchiligiga muvofiq tuzilgan va yuridik kuchga ega.",
                  ),
                  const SizedBox(height: 20),

                  // Digital signatures
                  _SectionTitle(title: 'RAQAMLI IMZOLAR'),
                  _SignatureRow(
                    role: 'Qarz beruvchi',
                    name: _lenderName(),
                    signed: _lenderSigned,
                  ),
                  const SizedBox(height: 8),
                  _SignatureRow(
                    role: 'Qarz oluvchi',
                    name: _borrowerName(),
                    signed: _borrowerSigned,
                  ),
                  const SizedBox(height: 24),

                  // QR code
                  _SectionTitle(title: 'TEKSHIRISH QR KODI'),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: _qrData(),
                        version: QrVersions.auto,
                        size: 200,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF1A2332),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Shartnoma xeshi: $shortHash',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Share button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _share(context),
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Ulashish'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _ContractRow extends StatelessWidget {
  final String label;
  final String value;
  const _ContractRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final int index;
  final String text;
  const _TermItem({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 10, top: 1),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _SignatureRow extends StatelessWidget {
  final String role;
  final String name;
  final bool signed;
  const _SignatureRow(
      {required this.role, required this.name, required this.signed});

  @override
  Widget build(BuildContext context) {
    final color =
        signed ? const Color(0xFF27AE60) : Colors.orange.shade700;
    final icon = signed ? Icons.verified : Icons.hourglass_empty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role,
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(
            signed ? 'Imzolangan' : 'Kutilmoqda',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

// Keep old name as alias so any missed references don't break
typedef IslamicContractScreen = DebtContractScreen;
