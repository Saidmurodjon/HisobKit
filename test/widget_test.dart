import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisobkit/core/database/app_database.dart';
import 'package:hisobkit/core/database/database_provider.dart';
import 'package:hisobkit/core/providers/auth_provider.dart';
import 'package:hisobkit/core/providers/settings_provider.dart';
import 'package:hisobkit/core/theme/app_theme.dart';
import 'package:hisobkit/features/auth/lock_screen.dart';
import 'package:hisobkit/features/dashboard/dashboard_screen.dart';
import 'package:hisobkit/core/utils/currency_formatter.dart';
import 'package:hisobkit/core/utils/date_formatter.dart';
import 'package:go_router/go_router.dart';

// Creates an in-memory test database (no encryption, no file I/O)
AppDatabase _testDb() =>
    AppDatabase(NativeDatabase.memory());

// Minimal router for tests
GoRouter _testRouter(Widget home) => GoRouter(
      initialLocation: '/',
      routes: [GoRoute(path: '/', builder: (_, __) => home)],
    );

Widget _wrap(Widget child, AppDatabase db,
    {AuthState authState = AuthState.unlocked}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

// ── Currency formatter ────────────────────────────────────────────────────────
void main() {
  group('CurrencyFormatter', () {
    test('formats UZS with symbol after amount', () {
      final result = CurrencyFormatter.format(12500.0, 'UZS');
      expect(result, contains("so'm"));
      expect(result, contains('12,500'));
    });

    test('formats USD with dollar prefix', () {
      final result = CurrencyFormatter.format(100.0, 'USD');
      expect(result, startsWith('\$'));
    });

    test('formats zero amount', () {
      final result = CurrencyFormatter.format(0, 'UZS');
      expect(result, contains('0'));
    });

    test('compact format shows K for thousands', () {
      final result = CurrencyFormatter.formatCompact(1500.0, 'USD');
      expect(result, contains('K'));
    });

    test('compact format shows M for millions', () {
      final result = CurrencyFormatter.formatCompact(2500000.0, 'UZS');
      expect(result, contains('M'));
    });
  });

  // ── DateFormatter ───────────────────────────────────────────────────────────
  group('DateFormatter', () {
    test('relativeDate returns Today for today', () {
      final result = DateFormatter.relativeDate(DateTime.now());
      expect(result, 'Today');
    });

    test('relativeDate returns Yesterday for yesterday', () {
      final yesterday =
          DateTime.now().subtract(const Duration(days: 1));
      final result = DateFormatter.relativeDate(yesterday);
      expect(result, 'Yesterday');
    });

    test('formatShort uses dd.MM.yyyy', () {
      final d = DateTime(2024, 3, 15);
      expect(DateFormatter.formatShort(d), '15.03.2024');
    });

    test('formatMonthYear returns month and year', () {
      final d = DateTime(2024, 3, 1);
      final result = DateFormatter.formatMonthYear(d);
      expect(result, contains('2024'));
      expect(result, contains('March'));
    });
  });

  // ── Database seeding ────────────────────────────────────────────────────────
  group('Database', () {
    late AppDatabase db;

    setUp(() {
      db = _testDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('seeds default currencies', () async {
      final currencies = await db.currenciesDao.getAllCurrencies();
      expect(currencies.length, greaterThanOrEqualTo(6));
      final codes = currencies.map((c) => c.code).toList();
      expect(codes, containsAll(['UZS', 'USD', 'EUR', 'RUB']));
    });

    test('seeds default categories', () async {
      final cats = await db.categoriesDao.getAllCategories();
      expect(cats.length, greaterThan(0));
      final types = cats.map((c) => c.type).toSet();
      expect(types, containsAll(['income', 'expense']));
    });

    test('seeds default settings', () async {
      final lang = await db.settingsDao.getValue('language');
      expect(lang, isNotNull);
      final currency = await db.settingsDao.getValue('base_currency');
      expect(currency, 'UZS');
    });

    test('seeds at least one default account', () async {
      final accounts = await db.accountsDao.getAllAccounts();
      expect(accounts.length, greaterThanOrEqualTo(1));
    });

    test('can insert and retrieve a transaction', () async {
      final accounts = await db.accountsDao.getAllAccounts();
      final cats = await db.categoriesDao.getCategoriesByType('expense');
      expect(accounts, isNotEmpty);
      expect(cats, isNotEmpty);

      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accounts.first.id,
          categoryId: Value(cats.first.id),
          type: const Value('expense'),
          amount: const Value(50000),
          currency: const Value('UZS'),
          note: const Value('Test transaction'),
          date: Value(DateTime.now()),
        ),
      );

      final txs = await db.transactionsDao.getAllTransactions();
      expect(txs.length, greaterThanOrEqualTo(1));
      expect(txs.first.note, 'Test transaction');
    });

    test('income/expense totals calculate correctly', () async {
      final accounts = await db.accountsDao.getAllAccounts();
      final cats = await db.categoriesDao.getCategoriesByType('income');

      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);

      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accounts.first.id,
          categoryId: Value(cats.first.id),
          type: const Value('income'),
          amount: const Value(100000),
          currency: const Value('UZS'),
          date: Value(now),
        ),
      );

      final total = await db.transactionsDao
          .getTotalByTypeAndDateRange('income', start, end);
      expect(total, 100000);
    });

    test('can insert and retrieve a debt', () async {
      await db.debtsDao.insertDebt(
        DebtsCompanion.insert(
          personName: 'Ali',
          type: const Value('lent'),
          amount: const Value(500000),
          currency: const Value('UZS'),
          note: const Value('Lunch money'),
        ),
      );

      final debts = await db.debtsDao.getAllDebts();
      expect(debts.any((d) => d.personName == 'Ali'), isTrue);
    });

    test('debt payment reduces remaining correctly', () async {
      await db.debtsDao.insertDebt(
        DebtsCompanion.insert(
          personName: 'Bobur',
          type: const Value('lent'),
          amount: const Value(200000),
          currency: const Value('UZS'),
        ),
      );
      final debts = await db.debtsDao.getAllDebts();
      final debt = debts.first;

      await db.debtsDao.insertPayment(
        DebtPaymentsCompanion.insert(
          debtId: debt.id,
          amount: const Value(50000),
          note: const Value('Partial'),
        ),
      );

      final paid = await db.debtsDao.getTotalPaidForDebt(debt.id);
      expect(paid, 50000);
      final remaining = debt.amount - paid;
      expect(remaining, 150000);
    });

    test('can insert a budget and retrieve it', () async {
      final cats = await db.categoriesDao.getCategoriesByType('expense');
      final now = DateTime.now();

      await db.budgetsDao.insertBudget(
        BudgetsCompanion.insert(
          categoryId: cats.first.id,
          amount: const Value(1000000),
          currency: const Value('UZS'),
          period: const Value('monthly'),
          startDate: DateTime(now.year, now.month, 1),
          endDate: DateTime(now.year, now.month + 1, 0),
          alertAtPercent: const Value(80),
        ),
      );

      final active = await db.budgetsDao.getActiveBudgets();
      expect(active.length, greaterThanOrEqualTo(1));
    });

    test('settings can be read and written', () async {
      await db.settingsDao.setValue('test_key', 'test_value');
      final val = await db.settingsDao.getValue('test_key');
      expect(val, 'test_value');
    });

    test('currency conversion works correctly', () async {
      // USD rate is 12700 to UZS from seed
      final result = await db.currenciesDao.convert(1.0, 'USD', 'UZS');
      expect(result, closeTo(12700.0, 0.01));
    });
  });

  // ── Lock Screen widget ──────────────────────────────────────────────────────
  group('LockScreen widget', () {
    testWidgets('shows HisobKit label and Enter PIN text', (tester) async {
      final db = _testDb();
      addTearDown(() => db.close());

      await tester.pumpWidget(_wrap(const LockScreen(), db));
      await tester.pump();

      expect(find.text('HisobKit'), findsOneWidget);
      expect(find.text('Enter PIN'), findsOneWidget);
    });

    testWidgets('digit buttons 0-9 are rendered', (tester) async {
      final db = _testDb();
      addTearDown(() => db.close());

      await tester.pumpWidget(_wrap(const LockScreen(), db));
      await tester.pump();

      for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) {
        expect(find.text(d), findsWidgets,
            reason: 'Digit button $d not found');
      }
    });
  });
}
