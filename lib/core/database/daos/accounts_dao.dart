import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Stream<List<Account>> watchAllAccounts() =>
      (select(accounts)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<List<Account>> getAllAccounts() =>
      (select(accounts)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Future<Account?> getAccountById(int id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertAccount(AccountsCompanion account) =>
      into(accounts).insert(account);

  Future<bool> updateAccount(AccountsCompanion account) =>
      update(accounts).replace(account);

  Future<int> deleteAccount(int id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();

  Future<void> updateBalance(int id, double newBalance) =>
      (update(accounts)..where((t) => t.id.equals(id))).write(
        AccountsCompanion(balance: Value(newBalance)),
      );

  Stream<double> watchTotalBalance(String baseCurrency) {
    return watchAllAccounts().map((accs) =>
        accs.fold(0.0, (sum, acc) => sum + acc.balance));
  }
}
