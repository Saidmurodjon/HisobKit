import 'package:drift/drift.dart';

// ── Accounts ──────────────────────────────────────────────────────────────────
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text().withDefault(const Constant('cash'))();
  TextColumn get currency => text().withDefault(const Constant('UZS'))();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get icon => text().withDefault(const Constant('account_balance_wallet'))();
  TextColumn get color => text().withDefault(const Constant('#2E7D32'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Categories ────────────────────────────────────────────────────────────────
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameUz => text().withLength(min: 1, max: 100)();
  TextColumn get nameRu => text().withLength(min: 1, max: 100)();
  TextColumn get nameEn => text().withLength(min: 1, max: 100)();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  TextColumn get icon => text().withDefault(const Constant('category'))();
  TextColumn get color => text().withDefault(const Constant('#1565C0'))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
}

// ── Transactions ──────────────────────────────────────────────────────────────
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  IntColumn get toAccountId => integer().nullable().references(Accounts, #id)();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('UZS'))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();
}

// ── Budgets ───────────────────────────────────────────────────────────────────
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('UZS'))();
  TextColumn get period => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get alertAtPercent => integer().withDefault(const Constant(80))();
}

// ── Debts ─────────────────────────────────────────────────────────────────────
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get personName => text().withLength(min: 1, max: 100)();
  TextColumn get type => text().withDefault(const Constant('lent'))();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('UZS'))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Debt Payments ─────────────────────────────────────────────────────────────
class DebtPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get debtId => integer().references(Debts, #id)();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().withDefault(const Constant(''))();
}

// ── Currencies ────────────────────────────────────────────────────────────────
class Currencies extends Table {
  TextColumn get code => text().withLength(min: 3, max: 3)();
  TextColumn get symbol => text().withLength(min: 1, max: 5)();
  RealColumn get exchangeRate => real().withDefault(const Constant(1.0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {code};
}

// ── App Settings ──────────────────────────────────────────────────────────────
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
