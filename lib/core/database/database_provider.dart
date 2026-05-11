import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'app_database.dart';
import '../security/encryption_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized before use');
});

Future<AppDatabase> initDatabase() async {
  try {
    final key = await EncryptionService.getDatabaseKey();
    final executor = openDatabaseWithEncryption(key);
    final db = AppDatabase(executor);
    // Quick probe — if key is wrong SQLCipher throws here
    await db.settingsDao.getAllSettings();
    return db;
  } catch (e) {
    // Key mismatch or corrupted database — wipe and restart clean
    // (data loss, but better than infinite white screen)
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dir.path, 'hisobkit.db'));
      if (await dbFile.exists()) await dbFile.delete();
      // Regenerate encryption key
      await EncryptionService.deleteKey();
    } catch (_) {}

    final freshKey = await EncryptionService.getDatabaseKey();
    final executor = openDatabaseWithEncryption(freshKey);
    return AppDatabase(executor);
  }
}
