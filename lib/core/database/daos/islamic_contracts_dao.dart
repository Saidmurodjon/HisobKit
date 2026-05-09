import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'islamic_contracts_dao.g.dart';

@DriftAccessor(tables: [IslamicContracts])
class IslamicContractsDao extends DatabaseAccessor<AppDatabase>
    with _$IslamicContractsDaoMixin {
  IslamicContractsDao(super.db);

  Future<int> insertContract(IslamicContractsCompanion c) =>
      into(islamicContracts).insert(c);

  Future<bool> updateContract(IslamicContractsCompanion c) =>
      update(islamicContracts).replace(c);

  Future<int> deleteContract(int id) =>
      (delete(islamicContracts)..where((t) => t.id.equals(id))).go();

  Future<IslamicContract?> getContractByDebtId(int debtId) =>
      (select(islamicContracts)..where((t) => t.debtId.equals(debtId)))
          .getSingleOrNull();

  Stream<IslamicContract?> watchContractByDebtId(int debtId) =>
      (select(islamicContracts)..where((t) => t.debtId.equals(debtId)))
          .watchSingleOrNull();
}
