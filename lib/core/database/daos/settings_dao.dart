import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> getValue(String key) async {
    final row = await (select(appSettings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setValue(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key, value: value),
      );

  Stream<String?> watchValue(String key) =>
      (select(appSettings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<Map<String, String>> getAllSettings() async {
    final rows = await select(appSettings).get();
    return {for (final r in rows) r.key: r.value};
  }
}
