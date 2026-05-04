import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

final activeBudgetsProvider = StreamProvider<List<Budget>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.budgetsDao.watchActiveBudgets();
});

final allBudgetsProvider = StreamProvider<List<Budget>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.budgetsDao.watchAllBudgets();
});

// How much has been spent for a budget's category in its date range
final budgetSpentProvider =
    FutureProvider.family<double, (int, DateTime, DateTime)>((ref, args) async {
  final db = ref.watch(databaseProvider);
  final byCategory = await db.transactionsDao
      .getExpensesByCategoryForRange(args.$2, args.$3);
  return byCategory[args.$1] ?? 0.0;
});
