import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _keyName = 'hisobkit_db_key';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Returns the encryption key, generating and storing it on first call.
  static Future<String> getDatabaseKey() async {
    String? key = await _storage.read(key: _keyName);
    if (key == null || key.isEmpty) {
      key = _generateKey(32);
      await _storage.write(key: _keyName, value: key);
    }
    return key;
  }

  static String _generateKey(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)])
        .join();
  }

  /// Wipes the stored key — used only when user clears all data.
  static Future<void> deleteKey() async {
    await _storage.delete(key: _keyName);
  }
}
