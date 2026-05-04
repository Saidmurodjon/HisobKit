import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

final allDebtsProvider = StreamProvider<List<Debt>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.debtsDao.watchAllDebts();
});

final unpaidDebtsProvider = StreamProvider<List<Debt>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.debtsDao.watchUnpaidDebts();
});

final debtPaymentsProvider =
    StreamProvider.family<List<DebtPayment>, int>((ref, debtId) {
  final db = ref.watch(databaseProvider);
  return db.debtsDao.watchPaymentsForDebt(debtId);
});

final debtSummaryProvider =
    FutureProvider<Map<String, double>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.debtsDao.getDebtSummary();
});

final totalPaidForDebtProvider =
    FutureProvider.family<double, int>((ref, debtId) {
  final db = ref.watch(databaseProvider);
  return db.debtsDao.getTotalPaidForDebt(debtId);
});
