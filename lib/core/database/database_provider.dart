import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import '../security/encryption_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized before use');
});

Future<AppDatabase> initDatabase() async {
  final key = await EncryptionService.getDatabaseKey();
  final executor = openDatabaseWithEncryption(key);
  return AppDatabase(executor);
}
