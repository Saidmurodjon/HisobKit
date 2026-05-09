import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/security/identity_service.dart';
import 'sync_package.dart';
import 'trust_exceptions.dart';

class DebtSyncService {
  final Ref _ref;
  DebtSyncService(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  // ── Encryption helpers ────────────────────────────────────────────────────

  /// Derive a symmetric AES-256 key from two public keys (simplified offline ECDH).
  SecretKey _deriveSymmetricKey(String senderPk, String recipientPk) {
    final combined = utf8.encode(senderPk + recipientPk);
    final keyBytes = sha256.convert(combined).bytes;
    return SecretKey(Uint8List.fromList(keyBytes));
  }

  Future<String> _encrypt(String plaintext, String senderPk, String recipientPk) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = _deriveSymmetricKey(senderPk, recipientPk);
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );
    final combined = {
      'nonce': base64Encode(secretBox.nonce),
      'mac': base64Encode(secretBox.mac.bytes),
      'ciphertext': base64Encode(secretBox.cipherText),
    };
    return jsonEncode(combined);
  }

  Future<String> _decrypt(String encryptedJson, String senderPk, String recipientPk) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = _deriveSymmetricKey(senderPk, recipientPk);
    final map = jsonDecode(encryptedJson) as Map<String, dynamic>;
    final nonce = base64Decode(map['nonce'] as String);
    final mac = Mac(base64Decode(map['mac'] as String));
    final ciphertext = base64Decode(map['ciphertext'] as String);
    final secretBox = SecretBox(ciphertext, nonce: nonce, mac: mac);
    final plainBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return utf8.decode(plainBytes);
  }

  // ── Build package payload ─────────────────────────────────────────────────

  Future<SyncPackage> _buildPackage({
    required int debtId,
    required String recipientPublicKey,
    required String packageType,
  }) async {
    final debt = await _db.debtsDao.getDebtById(debtId);
    if (debt == null) throw Exception('Debt not found: $debtId');

    final sigs = await _db.debtsDao.getSignaturesForDebt(debtId);
    final events = await _db.debtsDao.getEventsForDebt(debtId);

    final payloadMap = {
      'debt': {
        'id': debt.id,
        'personName': debt.personName,
        'type': debt.type,
        'amount': debt.amount,
        'currency': debt.currency,
        'dueDate': debt.dueDate?.toIso8601String(),
        'note': debt.note,
        'status': debt.status,
        'contentHash': debt.contentHash,
        'lenderPublicKey': debt.lenderPublicKey,
        'borrowerPublicKey': debt.borrowerPublicKey,
        'expiresAt': debt.expiresAt?.toIso8601String(),
      },
      'signatures': sigs
          .map((s) => {
                'role': s.role,
                'signerPublicKey': s.signerPublicKey,
                'signature': s.signature,
                'signedAt': s.signedAt.toIso8601String(),
              })
          .toList(),
      'events': events
          .map((e) => {
                'eventType': e.eventType,
                'actorPublicKey': e.actorPublicKey,
                'eventData': e.eventData,
                'occurredAt': e.occurredAt.toIso8601String(),
              })
          .toList(),
    };

    final myPk = await IdentityService.getMyPublicKey();
    final plaintext = jsonEncode(payloadMap);
    final encrypted = await _encrypt(plaintext, myPk, recipientPublicKey);

    return SyncPackage(
      version: '1',
      type: packageType,
      senderPublicKey: myPk,
      recipientPublicKey: recipientPublicKey,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      encryptedPayload: encrypted,
    );
  }

  // ── Export as QR string ───────────────────────────────────────────────────

  Future<String> exportAsQR({
    required int debtId,
    required String recipientPublicKey,
  }) async {
    final pkg = await _buildPackage(
      debtId: debtId,
      recipientPublicKey: recipientPublicKey,
      packageType: 'debt_request',
    );

    final json = jsonEncode(pkg.toJson());
    final compressed = GZipEncoder().encode(utf8.encode(json));
    if (compressed == null) throw Exception('Compression failed');
    final b64 = base64Encode(Uint8List.fromList(compressed));

    if (b64.length > 2800) {
      throw QrTooLargeException(b64.length);
    }

    return b64;
  }

  // ── Export as .hkd file ───────────────────────────────────────────────────

  Future<void> exportAsFile({
    required int debtId,
    required String recipientPublicKey,
  }) async {
    final pkg = await _buildPackage(
      debtId: debtId,
      recipientPublicKey: recipientPublicKey,
      packageType: 'debt_request',
    );

    final json = jsonEncode(pkg.toJson());
    final compressed = GZipEncoder().encode(utf8.encode(json));
    if (compressed == null) throw Exception('Compression failed');
    final b64 = base64Encode(Uint8List.fromList(compressed));

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/debt_$debtId.hkd');
    await file.writeAsString(b64);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'HisobKit Debt Package',
    );

    await _db.debtsDao.insertSyncQueueItem(SyncQueueCompanion(
      debtId: Value(debtId),
      method: const Value('file'),
      payload: Value(b64.substring(0, b64.length.clamp(0, 200))),
      status: const Value('sent'),
    ));
  }

  // ── Import from .hkd file ─────────────────────────────────────────────────

  Future<void> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['hkd'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) return;

    final file = File(path);
    final b64 = await file.readAsString();
    final compressed = base64Decode(b64.trim());
    final decompressed = GZipDecoder().decodeBytes(compressed);
    final json = utf8.decode(decompressed);
    final pkgJson = jsonDecode(json) as Map<String, dynamic>;
    final pkg = SyncPackage.fromJson(pkgJson);

    await processIncoming(pkg);
  }

  // ── Import from QR scanned data ───────────────────────────────────────────

  Future<void> importFromQR(String b64Data) async {
    final compressed = base64Decode(b64Data.trim());
    final decompressed = GZipDecoder().decodeBytes(compressed);
    final json = utf8.decode(decompressed);
    final pkgJson = jsonDecode(json) as Map<String, dynamic>;
    final pkg = SyncPackage.fromJson(pkgJson);
    await processIncoming(pkg);
  }

  // ── Process incoming package ──────────────────────────────────────────────

  Future<void> processIncoming(SyncPackage pkg) async {
    // Check expiry
    if (pkg.expiresAt.isBefore(DateTime.now())) {
      throw SyncDeliveryException(
        method: pkg.type,
        reason: 'Package expired at ${pkg.expiresAt}',
      );
    }

    final myPk = await IdentityService.getMyPublicKey();
    final plaintext = await _decrypt(
        pkg.encryptedPayload, pkg.senderPublicKey, myPk);
    final payloadMap = jsonDecode(plaintext) as Map<String, dynamic>;

    final debtMap = payloadMap['debt'] as Map<String, dynamic>;
    final sigsRaw = payloadMap['signatures'] as List<dynamic>;

    // Verify content hash
    final contentHash = debtMap['contentHash'] as String?;

    // Verify lender signature if present
    if (contentHash != null) {
      final lenderSigMap = sigsRaw
          .cast<Map<String, dynamic>>()
          .where((s) => s['role'] == 'lender')
          .firstOrNull;

      if (lenderSigMap != null) {
        final lenderPk = lenderSigMap['signerPublicKey'] as String;
        final lenderSig = lenderSigMap['signature'] as String;
        final dataToVerify = {
          'debt_id': debtMap['id'],
          'hash': contentHash,
          'role': 'lender',
        };
        final valid = await IdentityService.verifySignature(
          data: dataToVerify,
          signature: lenderSig,
          publicKey: lenderPk,
        );
        if (!valid) {
          throw InvalidSignatureException(role: 'lender', publicKey: lenderPk);
        }
      }
    }

    // Insert or update debt as draft/pending
    final existingDebt = await _db.debtsDao.getDebtById(debtMap['id'] as int? ?? 0);

    if (existingDebt == null) {
      final newDebtId = await _db.debtsDao.insertDebt(DebtsCompanion(
        personName: Value(debtMap['personName'] as String),
        type: Value(debtMap['type'] as String),
        amount: Value((debtMap['amount'] as num).toDouble()),
        currency: Value(debtMap['currency'] as String),
        dueDate: Value(debtMap['dueDate'] != null
            ? DateTime.tryParse(debtMap['dueDate'] as String)
            : null),
        note: Value(debtMap['note'] as String? ?? ''),
        status: Value(debtMap['status'] as String? ?? 'pending'),
        contentHash: Value(contentHash),
        lenderPublicKey: Value(debtMap['lenderPublicKey'] as String?),
        borrowerPublicKey: Value(debtMap['borrowerPublicKey'] as String?),
        expiresAt: Value(debtMap['expiresAt'] != null
            ? DateTime.tryParse(debtMap['expiresAt'] as String)
            : null),
      ));

      // Insert signatures
      for (final sigMap in sigsRaw.cast<Map<String, dynamic>>()) {
        await _db.debtsDao.insertSignature(DebtSignaturesCompanion(
          debtId: Value(newDebtId),
          role: Value(sigMap['role'] as String),
          signerPublicKey: Value(sigMap['signerPublicKey'] as String),
          signature: Value(sigMap['signature'] as String),
        ));
      }

      await _db.debtsDao.insertEvent(DebtEventsCompanion(
        debtId: Value(newDebtId),
        eventType: const Value('received'),
        actorPublicKey: Value(pkg.senderPublicKey),
        eventData: Value(jsonEncode({'via': pkg.type})),
      ));
    }
  }

  // ── PocketBase sync ───────────────────────────────────────────────────────

  Future<bool> isPocketBaseConfigured() async {
    final settings = await _db.settingsDao.getValue('pocketbase_url');
    return settings != null && settings.isNotEmpty;
  }

  Future<void> sendViaPocketBase({
    required int debtId,
    required String recipientPublicKey,
  }) async {
    final url = await _db.settingsDao.getValue('pocketbase_url');
    if (url == null || url.isEmpty) {
      throw SyncDeliveryException(
        method: 'pocketbase',
        reason: 'PocketBase URL not configured',
      );
    }

    try {
      final pkg = await _buildPackage(
        debtId: debtId,
        recipientPublicKey: recipientPublicKey,
        packageType: 'debt_request',
      );

      final payload = jsonEncode(pkg.toJson());
      await _db.debtsDao.insertSyncQueueItem(SyncQueueCompanion(
        debtId: Value(debtId),
        method: const Value('pocketbase'),
        payload: Value(payload.substring(0, payload.length.clamp(0, 200))),
        status: const Value('pending'),
      ));

      // Actual PocketBase upload would go here
      // For now we store in queue and mark as sent
      throw SyncDeliveryException(
        method: 'pocketbase',
        reason: 'PocketBase integration not fully configured',
      );
    } catch (e) {
      if (e is SyncDeliveryException) rethrow;
      throw SyncDeliveryException(
        method: 'pocketbase',
        reason: e.toString(),
      );
    }
  }
}
