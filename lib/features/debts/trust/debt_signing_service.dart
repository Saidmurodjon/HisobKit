import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/security/identity_service.dart';
import 'trust_exceptions.dart';

class VerificationResult {
  final bool isValid;
  final bool lenderOk;
  final bool borrowerOk;
  final bool hashOk;
  final String? errorMessage;

  const VerificationResult({
    required this.isValid,
    required this.lenderOk,
    required this.borrowerOk,
    required this.hashOk,
    this.errorMessage,
  });
}

class DebtSigningService {
  final Ref _ref;
  DebtSigningService(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  String buildContentHash(Debt debt) {
    final data = {
      'id': debt.id,
      'personName': debt.personName,
      'type': debt.type,
      'amount': debt.amount,
      'currency': debt.currency,
      'dueDate': debt.dueDate?.toIso8601String() ?? '',
      'note': debt.note,
      'lenderPublicKey': debt.lenderPublicKey ?? '',
      'borrowerPublicKey': debt.borrowerPublicKey ?? '',
    };
    final sorted = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final canonical = jsonEncode(sorted);
    return sha256.convert(utf8.encode(canonical)).toString();
  }

  Future<void> signAsLender(int debtId) async {
    final debt = await _db.debtsDao.getDebtById(debtId);
    if (debt == null) throw Exception('Debt not found');

    final myPk = await IdentityService.getMyPublicKey();
    final hash = buildContentHash(debt);

    final dataToSign = {'debt_id': debtId, 'hash': hash, 'role': 'lender'};
    final sig = await IdentityService.signData(dataToSign);

    await _db.debtsDao.insertSignature(DebtSignaturesCompanion(
      debtId: Value(debtId),
      role: const Value('lender'),
      signerPublicKey: Value(myPk),
      signature: Value(sig),
    ));

    await _db.debtsDao.updateStatus(
      debtId,
      status: 'pending',
      contentHash: hash,
      lenderPublicKey: myPk,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await _db.debtsDao.insertEvent(DebtEventsCompanion(
      debtId: Value(debtId),
      eventType: const Value('lender_signed'),
      actorPublicKey: Value(myPk),
      eventData: Value(jsonEncode({'hash': hash})),
    ));
  }

  Future<void> signAsBorrower(int debtId) async {
    final debt = await _db.debtsDao.getDebtById(debtId);
    if (debt == null) throw Exception('Debt not found');

    final recalcHash = buildContentHash(debt);
    if (debt.contentHash != null && debt.contentHash != recalcHash) {
      throw TamperedDebtException(
          expected: debt.contentHash!, actual: recalcHash);
    }

    final sigs = await _db.debtsDao.getSignaturesForDebt(debtId);
    final lenderSig =
        sigs.where((s) => s.role == 'lender').firstOrNull;
    if (lenderSig == null) {
      throw InvalidSignatureException(role: 'lender', publicKey: '');
    }

    final lenderPk = debt.lenderPublicKey ?? lenderSig.signerPublicKey;
    final lenderDataToVerify = {
      'debt_id': debtId,
      'hash': recalcHash,
      'role': 'lender'
    };
    final lenderValid = await IdentityService.verifySignature(
      data: lenderDataToVerify,
      signature: lenderSig.signature,
      publicKey: lenderPk,
    );
    if (!lenderValid) {
      throw InvalidSignatureException(role: 'lender', publicKey: lenderPk);
    }

    final myPk = await IdentityService.getMyPublicKey();
    final dataToSign = {
      'debt_id': debtId,
      'hash': recalcHash,
      'role': 'borrower'
    };
    final sig = await IdentityService.signData(dataToSign);

    await _db.debtsDao.insertSignature(DebtSignaturesCompanion(
      debtId: Value(debtId),
      role: const Value('borrower'),
      signerPublicKey: Value(myPk),
      signature: Value(sig),
    ));

    await _db.debtsDao.updateStatus(
      debtId,
      status: 'confirmed',
      borrowerPublicKey: myPk,
    );

    await _db.debtsDao.insertEvent(DebtEventsCompanion(
      debtId: Value(debtId),
      eventType: const Value('confirmed'),
      actorPublicKey: Value(myPk),
      eventData: Value(jsonEncode({'hash': recalcHash})),
    ));
  }

  Future<void> rejectDebt(int debtId, String reason) async {
    final myPk = await IdentityService.getMyPublicKey();
    await _db.debtsDao.updateStatus(
      debtId,
      status: 'rejected',
      rejectionReason: reason,
    );
    await _db.debtsDao.insertEvent(DebtEventsCompanion(
      debtId: Value(debtId),
      eventType: const Value('rejected'),
      actorPublicKey: Value(myPk),
      eventData: Value(jsonEncode({'reason': reason})),
    ));
  }

  Future<VerificationResult> verifyBothSignatures(int debtId) async {
    try {
      final debt = await _db.debtsDao.getDebtById(debtId);
      if (debt == null) {
        return const VerificationResult(
          isValid: false,
          lenderOk: false,
          borrowerOk: false,
          hashOk: false,
          errorMessage: 'Debt not found',
        );
      }

      final sigs = await _db.debtsDao.getSignaturesForDebt(debtId);
      final hash = buildContentHash(debt);
      final hashOk = debt.contentHash == null || debt.contentHash == hash;

      bool lenderOk = false;
      bool borrowerOk = false;

      for (final s in sigs) {
        final dataToVerify = {
          'debt_id': debtId,
          'hash': hash,
          'role': s.role
        };
        final ok = await IdentityService.verifySignature(
          data: dataToVerify,
          signature: s.signature,
          publicKey: s.signerPublicKey,
        );
        if (s.role == 'lender') lenderOk = ok;
        if (s.role == 'borrower') borrowerOk = ok;
      }

      return VerificationResult(
        isValid: lenderOk && borrowerOk && hashOk,
        lenderOk: lenderOk,
        borrowerOk: borrowerOk,
        hashOk: hashOk,
      );
    } catch (e) {
      return VerificationResult(
        isValid: false,
        lenderOk: false,
        borrowerOk: false,
        hashOk: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> checkExpired() async {
    final expired = await _db.debtsDao.getPendingExpired();
    for (final d in expired) {
      await _db.debtsDao.updateStatus(d.id, status: 'expired');
      await _db.debtsDao.insertEvent(DebtEventsCompanion(
        debtId: Value(d.id),
        eventType: const Value('expired'),
        eventData:
            Value(jsonEncode({'expired_at': d.expiresAt?.toIso8601String()})),
      ));
    }
  }
}
