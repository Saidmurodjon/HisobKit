import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'currencies_dao.g.dart';

@DriftAccessor(tables: [Currencies])
class CurrenciesDao extends DatabaseAccessor<AppDatabase>
    with _$CurrenciesDaoMixin {
  CurrenciesDao(super.db);

  Stream<List<Currency>> watchAllCurrencies() =>
      (select(currencies)..orderBy([(c) => OrderingTerm.asc(c.code)])).watch();

  Future<List<Currency>> getAllCurrencies() =>
      (select(currencies)..orderBy([(c) => OrderingTerm.asc(c.code)])).get();

  Future<Currency?> getCurrencyByCode(String code) =>
      (select(currencies)..where((c) => c.code.equals(code))).getSingleOrNull();

  Future<void> upsertCurrency(CurrenciesCompanion currency) =>
      into(currencies).insertOnConflictUpdate(currency);

  Future<void> updateExchangeRate(String code, double rate) =>
      (update(currencies)..where((c) => c.code.equals(code))).write(
        CurrenciesCompanion(
          exchangeRate: Value(rate),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // Convert amount from one currency to another using stored rates
  Future<double> convert(double amount, String from, String to) async {
    if (from == to) return amount;
    final fromCurrency = await getCurrencyByCode(from);
    final toCurrency = await getCurrencyByCode(to);
    if (fromCurrency == null || toCurrency == null) return amount;
    // Convert to UZS base then to target
    final inBase = amount * fromCurrency.exchangeRate;
    return inBase / toCurrency.exchangeRate;
  }
}
