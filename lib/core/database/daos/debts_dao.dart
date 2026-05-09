import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts, DebtPayments, DebtSignatures, DebtEvents, KnownContacts, SyncQueue])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Stream<List<Debt>> watchAllDebts() =>
      (select(debts)..orderBy([(d) => OrderingTerm.asc(d.dueDate)])).watch();

  Future<List<Debt>> getAllDebts() =>
      (select(debts)..orderBy([(d) => OrderingTerm.asc(d.dueDate)])).get();

  Future<List<Debt>> getUnpaidDebts() =>
      (select(debts)
            ..where((d) => d.isPaid.equals(false))
            ..orderBy([(d) => OrderingTerm.asc(d.dueDate)]))
          .get();

  Stream<List<Debt>> watchUnpaidDebts() =>
      (select(debts)
            ..where((d) => d.isPaid.equals(false))
            ..orderBy([(d) => OrderingTerm.asc(d.dueDate)]))
          .watch();

  Future<Debt?> getDebtById(int id) =>
      (select(debts)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<int> insertDebt(DebtsCompanion debt) => into(debts).insert(debt);

  Future<bool> updateDebt(DebtsCompanion debt) =>
      update(debts).replace(debt);

  Future<int> deleteDebt(int id) =>
      (delete(debts)..where((d) => d.id.equals(id))).go();

  Future<void> markAsPaid(int id) =>
      (update(debts)..where((d) => d.id.equals(id))).write(
        const DebtsCompanion(isPaid: Value(true)),
      );

  // Payments
  Future<List<DebtPayment>> getPaymentsForDebt(int debtId) =>
      (select(debtPayments)
            ..where((p) => p.debtId.equals(debtId))
            ..orderBy([(p) => OrderingTerm.desc(p.date)]))
          .get();

  Stream<List<DebtPayment>> watchPaymentsForDebt(int debtId) =>
      (select(debtPayments)
            ..where((p) => p.debtId.equals(debtId))
            ..orderBy([(p) => OrderingTerm.desc(p.date)]))
          .watch();

  Future<int> insertPayment(DebtPaymentsCompanion payment) =>
      into(debtPayments).insert(payment);

  Future<int> deletePayment(int id) =>
      (delete(debtPayments)..where((p) => p.id.equals(id))).go();

  Future<double> getTotalPaidForDebt(int debtId) async {
    final payments = await getPaymentsForDebt(debtId);
    return payments.fold<double>(0.0, (sum, p) => sum + p.amount);
  }

  // ── Trust system methods ───────────────────────────────────────────────────

  // Status update
  Future<void> updateStatus(
    int debtId, {
    required String status,
    String? contentHash,
    String? lenderPublicKey,
    String? borrowerPublicKey,
    String? rejectionReason,
    DateTime? expiresAt,
  }) async {
    final companion = DebtsCompanion(
      status: Value(status),
      contentHash: contentHash != null ? Value(contentHash) : const Value.absent(),
      lenderPublicKey: lenderPublicKey != null ? Value(lenderPublicKey) : const Value.absent(),
      borrowerPublicKey: borrowerPublicKey != null ? Value(borrowerPublicKey) : const Value.absent(),
      rejectionReason: rejectionReason != null ? Value(rejectionReason) : const Value.absent(),
      expiresAt: expiresAt != null ? Value(expiresAt) : const Value.absent(),
    );
    await (update(debts)..where((t) => t.id.equals(debtId))).write(companion);
  }

  Stream<List<Debt>> watchByStatus(String status) =>
      (select(debts)..where((t) => t.status.equals(status))).watch();

  Future<List<Debt>> getPendingExpired() {
    final now = DateTime.now();
    return (select(debts)
      ..where((t) =>
          t.status.equals('pending') &
          t.expiresAt.isSmallerThanValue(now)))
        .get();
  }

  Future<int> insertSignature(DebtSignaturesCompanion s) =>
      into(debtSignatures).insert(s);

  Future<List<DebtSignature>> getSignaturesForDebt(int debtId) =>
      (select(debtSignatures)..where((t) => t.debtId.equals(debtId))).get();

  Future<int> insertEvent(DebtEventsCompanion e) =>
      into(debtEvents).insert(e);

  Future<List<DebtEvent>> getEventsForDebt(int debtId) =>
      (select(debtEvents)
        ..where((t) => t.debtId.equals(debtId))
        ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .get();

  Future<int> insertContact(KnownContactsCompanion c) =>
      into(knownContacts).insert(c);

  Stream<List<KnownContact>> watchContacts() =>
      (select(knownContacts)..orderBy([(t) => OrderingTerm.asc(t.displayName)])).watch();

  Future<KnownContact?> findContactByPublicKey(String pk) =>
      (select(knownContacts)..where((t) => t.publicKey.equals(pk))).getSingleOrNull();

  Future<int> insertSyncQueueItem(SyncQueueCompanion item) =>
      into(syncQueue).insert(item);

  Future<void> updateSyncStatus(int id, String status) =>
      (update(syncQueue)..where((t) => t.id.equals(id)))
        .write(SyncQueueCompanion(status: Value(status)));

  Future<List<SyncQueueData>> getPendingSyncItems() =>
      (select(syncQueue)..where((t) => t.status.equals('pending'))).get();

  // Summary: total lent vs total borrowed (unpaid)
  Future<Map<String, double>> getDebtSummary() async {
    final unpaid = await getUnpaidDebts();
    double totalLent = 0;
    double totalBorrowed = 0;

    for (final debt in unpaid) {
      final paid = await getTotalPaidForDebt(debt.id);
      final remaining = debt.amount - paid;
      if (debt.type == 'lent') {
        totalLent += remaining;
      } else {
        totalBorrowed += remaining;
      }
    }

    return {'lent': totalLent, 'borrowed': totalBorrowed};
  }
}
