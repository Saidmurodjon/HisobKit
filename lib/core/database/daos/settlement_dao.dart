import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'settlement_dao.g.dart';

// ── Balans modeli ─────────────────────────────────────────────────────────────
class MemberBalance {
  final int memberId;
  final String name;
  final String color;
  final double paid;       // kassa sifatida to'lagan
  final double consumed;   // iste'mol qilgan ulush
  double get balance => paid - consumed; // musbat = oladi, manfiy = beradi

  const MemberBalance({
    required this.memberId,
    required this.name,
    required this.color,
    required this.paid,
    required this.consumed,
  });
}

// ── Minimal o'tkazma modeli ───────────────────────────────────────────────────
class TransferResult {
  final int fromMemberId;
  final String fromName;
  final int toMemberId;
  final String toName;
  final double amount;

  const TransferResult({
    required this.fromMemberId,
    required this.fromName,
    required this.toMemberId,
    required this.toName,
    required this.amount,
  });
}

@DriftAccessor(tables: [
  SettlementPeriods,
  PeriodMembers,
  PeriodExpenses,
  PeriodExpenseSplits,
  PeriodConfirmations,
  PeriodTransfers,
])
class SettlementDao extends DatabaseAccessor<AppDatabase>
    with _$SettlementDaoMixin {
  SettlementDao(super.db);

  // ── Davrlar ────────────────────────────────────────────────────────────────

  Future<List<SettlementPeriod>> getPeriodsForGroup(int groupId) =>
      (select(settlementPeriods)
            ..where((t) => t.groupId.equals(groupId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Stream<List<SettlementPeriod>> watchPeriodsForGroup(int groupId) =>
      (select(settlementPeriods)
            ..where((t) => t.groupId.equals(groupId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<SettlementPeriod?> getPeriodById(int id) =>
      (select(settlementPeriods)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertPeriod(SettlementPeriodsCompanion c) =>
      into(settlementPeriods).insert(c);

  Future<bool> updatePeriod(SettlementPeriodsCompanion c) =>
      update(settlementPeriods).replace(c);

  Future<void> updatePeriodStatus(int id, String status) =>
      (update(settlementPeriods)..where((t) => t.id.equals(id)))
          .write(SettlementPeriodsCompanion(status: Value(status)));

  Future<int> deletePeriod(int id) =>
      (delete(settlementPeriods)..where((t) => t.id.equals(id))).go();

  // ── A'zolar ────────────────────────────────────────────────────────────────

  Future<List<PeriodMember>> getMembersForPeriod(int periodId) =>
      (select(periodMembers)..where((t) => t.periodId.equals(periodId))).get();

  Stream<List<PeriodMember>> watchMembersForPeriod(int periodId) =>
      (select(periodMembers)..where((t) => t.periodId.equals(periodId)))
          .watch();

  Future<int> insertMember(PeriodMembersCompanion c) =>
      into(periodMembers).insert(c);

  Future<int> deleteMember(int id) =>
      (delete(periodMembers)..where((t) => t.id.equals(id))).go();

  // ── Xarajatlar ─────────────────────────────────────────────────────────────

  Future<List<PeriodExpense>> getExpensesForPeriod(int periodId) =>
      (select(periodExpenses)
            ..where((t) => t.periodId.equals(periodId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<PeriodExpense>> watchExpensesForPeriod(int periodId) =>
      (select(periodExpenses)
            ..where((t) => t.periodId.equals(periodId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<int> insertExpense(PeriodExpensesCompanion c) =>
      into(periodExpenses).insert(c);

  Future<int> deleteExpense(int id) =>
      (delete(periodExpenses)..where((t) => t.id.equals(id))).go();

  // ── Bo'linmalar ────────────────────────────────────────────────────────────

  Future<List<PeriodExpenseSplit>> getSplitsForExpense(int expenseId) =>
      (select(periodExpenseSplits)
            ..where((t) => t.expenseId.equals(expenseId)))
          .get();

  Future<List<PeriodExpenseSplit>> getSplitsForPeriod(int periodId) async {
    final expenses = await getExpensesForPeriod(periodId);
    final ids = expenses.map((e) => e.id).toList();
    if (ids.isEmpty) return [];
    return (select(periodExpenseSplits)
          ..where((t) => t.expenseId.isIn(ids)))
        .get();
  }

  Future<void> insertSplits(List<PeriodExpenseSplitsCompanion> splits) =>
      batch((b) => b.insertAll(periodExpenseSplits, splits));

  Future<void> deleteSplitsForExpense(int expenseId) =>
      (delete(periodExpenseSplits)
            ..where((t) => t.expenseId.equals(expenseId)))
          .go();

  // ── Balans hisoblash ───────────────────────────────────────────────────────

  Future<List<MemberBalance>> computeBalances(int periodId) async {
    final members = await getMembersForPeriod(periodId);
    final expenses = await getExpensesForPeriod(periodId);
    final splits = await getSplitsForPeriod(periodId);

    final paid = <int, double>{};
    final consumed = <int, double>{};
    for (final m in members) {
      paid[m.id] = 0;
      consumed[m.id] = 0;
    }

    for (final e in expenses) {
      paid[e.paidByMemberId] = (paid[e.paidByMemberId] ?? 0) + e.amount;
    }
    for (final s in splits) {
      consumed[s.memberId] = (consumed[s.memberId] ?? 0) + s.shareAmount;
    }

    return members
        .map((m) => MemberBalance(
              memberId: m.id,
              name: m.name,
              color: m.color,
              paid: paid[m.id] ?? 0,
              consumed: consumed[m.id] ?? 0,
            ))
        .toList();
  }

  /// Greedy minimal o'tkazmalar algoritmi
  static List<TransferResult> calcMinimalTransfers(
      List<MemberBalance> balances) {
    final creditors = balances
        .where((b) => b.balance > 0.5)
        .map((b) => _Bal(b.memberId, b.name, b.balance))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final debtors = balances
        .where((b) => b.balance < -0.5)
        .map((b) => _Bal(b.memberId, b.name, b.balance.abs()))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final transfers = <TransferResult>[];

    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      final cred = creditors.first;
      final debt = debtors.first;
      final amt = cred.amount < debt.amount ? cred.amount : debt.amount;

      transfers.add(TransferResult(
        fromMemberId: debt.id,
        fromName: debt.name,
        toMemberId: cred.id,
        toName: cred.name,
        amount: amt,
      ));

      cred.amount -= amt;
      debt.amount -= amt;
      if (cred.amount < 0.5) creditors.removeAt(0);
      if (debt.amount < 0.5) debtors.removeAt(0);
    }

    return transfers;
  }

  // ── Tasdiqlar ──────────────────────────────────────────────────────────────

  Future<List<PeriodConfirmation>> getConfirmationsForPeriod(int periodId) =>
      (select(periodConfirmations)
            ..where((t) => t.periodId.equals(periodId)))
          .get();

  Future<void> initConfirmations(int periodId, List<int> memberIds) async {
    await (delete(periodConfirmations)
          ..where((t) => t.periodId.equals(periodId)))
        .go();
    await batch((b) {
      b.insertAll(
        periodConfirmations,
        memberIds
            .map((mid) => PeriodConfirmationsCompanion.insert(
                  periodId: periodId,
                  memberId: mid,
                ))
            .toList(),
      );
    });
  }

  Future<void> updateConfirmation(
    int periodId,
    int memberId,
    String status, {
    String? disputeReason,
  }) =>
      (update(periodConfirmations)
            ..where((t) =>
                t.periodId.equals(periodId) & t.memberId.equals(memberId)))
          .write(PeriodConfirmationsCompanion(
            status: Value(status),
            disputeReason: Value(disputeReason),
            respondedAt: Value(DateTime.now()),
          ));

  // ── O'tkazmalar ────────────────────────────────────────────────────────────

  Future<List<PeriodTransfer>> getTransfersForPeriod(int periodId) =>
      (select(periodTransfers)
            ..where((t) => t.periodId.equals(periodId)))
          .get();

  Future<void> saveTransfers(
      int periodId, List<TransferResult> transfers) async {
    await (delete(periodTransfers)..where((t) => t.periodId.equals(periodId)))
        .go();
    if (transfers.isEmpty) return;
    await batch((b) {
      b.insertAll(
        periodTransfers,
        transfers
            .map((t) => PeriodTransfersCompanion.insert(
                  periodId: periodId,
                  fromMemberId: t.fromMemberId,
                  toMemberId: t.toMemberId,
                  amount: Value(t.amount),
                ))
            .toList(),
      );
    });
  }

  Future<void> markTransferPaid(int transferId) =>
      (update(periodTransfers)..where((t) => t.id.equals(transferId)))
          .write(const PeriodTransfersCompanion(isPaid: Value(true)));

  // ── Umumiy statistika ──────────────────────────────────────────────────────

  Future<double> getTotalForPeriod(int periodId) async {
    final expenses = await getExpensesForPeriod(periodId);
    return expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
  }
}

// ── Yordamchi sinf (algoritm uchun) ───────────────────────────────────────────
class _Bal {
  final int id;
  final String name;
  double amount;
  _Bal(this.id, this.name, this.amount);
}
