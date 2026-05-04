import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'budgets_dao.g.dart';

@DriftAccessor(tables: [Budgets, Categories])
class BudgetsDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  Stream<List<Budget>> watchAllBudgets() =>
      (select(budgets)
            ..orderBy([(b) => OrderingTerm.asc(b.startDate)]))
          .watch();

  Future<List<Budget>> getAllBudgets() =>
      (select(budgets)
            ..orderBy([(b) => OrderingTerm.asc(b.startDate)]))
          .get();

  Future<List<Budget>> getActiveBudgets() {
    final now = DateTime.now();
    return (select(budgets)
          ..where((b) =>
              b.startDate.isSmallerOrEqualValue(now) &
              b.endDate.isBiggerOrEqualValue(now)))
        .get();
  }

  Stream<List<Budget>> watchActiveBudgets() {
    final now = DateTime.now();
    return (select(budgets)
          ..where((b) =>
              b.startDate.isSmallerOrEqualValue(now) &
              b.endDate.isBiggerOrEqualValue(now)))
        .watch();
  }

  Future<Budget?> getBudgetById(int id) =>
      (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<Budget?> getBudgetForCategory(int categoryId) {
    final now = DateTime.now();
    return (select(budgets)
          ..where((b) =>
              b.categoryId.equals(categoryId) &
              b.startDate.isSmallerOrEqualValue(now) &
              b.endDate.isBiggerOrEqualValue(now)))
        .getSingleOrNull();
  }

  Future<int> insertBudget(BudgetsCompanion budget) =>
      into(budgets).insert(budget);

  Future<bool> updateBudget(BudgetsCompanion budget) =>
      update(budgets).replace(budget);

  Future<int> deleteBudget(int id) =>
      (delete(budgets)..where((b) => b.id.equals(id))).go();
}
