import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/security/identity_service.dart';
import 'debt_signing_service.dart';
import 'debt_sync_service.dart';

final identityServiceProvider =
    Provider<IdentityService>((_) => IdentityService());

final myPublicKeyProvider =
    FutureProvider<String>((_) => IdentityService.getMyPublicKey());

final debtSigningServiceProvider = Provider<DebtSigningService>(
    (ref) => DebtSigningService(ref));

final debtSyncServiceProvider =
    Provider<DebtSyncService>((ref) => DebtSyncService(ref));

final pendingDebtsProvider = StreamProvider<List<Debt>>((ref) {
  return ref.watch(databaseProvider).debtsDao.watchByStatus('pending');
});

final confirmedDebtsProvider = StreamProvider<List<Debt>>((ref) {
  return ref.watch(databaseProvider).debtsDao.watchByStatus('confirmed');
});

final debtSignaturesProvider =
    FutureProvider.family<List<DebtSignature>, int>((ref, debtId) =>
        ref.watch(databaseProvider).debtsDao.getSignaturesForDebt(debtId));

final debtEventsProvider =
    FutureProvider.family<List<DebtEvent>, int>((ref, debtId) =>
        ref.watch(databaseProvider).debtsDao.getEventsForDebt(debtId));

final knownContactsProvider = StreamProvider<List<KnownContact>>(
    (ref) => ref.watch(databaseProvider).debtsDao.watchContacts());

final signatureVerificationProvider =
    FutureProvider.family<VerificationResult, int>((ref, debtId) =>
        ref.watch(debtSigningServiceProvider).verifyBothSignatures(debtId));
