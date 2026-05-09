import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'house_dao.g.dart';

@DriftAccessor(tables: [
  HouseGroups, HouseMembers, HouseExpenses,
  HouseExpenseSplits, HouseSettlements, ShoppingItems
])
class HouseDao extends DatabaseAccessor<AppDatabase> with _$HouseDaoMixin {
  HouseDao(super.db);

  // Groups
  Stream<List<HouseGroup>> watchAllGroups() => select(houseGroups).watch();
  Future<int> insertGroup(HouseGroupsCompanion c) => into(houseGroups).insert(c);
  Future<bool> updateGroup(HouseGroupsCompanion c) => update(houseGroups).replace(c);
  Future<int> deleteGroup(int id) =>
      (delete(houseGroups)..where((t) => t.id.equals(id))).go();

  // Members
  Stream<List<HouseMember>> watchMembersByGroup(int groupId) =>
      (select(houseMembers)..where((t) => t.groupId.equals(groupId))).watch();
  Future<int> insertMember(HouseMembersCompanion c) => into(houseMembers).insert(c);
  Future<bool> updateMember(HouseMembersCompanion c) => update(houseMembers).replace(c);
  Future<int> deleteMember(int id) =>
      (delete(houseMembers)..where((t) => t.id.equals(id))).go();
  Future<List<HouseMember>> getMembersByGroup(int groupId) =>
      (select(houseMembers)..where((t) => t.groupId.equals(groupId))).get();

  // Expenses
  Stream<List<HouseExpense>> watchExpensesByGroup(int groupId) =>
      (select(houseExpenses)
            ..where((t) => t.groupId.equals(groupId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();
  Future<int> insertExpense(HouseExpensesCompanion c) => into(houseExpenses).insert(c);
  Future<bool> updateExpense(HouseExpensesCompanion c) => update(houseExpenses).replace(c);
  Future<int> deleteExpense(int id) =>
      (delete(houseExpenses)..where((t) => t.id.equals(id))).go();
  Future<List<HouseExpense>> getExpensesByGroup(int groupId) =>
      (select(houseExpenses)..where((t) => t.groupId.equals(groupId))).get();

  // Splits
  Future<int> insertSplit(HouseExpenseSplitsCompanion c) =>
      into(houseExpenseSplits).insert(c);
  Future<void> deleteSplitsByExpense(int expenseId) =>
      (delete(houseExpenseSplits)..where((t) => t.expenseId.equals(expenseId))).go();
  Future<List<HouseExpenseSplit>> getSplitsByExpense(int expenseId) =>
      (select(houseExpenseSplits)..where((t) => t.expenseId.equals(expenseId))).get();
  Future<List<HouseExpenseSplit>> getSplitsByGroup(int groupId) async {
    final expenses = await getExpensesByGroup(groupId);
    final expenseIds = expenses.map((e) => e.id).toList();
    if (expenseIds.isEmpty) return [];
    return (select(houseExpenseSplits)
          ..where((t) => t.expenseId.isIn(expenseIds)))
        .get();
  }

  // Settlements
  Stream<List<HouseSettlement>> watchSettlementsByGroup(int groupId) =>
      (select(houseSettlements)..where((t) => t.groupId.equals(groupId))).watch();
  Future<int> insertSettlement(HouseSettlementsCompanion c) =>
      into(houseSettlements).insert(c);

  // Shopping
  Stream<List<ShoppingItem>> watchShoppingByGroup(int groupId) =>
      (select(shoppingItems)..where((t) => t.groupId.equals(groupId))).watch();
  Future<int> insertShoppingItem(ShoppingItemsCompanion c) =>
      into(shoppingItems).insert(c);
  Future<bool> updateShoppingItem(ShoppingItemsCompanion c) =>
      update(shoppingItems).replace(c);
  Future<int> deleteShoppingItem(int id) =>
      (delete(shoppingItems)..where((t) => t.id.equals(id))).go();
}
