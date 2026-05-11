import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

// Accounts
final accountsStreamProvider = StreamProvider<List<Account>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.accountsDao.watchAllAccounts();
});

final accountByIdProvider = FutureProvider.family<Account?, int>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.accountsDao.getAccountById(id);
});

// Recent transactions
final recentTransactionsProvider =
    StreamProvider<List<Transaction>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.watchRecentTransactions(limit: 10);
});

// Transactions by date range (stream for real-time updates)
final transactionsByRangeProvider =
    StreamProvider.family<List<Transaction>, (DateTime, DateTime)>(
        (ref, range) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.watchTransactionsByDateRange(range.$1, range.$2);
});

// All transactions (paginated via stream for list screen)
final allTransactionsStreamProvider =
    StreamProvider<List<Transaction>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.watchRecentTransactions(limit: 500);
});

// Monthly total by type
final monthlyTotalProvider =
    FutureProvider.family<double, (String, DateTime, DateTime)>((ref, args) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao
      .getTotalByTypeAndDateRange(args.$1, args.$2, args.$3);
});

// Category by id (used in multiple features)
final categoryByIdProvider =
    FutureProvider.family<Category?, int>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.categoriesDao.getCategoryById(id);
});

// All categories stream
final allCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.categoriesDao.watchAllCategories();
});

final categoriesByTypeProvider =
    StreamProvider.family<List<Category>, String>((ref, type) {
  final db = ref.watch(databaseProvider);
  return db.categoriesDao.watchCategoriesByType(type);
});

// Monthly summary for charts
final monthlySummaryProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getMonthlySummary();
});

// Expense by category for date range
final expenseByCategoryProvider =
    FutureProvider.family<Map<int, double>, (DateTime, DateTime)>(
        (ref, range) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getExpensesByCategoryForRange(range.$1, range.$2);
});
