import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

import 'tables.dart';
import 'daos/accounts_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/budgets_dao.dart';
import 'daos/debts_dao.dart';
import 'daos/currencies_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/islamic_contracts_dao.dart';
import 'daos/house_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    Transactions,
    Budgets,
    Debts,
    DebtPayments,
    Currencies,
    AppSettings,
    IslamicContracts,
    HouseGroups,
    HouseMembers,
    HouseExpenses,
    HouseExpenseSplits,
    HouseSettlements,
    ShoppingItems,
    DebtSignatures,
    DebtEvents,
    KnownContacts,
    SyncQueue,
  ],
  daos: [
    AccountsDao,
    TransactionsDao,
    CategoriesDao,
    BudgetsDao,
    DebtsDao,
    CurrenciesDao,
    SettingsDao,
    IslamicContractsDao,
    HouseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultData();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(islamicContracts);
            await m.createTable(houseGroups);
            await m.createTable(houseMembers);
            await m.createTable(houseExpenses);
            await m.createTable(houseExpenseSplits);
            await m.createTable(houseSettlements);
            await m.createTable(shoppingItems);
          }
          if (from < 3) {
            // Add new columns to debts
            await m.addColumn(debts, debts.status);
            await m.addColumn(debts, debts.contentHash);
            await m.addColumn(debts, debts.lenderPublicKey);
            await m.addColumn(debts, debts.borrowerPublicKey);
            await m.addColumn(debts, debts.expiresAt);
            await m.addColumn(debts, debts.rejectionReason);
            // Create new tables
            await m.createTable(debtSignatures);
            await m.createTable(debtEvents);
            await m.createTable(knownContacts);
            await m.createTable(syncQueue);
          }
        },
      );

  Future<void> _seedDefaultData() async {
    // Seed currencies
    await batch((b) {
      b.insertAll(currencies, [
        CurrenciesCompanion.insert(
          code: 'UZS',
          symbol: "so'm",
          exchangeRate: const Value(1.0),
        ),
        CurrenciesCompanion.insert(
          code: 'USD',
          symbol: '\$',
          exchangeRate: const Value(12700.0),
        ),
        CurrenciesCompanion.insert(
          code: 'EUR',
          symbol: '€',
          exchangeRate: const Value(13800.0),
        ),
        CurrenciesCompanion.insert(
          code: 'RUB',
          symbol: '₽',
          exchangeRate: const Value(140.0),
        ),
        CurrenciesCompanion.insert(
          code: 'GBP',
          symbol: '£',
          exchangeRate: const Value(16100.0),
        ),
        CurrenciesCompanion.insert(
          code: 'KZT',
          symbol: '₸',
          exchangeRate: const Value(28.0),
        ),
      ]);
    });

    // Seed income categories
    final incomeCategories = [
      CategoriesCompanion.insert(
        nameUz: "Maosh",
        nameRu: "Зарплата",
        nameEn: "Salary",
        type: const Value('income'),
        icon: const Value('payments'),
        color: const Value('#2E7D32'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Biznes",
        nameRu: "Бизнес",
        nameEn: "Business",
        type: const Value('income'),
        icon: const Value('business_center'),
        color: const Value('#1565C0'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Sovg'a",
        nameRu: "Подарок",
        nameEn: "Gift",
        type: const Value('income'),
        icon: const Value('card_giftcard'),
        color: const Value('#6A1B9A'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Investitsiya",
        nameRu: "Инвестиции",
        nameEn: "Investment",
        type: const Value('income'),
        icon: const Value('trending_up'),
        color: const Value('#00838F'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Boshqa",
        nameRu: "Другое",
        nameEn: "Other",
        type: const Value('income'),
        icon: const Value('more_horiz'),
        color: const Value('#546E7A'),
        isDefault: const Value(true),
      ),
    ];

    // Seed expense categories
    final expenseCategories = [
      CategoriesCompanion.insert(
        nameUz: "Oziq-ovqat",
        nameRu: "Еда",
        nameEn: "Food",
        type: const Value('expense'),
        icon: const Value('restaurant'),
        color: const Value('#E65100'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Transport",
        nameRu: "Транспорт",
        nameEn: "Transport",
        type: const Value('expense'),
        icon: const Value('directions_car'),
        color: const Value('#1565C0'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Uy-joy",
        nameRu: "Жильё",
        nameEn: "Housing",
        type: const Value('expense'),
        icon: const Value('home'),
        color: const Value('#4E342E'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Kiyim",
        nameRu: "Одежда",
        nameEn: "Clothes",
        type: const Value('expense'),
        icon: const Value('checkroom'),
        color: const Value('#AD1457'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Sog'liq",
        nameRu: "Здоровье",
        nameEn: "Health",
        type: const Value('expense'),
        icon: const Value('favorite'),
        color: const Value('#C62828'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Ta'lim",
        nameRu: "Образование",
        nameEn: "Education",
        type: const Value('expense'),
        icon: const Value('school'),
        color: const Value('#00695C'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Ko'ngilochar",
        nameRu: "Развлечения",
        nameEn: "Entertainment",
        type: const Value('expense'),
        icon: const Value('sports_esports'),
        color: const Value('#6A1B9A'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Kommunal",
        nameRu: "Коммунальные",
        nameEn: "Utilities",
        type: const Value('expense'),
        icon: const Value('bolt'),
        color: const Value('#F57F17'),
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        nameUz: "Boshqa",
        nameRu: "Другое",
        nameEn: "Other",
        type: const Value('expense'),
        icon: const Value('more_horiz'),
        color: const Value('#546E7A'),
        isDefault: const Value(true),
      ),
    ];

    await batch((b) {
      b.insertAll(categories, incomeCategories);
      b.insertAll(categories, expenseCategories);
    });

    // Seed default settings
    await batch((b) {
      b.insertAll(appSettings, [
        AppSettingsCompanion.insert(key: 'language', value: 'uz'),
        AppSettingsCompanion.insert(key: 'base_currency', value: 'UZS'),
        AppSettingsCompanion.insert(key: 'theme', value: 'system'),
        AppSettingsCompanion.insert(key: 'biometrics_enabled', value: 'false'),
        AppSettingsCompanion.insert(key: 'auto_lock_minutes', value: '5'),
        AppSettingsCompanion.insert(key: 'onboarding_complete', value: 'false'),
        AppSettingsCompanion.insert(key: 'pin_hash', value: ''),
      ]);
    });

    // Seed a default cash account
    await into(accounts).insert(AccountsCompanion.insert(
      name: "Naqd pul",
      type: const Value('cash'),
      currency: const Value('UZS'),
      balance: const Value(0.0),
      icon: const Value('account_balance_wallet'),
      color: const Value('#2E7D32'),
    ));
  }
}

LazyDatabase openDatabaseWithEncryption(String encryptionKey) {
  return LazyDatabase(() async {
    // Override the native sqlite3 library with SQLCipher.
    // Must be done in the SAME isolate that opens the database.
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hisobkit.db'));

    // Use NativeDatabase (not createInBackground) so the open.overrideFor
    // above applies in the same isolate.
    return NativeDatabase(
      file,
      setup: (rawDb) {
        // Key must be set before any other PRAGMA
        rawDb.execute("PRAGMA key = '$encryptionKey'");
        rawDb.execute("PRAGMA cipher_compatibility = 4");
      },
    );
  });
}
