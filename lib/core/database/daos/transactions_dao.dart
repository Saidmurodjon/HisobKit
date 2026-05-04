import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'transactions_dao.g.dart';

class TransactionWithCategory {
  final Transaction transaction;
  final Category? category;
  final Account account;
  final Account? toAccount;

  TransactionWithCategory({
    required this.transaction,
    this.category,
    required this.account,
    this.toAccount,
  });
}

@DriftAccessor(tables: [Transactions, Categories, Accounts])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future<List<Transaction>> getRecentTransactions({int limit = 10}) =>
      (select(transactions)
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(limit))
          .get();

  Stream<List<Transaction>> watchRecentTransactions({int limit = 10}) =>
      (select(transactions)
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(limit))
          .watch();

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end, {
    int? accountId,
    int? categoryId,
    String? type,
  }) {
    final query = select(transactions)
      ..where((t) => t.date.isBiggerOrEqualValue(start) &
          t.date.isSmallerOrEqualValue(end))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (accountId != null) {
      query.where((t) => t.accountId.equals(accountId));
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }

    return query.get();
  }

  Stream<List<Transaction>> watchTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(transactions)
            ..where((t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerOrEqualValue(end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<double> getTotalByTypeAndDateRange(
    String type,
    DateTime start,
    DateTime end,
  ) async {
    final result = await (select(transactions)
          ..where((t) =>
              t.type.equals(type) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end)))
        .get();
    return result.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<Map<int, double>> getExpensesByCategoryForRange(
    DateTime start,
    DateTime end,
  ) async {
    final result = await (select(transactions)
          ..where((t) =>
              t.type.equals('expense') &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end)))
        .get();

    final map = <int, double>{};
    for (final t in result) {
      if (t.categoryId != null) {
        map[t.categoryId!] = (map[t.categoryId!] ?? 0) + t.amount;
      }
    }
    return map;
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) =>
      into(transactions).insert(transaction);

  Future<bool> updateTransaction(TransactionsCompanion transaction) =>
      update(transactions).replace(transaction);

  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<List<Transaction>> getAllTransactions() =>
      (select(transactions)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  // Monthly summary for chart (last 12 months)
  Future<List<Map<String, dynamic>>> getMonthlySummary() async {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];

    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(month.year, month.month + 1, 1);

      final income = await getTotalByTypeAndDateRange(
          'income', month, nextMonth.subtract(const Duration(days: 1)));
      final expense = await getTotalByTypeAndDateRange(
          'expense', month, nextMonth.subtract(const Duration(days: 1)));

      result.add({
        'year': month.year,
        'month': month.month,
        'income': income,
        'expense': expense,
      });
    }

    return result;
  }
}
