import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../../features/auth/services/auth_api_service.dart';

/// Barcha local ma'lumotlarni backend D1 bazasiga push/pull qiladi.
///
/// Ma'lumotlar 3 ta guruhga bo'lingan:
///   • transactions — accounts, categories, transactions, budgets
///   • debts        — debts, debtPayments
///   • house        — houseGroups, houseMembers, houseExpenses,
///                    houseExpenseSplits, houseSettlements
class SyncService {
  final AppDatabase _db;
  final AuthApiService _api;

  SyncService({required AppDatabase db, required AuthApiService api})
      : _db = db,
        _api = api;

  // ── PUSH ────────────────────────────────────────────────────────────────────

  /// Barcha local ma'lumotlarni serverga yuboradi.
  Future<DateTime> pushAll() async {
    await Future.wait([
      _pushTransactions(),
      _pushDebts(),
      _pushHouse(),
    ]);
    return DateTime.now().toUtc();
  }

  Future<void> _pushTransactions() async {
    final accs = await _db.accountsDao.getAllAccounts();
    final cats = await (_db.select(_db.categories)).get();
    final txns = await _db.transactionsDao.getAllTransactions();
    final budgets = await (_db.select(_db.budgets)).get();

    final payload = jsonEncode({
      'accounts': accs.map(_accountToMap).toList(),
      'categories': cats.map(_categoryToMap).toList(),
      'transactions': txns.map(_transactionToMap).toList(),
      'budgets': budgets.map(_budgetToMap).toList(),
    });

    await _api.syncPush('transactions', payload);
  }

  Future<void> _pushDebts() async {
    final ds = await _db.debtsDao.getAllDebts();
    final payments = <Map<String, dynamic>>[];
    for (final d in ds) {
      final ps = await _db.debtsDao.getPaymentsForDebt(d.id);
      payments.addAll(ps.map(_debtPaymentToMap));
    }

    final payload = jsonEncode({
      'debts': ds.map(_debtToMap).toList(),
      'debtPayments': payments,
    });

    await _api.syncPush('debts', payload);
  }

  Future<void> _pushHouse() async {
    final groups = await (_db.select(_db.houseGroups)).get();
    final members = await (_db.select(_db.houseMembers)).get();
    final expenses = await (_db.select(_db.houseExpenses)).get();
    final splits = await (_db.select(_db.houseExpenseSplits)).get();
    final settlements = await (_db.select(_db.houseSettlements)).get();

    final payload = jsonEncode({
      'houseGroups': groups.map(_houseGroupToMap).toList(),
      'houseMembers': members.map(_houseMemberToMap).toList(),
      'houseExpenses': expenses.map(_houseExpenseToMap).toList(),
      'houseExpenseSplits': splits.map(_houseExpenseSplitToMap).toList(),
      'houseSettlements': settlements.map(_houseSettlementToMap).toList(),
    });

    await _api.syncPush('house', payload);
  }

  // ── PULL (Restore) ───────────────────────────────────────────────────────────

  /// Serverdan ma'lumotlarni yuklaydi va local bazaga birlashtiradi.
  Future<DateTime> pullAll() async {
    final remote = await _api.syncPull();
    final data = remote['data'] as Map<String, dynamic>? ?? {};

    await Future.wait([
      if (data.containsKey('transactions'))
        _restoreTransactions(data['transactions'] as Map<String, dynamic>),
      if (data.containsKey('debts'))
        _restoreDebts(data['debts'] as Map<String, dynamic>),
      if (data.containsKey('house'))
        _restoreHouse(data['house'] as Map<String, dynamic>),
    ]);

    return DateTime.now().toUtc();
  }

