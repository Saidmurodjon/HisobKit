import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _keyName = 'hisobkit_db_key';
  static const _timeout = Duration(seconds: 5);

  // Standard Android Keystore — reliable on all devices including Honor/EMUI.
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: false),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Legacy storage used in versions ≤ 1.4.3 — only for one-time migration.
  static const _legacyStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Returns the database encryption key, generating one on first launch.
  /// Migrates from legacy EncryptedSharedPreferences storage if needed.
  static Future<String> getDatabaseKey() async {
    // 1. Try new storage (fast path for existing users after v1.4.4+)
    try {
      final key =
          await _storage.read(key: _keyName).timeout(_timeout);
      if (key != null && key.isNotEmpty) return key;
    } catch (_) {}

    // 2. Try legacy storage and migrate to new storage
    try {
      final legacyKey = await _legacyStorage
          .read(key: _keyName)
          .timeout(const Duration(seconds: 3));
      if (legacyKey != null && legacyKey.isNotEmpty) {
        // Migrate: write to new storage, delete from legacy
        try {
          await _storage
              .write(key: _keyName, value: legacyKey)
              .timeout(_timeout);
          await _legacyStorage
              .delete(key: _keyName)
              .timeout(const Duration(seconds: 3));
        } catch (_) {}
        return legacyKey;
      }
    } catch (_) {}

    // 3. First launch (or migration impossible) — generate new key
    final newKey = _generateKey(32);
    try {
      await _storage
          .write(key: _keyName, value: newKey)
          .timeout(_timeout);
    } catch (_) {}
    return newKey;
  }

  static String _generateKey(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)])
        .join();
  }

  static Future<void> deleteKey() async {
    try {
      await _storage.delete(key: _keyName).timeout(_timeout);
      await _legacyStorage
          .delete(key: _keyName)
          .timeout(const Duration(seconds: 3));
    } catch (_) {}
  }
}
