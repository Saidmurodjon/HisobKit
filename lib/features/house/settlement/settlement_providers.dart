import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/settlement_dao.dart';

// ── Davrlar ro'yxati ──────────────────────────────────────────────────────────

final settlementPeriodsProvider =
    StreamProvider.family<List<SettlementPeriod>, int>((ref, groupId) {
  final db = ref.watch(databaseProvider);
  return db.settlementDao.watchPeriodsForGroup(groupId);
});

// ── A'zolar ───────────────────────────────────────────────────────────────────

final periodMembersProvider =
    FutureProvider.family<List<PeriodMember>, int>((ref, periodId) {
  final db = ref.watch(databaseProvider);
  return db.settlementDao.getMembersForPeriod(periodId);
});

// ── Xarajatlar ────────────────────────────────────────────────────────────────

final periodExpensesProvider =
    FutureProvider.family<List<PeriodExpense>, int>((ref, periodId) {
  final db = ref.watch(databaseProvider);
  return db.settlementDao.getExpensesForPeriod(periodId);
});

// ── Balanslar ─────────────────────────────────────────────────────────────────

final periodBalancesProvider =
    FutureProvider.family<List<MemberBalance>, int>((ref, periodId) async {
  final db = ref.watch(databaseProvider);
  return db.settlementDao.computeBalances(periodId);
});

// ── Minimal o'tkazmalar ───────────────────────────────────────────────────────

final periodTransfersProvider =
    FutureProvider.family<List<TransferResult>, int>((ref, periodId) async {
  final balances = await ref.watch(periodBalancesProvider(periodId).future);
  return SettlementDao.calcMinimalTransfers(balances);
});

// ── Tasdiqlar ─────────────────────────────────────────────────────────────────

final periodConfirmationsProvider =
    FutureProvider.family<List<PeriodConfirmation>, int>((ref, periodId) {
  final db = ref.watch(databaseProvider);
  return db.settlementDao.getConfirmationsForPeriod(periodId);
});

// ── Jami summa ────────────────────────────────────────────────────────────────

final periodTotalProvider =
    FutureProvider.family<double, int>((ref, periodId) {
  final db = ref.watch(databaseProvider);
  return db.settlementDao.getTotalForPeriod(periodId);
});

// ── Notifier: Davr yaratish/boshqarish ───────────────────────────────────────

class PeriodNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  PeriodNotifier(this._db) : super(const AsyncData(null));

  Future<int?> createPeriod({
    required int groupId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> memberNames,
    required List<String> memberColors,
  }) async {
    state = const AsyncLoading();
    try {
      final periodId = await _db.settlementDao.insertPeriod(
        SettlementPeriodsCompanion.insert(
          groupId: groupId,
          title: title,
          startDate: startDate,
          endDate: endDate,
        ),
      );

      for (var i = 0; i < memberNames.length; i++) {
        await _db.settlementDao.insertMember(
          PeriodMembersCompanion.insert(
            periodId: periodId,
            name: memberNames[i],
            color: Value(memberColors[i]),
          ),
        );
      }

      state = const AsyncData(null);
      return periodId;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> deletePeriod(int id) async {
    await _db.settlementDao.deletePeriod(id);
  }

  Future<void> updateStatus(int id, String status) async {
    await _db.settlementDao.updatePeriodStatus(id, status);
  }
}

final periodNotifierProvider =
    StateNotifierProvider<PeriodNotifier, AsyncValue<void>>((ref) {
  final db = ref.watch(databaseProvider);
  return PeriodNotifier(db);
});

// ── Notifier: Xarajat qo'shish ────────────────────────────────────────────────

class ExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  ExpenseNotifier(this._db) : super(const AsyncData(null));

  Future<void> addExpense({
    required int periodId,
    required int paidByMemberId,
    required String title,
    required double amount,
    required String currency,
    required DateTime date,
    required String category,
    required String note,
    required Map<int, double> splits, // memberId → shareAmount
  }) async {
    state = const AsyncLoading();
    try {
      final expId = await _db.settlementDao.insertExpense(
        PeriodExpensesCompanion.insert(
          periodId: periodId,
          paidByMemberId: paidByMemberId,
          title: title,
          amount: Value(amount),
          currency: const Value('UZS'),
          date: Value(date),
          category: Value(category),
          note: Value(note),
        ),
      );

      final splitRows = splits.entries
          .map((e) => PeriodExpenseSplitsCompanion.insert(
                expenseId: expId,
                memberId: e.key,
                shareAmount: Value(e.value),
              ))
          .toList();

      await _db.settlementDao.insertSplits(splitRows);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteExpense(int id) async {
    await _db.settlementDao.deleteExpense(id);
    await _db.settlementDao.deleteSplitsForExpense(id);
  }
}

final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<void>>((ref) {
  final db = ref.watch(databaseProvider);
  return ExpenseNotifier(db);
});
