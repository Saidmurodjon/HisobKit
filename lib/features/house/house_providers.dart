import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/app_database.dart';

// Groups
final allHouseGroupsProvider = StreamProvider<List<HouseGroup>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.houseDao.watchAllGroups();
});

final activeGroupProvider = StateProvider<int?>((ref) => null);

// Members for active group
final houseMembersProvider = StreamProvider.family<List<HouseMember>, int>(
  (ref, groupId) {
    final db = ref.watch(databaseProvider);
    return db.houseDao.watchMembersByGroup(groupId);
  },
);

// Expenses for active group
final houseExpensesProvider = StreamProvider.family<List<HouseExpense>, int>(
  (ref, groupId) {
    final db = ref.watch(databaseProvider);
    return db.houseDao.watchExpensesByGroup(groupId);
  },
);

// Shopping items for active group
final shoppingItemsProvider = StreamProvider.family<List<ShoppingItem>, int>(
  (ref, groupId) {
    final db = ref.watch(databaseProvider);
    return db.houseDao.watchShoppingByGroup(groupId);
  },
);

// Settlement calculator
class MemberBalance {
  final HouseMember member;
  double balance; // positive = should receive, negative = should pay
  MemberBalance({required this.member, required this.balance});
}

class SettlementTransfer {
  final HouseMember from;
  final HouseMember to;
  final double amount;
  SettlementTransfer({required this.from, required this.to, required this.amount});
}

// Minimal transfers greedy algorithm
List<SettlementTransfer> calculateMinimalTransfers(List<MemberBalance> balances) {
  final creditors = balances.where((b) => b.balance > 0.01).toList()
    ..sort((a, b) => b.balance.compareTo(a.balance));
  final debtors = balances.where((b) => b.balance < -0.01).toList()
    ..sort((a, b) => a.balance.compareTo(b.balance));

  final transfers = <SettlementTransfer>[];

  int ci = 0, di = 0;
  while (ci < creditors.length && di < debtors.length) {
    final creditor = creditors[ci];
    final debtor = debtors[di];
    final transfer = creditor.balance < -debtor.balance
        ? creditor.balance
        : -debtor.balance;

    transfers.add(SettlementTransfer(
        from: debtor.member, to: creditor.member, amount: transfer));

    creditor.balance -= transfer;
    debtor.balance += transfer;

    if (creditor.balance < 0.01) ci++;
    if (debtor.balance > -0.01) di++;
  }

  return transfers;
}

final settlementProvider = FutureProvider.family<List<SettlementTransfer>, int>(
  (ref, groupId) async {
    final db = ref.read(databaseProvider);
    final members = await db.houseDao.getMembersByGroup(groupId);
    final expenses = await db.houseDao.getExpensesByGroup(groupId);
    final allSplits = await db.houseDao.getSplitsByGroup(groupId);

    // Calculate balance for each member
    final balanceMap = <int, double>{};
    for (final m in members) {
      balanceMap[m.id] = 0.0;
    }

    for (final expense in expenses.where((e) => !e.isSettled)) {
      // Payer gets credit
      balanceMap[expense.paidByMemberId] =
          (balanceMap[expense.paidByMemberId] ?? 0) + expense.amount;
      // Each participant owes their share
      final splits = allSplits.where((s) => s.expenseId == expense.id);
      for (final split in splits) {
        balanceMap[split.memberId] =
            (balanceMap[split.memberId] ?? 0) - split.shareAmount;
      }
    }

    final memberBalances = members
        .map((m) => MemberBalance(member: m, balance: balanceMap[m.id] ?? 0))
        .toList();

    return calculateMinimalTransfers(memberBalances);
  },
);