  Future<void> _restoreTransactions(Map<String, dynamic> entry) async {
    final payload = jsonDecode(entry['payload'] as String) as Map<String, dynamic>;

    final rawAccs = (payload['accounts'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawCats = (payload['categories'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawTxns = (payload['transactions'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawBudgets = (payload['budgets'] as List? ?? []).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      if (rawAccs.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.accounts, rawAccs.map(_mapToAccountCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawCats.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.categories, rawCats.map(_mapToCategoryCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawTxns.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.transactions, rawTxns.map(_mapToTransactionCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawBudgets.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.budgets, rawBudgets.map(_mapToBudgetCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
    });
  }

  Future<void> _restoreDebts(Map<String, dynamic> entry) async {
    final payload = jsonDecode(entry['payload'] as String) as Map<String, dynamic>;
    final rawDebts = (payload['debts'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawPayments = (payload['debtPayments'] as List? ?? []).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      if (rawDebts.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.debts, rawDebts.map(_mapToDebtCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawPayments.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.debtPayments, rawPayments.map(_mapToDebtPaymentCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
    });
  }

  Future<void> _restoreHouse(Map<String, dynamic> entry) async {
    final payload = jsonDecode(entry['payload'] as String) as Map<String, dynamic>;
    final rawGroups = (payload['houseGroups'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawMembers = (payload['houseMembers'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawExpenses = (payload['houseExpenses'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawSplits = (payload['houseExpenseSplits'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawSettlements = (payload['houseSettlements'] as List? ?? []).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      if (rawGroups.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.houseGroups, rawGroups.map(_mapToHouseGroupCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawMembers.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.houseMembers, rawMembers.map(_mapToHouseMemberCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawExpenses.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.houseExpenses, rawExpenses.map(_mapToHouseExpenseCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawSplits.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.houseExpenseSplits, rawSplits.map(_mapToHouseExpenseSplitCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
      if (rawSettlements.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.houseSettlements, rawSettlements.map(_mapToHouseSettlementCompanion).toList(),
              mode: InsertMode.insertOrReplace);
        });
      }
    });
  }

  // ── Serializers ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _accountToMap(Account a) => {
        'id': a.id,
        'name': a.name,
        'type': a.type,
        'currency': a.currency,
        'balance': a.balance,
        'icon': a.icon,
        'color': a.color,
        'createdAt': a.createdAt.toIso8601String(),
      };

  Map<String, dynamic> _categoryToMap(Category c) => {
        'id': c.id,
        'nameUz': c.nameUz,
        'nameRu': c.nameRu,
        'nameEn': c.nameEn,
        'type': c.type,
        'icon': c.icon,
        'color': c.color,
        'isDefault': c.isDefault,
        'parentId': c.parentId,
      };

  Map<String, dynamic> _transactionToMap(Transaction t) => {
        'id': t.id,
        'accountId': t.accountId,
        'categoryId': t.categoryId,
        'toAccountId': t.toAccountId,
        'type': t.type,
        'amount': t.amount,
        'currency': t.currency,
        'note': t.note,
        'date': t.date.toIso8601String(),
        'createdAt': t.createdAt.toIso8601String(),
        'isRecurring': t.isRecurring,
        'recurrenceRule': t.recurrenceRule,
      };

  Map<String, dynamic> _budgetToMap(Budget b) => {
        'id': b.id,
        'categoryId': b.categoryId,
        'amount': b.amount,
        'currency': b.currency,
        'period': b.period,
        'startDate': b.startDate.toIso8601String(),
        'endDate': b.endDate.toIso8601String(),
        'alertAtPercent': b.alertAtPercent,
      };

  Map<String, dynamic> _debtToMap(Debt d) => {
        'id': d.id,
        'personName': d.personName,
        'type': d.type,
        'amount': d.amount,
        'currency': d.currency,
        'dueDate': d.dueDate?.toIso8601String(),
        'note': d.note,
        'isPaid': d.isPaid,
        'createdAt': d.createdAt.toIso8601String(),
        'status': d.status,
        'contentHash': d.contentHash,
        'lenderPublicKey': d.lenderPublicKey,
        'borrowerPublicKey': d.borrowerPublicKey,
        'expiresAt': d.expiresAt?.toIso8601String(),
        'rejectionReason': d.rejectionReason,
      };

  Map<String, dynamic> _debtPaymentToMap(DebtPayment p) => {
        'id': p.id,
        'debtId': p.debtId,
        'amount': p.amount,
        'date': p.date.toIso8601String(),
        'note': p.note,
      };

  Map<String, dynamic> _houseGroupToMap(HouseGroup g) => {
        'id': g.id,
        'name': g.name,
        'color': g.color,
        'createdAt': g.createdAt.toIso8601String(),
      };

  Map<String, dynamic> _houseMemberToMap(HouseMember m) => {
        'id': m.id,
        'groupId': m.groupId,
        'name': m.name,
        'color': m.color,
        'isActive': m.isActive,
      };

  Map<String, dynamic> _houseExpenseToMap(HouseExpense e) => {
        'id': e.id,
        'groupId': e.groupId,
        'paidByMemberId': e.paidByMemberId,
        'title': e.title,
        'amount': e.amount,
        'currency': e.currency,
        'date': e.date.toIso8601String(),
        'note': e.note,
        'isSettled': e.isSettled,
      };

  Map<String, dynamic> _houseExpenseSplitToMap(HouseExpenseSplit s) => {
        'id': s.id,
        'expenseId': s.expenseId,
        'memberId': s.memberId,
        'shareAmount': s.shareAmount,
      };

  Map<String, dynamic> _houseSettlementToMap(HouseSettlement s) => {
        'id': s.id,
        'groupId': s.groupId,
        'fromMemberId': s.fromMemberId,
        'toMemberId': s.toMemberId,
        'amount': s.amount,
        'settledAt': s.settledAt.toIso8601String(),
        'note': s.note,
      };

  // ── Deserializers ────────────────────────────────────────────────────────────

  AccountsCompanion _mapToAccountCompanion(Map<String, dynamic> m) =>
      AccountsCompanion(
        id: Value(m['id'] as int),
        name: Value(m['name'] as String),
        type: Value(m['type'] as String),
        currency: Value(m['currency'] as String),
        balance: Value((m['balance'] as num).toDouble()),
        icon: Value(m['icon'] as String),
        color: Value(m['color'] as String),
        createdAt: Value(DateTime.parse(m['createdAt'] as String)),
      );

  CategoriesCompanion _mapToCategoryCompanion(Map<String, dynamic> m) =>
      CategoriesCompanion(
        id: Value(m['id'] as int),
        nameUz: Value(m['nameUz'] as String),
        nameRu: Value(m['nameRu'] as String),
        nameEn: Value(m['nameEn'] as String),
        type: Value(m['type'] as String),
        icon: Value(m['icon'] as String),
        color: Value(m['color'] as String),
        isDefault: Value(m['isDefault'] as bool),
        parentId: m['parentId'] != null
            ? Value(m['parentId'] as int)
            : const Value(null),
      );

  TransactionsCompanion _mapToTransactionCompanion(Map<String, dynamic> m) =>
      TransactionsCompanion(
        id: Value(m['id'] as int),
        accountId: Value(m['accountId'] as int),
        categoryId: m['categoryId'] != null
            ? Value(m['categoryId'] as int)
            : const Value(null),
        toAccountId: m['toAccountId'] != null
            ? Value(m['toAccountId'] as int)
            : const Value(null),
        type: Value(m['type'] as String),
        amount: Value((m['amount'] as num).toDouble()),
        currency: Value(m['currency'] as String),
        note: Value(m['note'] as String? ?? ''),
        date: Value(DateTime.parse(m['date'] as String)),
        createdAt: Value(DateTime.parse(m['createdAt'] as String)),
        isRecurring: Value(m['isRecurring'] as bool? ?? false),
        recurrenceRule: m['recurrenceRule'] != null
            ? Value(m['recurrenceRule'] as String)
            : const Value(null),
      );

  BudgetsCompanion _mapToBudgetCompanion(Map<String, dynamic> m) =>
      BudgetsCompanion(
        id: Value(m['id'] as int),
        categoryId: Value(m['categoryId'] as int),
        amount: Value((m['amount'] as num).toDouble()),
        currency: Value(m['currency'] as String),
        period: Value(m['period'] as String),
        startDate: Value(DateTime.parse(m['startDate'] as String)),
        endDate: Value(DateTime.parse(m['endDate'] as String)),
        alertAtPercent: Value(m['alertAtPercent'] as int),
      );

  DebtsCompanion _mapToDebtCompanion(Map<String, dynamic> m) =>
      DebtsCompanion(
        id: Value(m['id'] as int),
        personName: Value(m['personName'] as String),
        type: Value(m['type'] as String),
        amount: Value((m['amount'] as num).toDouble()),
        currency: Value(m['currency'] as String),
        dueDate: m['dueDate'] != null
            ? Value(DateTime.parse(m['dueDate'] as String))
            : const Value(null),
        note: Value(m['note'] as String? ?? ''),
        isPaid: Value(m['isPaid'] as bool? ?? false),
        createdAt: Value(DateTime.parse(m['createdAt'] as String)),
        status: Value(m['status'] as String? ?? 'draft'),
        contentHash: m['contentHash'] != null
            ? Value(m['contentHash'] as String)
            : const Value(null),
        lenderPublicKey: m['lenderPublicKey'] != null
            ? Value(m['lenderPublicKey'] as String)
            : const Value(null),
        borrowerPublicKey: m['borrowerPublicKey'] != null
            ? Value(m['borrowerPublicKey'] as String)
            : const Value(null),
        expiresAt: m['expiresAt'] != null
            ? Value(DateTime.parse(m['expiresAt'] as String))
            : const Value(null),
        rejectionReason: m['rejectionReason'] != null
            ? Value(m['rejectionReason'] as String)
            : const Value(null),
      );

  DebtPaymentsCompanion _mapToDebtPaymentCompanion(Map<String, dynamic> m) =>
      DebtPaymentsCompanion(
        id: Value(m['id'] as int),
        debtId: Value(m['debtId'] as int),
        amount: Value((m['amount'] as num).toDouble()),
        date: Value(DateTime.parse(m['date'] as String)),
        note: Value(m['note'] as String? ?? ''),
      );

  HouseGroupsCompanion _mapToHouseGroupCompanion(Map<String, dynamic> m) =>
      HouseGroupsCompanion(
        id: Value(m['id'] as int),
        name: Value(m['name'] as String),
        color: Value(m['color'] as String? ?? '#0A2540'),
        createdAt: Value(DateTime.parse(m['createdAt'] as String)),
      );

  HouseMembersCompanion _mapToHouseMemberCompanion(Map<String, dynamic> m) =>
      HouseMembersCompanion(
        id: Value(m['id'] as int),
        groupId: Value(m['groupId'] as int),
        name: Value(m['name'] as String),
        color: Value(m['color'] as String? ?? '#00C896'),
        isActive: Value(m['isActive'] as bool? ?? true),
      );

  HouseExpensesCompanion _mapToHouseExpenseCompanion(Map<String, dynamic> m) =>
      HouseExpensesCompanion(
        id: Value(m['id'] as int),
        groupId: Value(m['groupId'] as int),
        paidByMemberId: Value(m['paidByMemberId'] as int),
        title: Value(m['title'] as String),
        amount: Value((m['amount'] as num).toDouble()),
        currency: Value(m['currency'] as String),
        date: Value(DateTime.parse(m['date'] as String)),
        note: Value(m['note'] as String? ?? ''),
        isSettled: Value(m['isSettled'] as bool? ?? false),
      );

  HouseExpenseSplitsCompanion _mapToHouseExpenseSplitCompanion(
          Map<String, dynamic> m) =>
      HouseExpenseSplitsCompanion(
        id: Value(m['id'] as int),
        expenseId: Value(m['expenseId'] as int),
        memberId: Value(m['memberId'] as int),
        shareAmount: Value((m['shareAmount'] as num).toDouble()),
      );

  HouseSettlementsCompanion _mapToHouseSettlementCompanion(
          Map<String, dynamic> m) =>
      HouseSettlementsCompanion(
        id: Value(m['id'] as int),
        groupId: Value(m['groupId'] as int),
        fromMemberId: Value(m['fromMemberId'] as int),
        toMemberId: Value(m['toMemberId'] as int),
        amount: Value((m['amount'] as num).toDouble()),
        settledAt: Value(DateTime.parse(m['settledAt'] as String)),
        note: Value(m['note'] as String? ?? ''),
      );
}
