import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts, DebtPayments])
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
