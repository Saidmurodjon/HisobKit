import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static const _pinKey = 'hisobkit_pin_hash';

  // encryptedSharedPreferences: false → standard Android Keystore (more
  // reliable on Honor / EMUI devices where EncryptedSharedPreferences hangs).
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: false),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Timeout for every storage operation — prevents infinite hangs on
  // devices with broken KeyStore implementations.
  static const _timeout = Duration(seconds: 5);

  static String _hashPin(String pin) {
    final bytes = utf8.encode(pin + 'hisobkit_salt_2024');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> setPin(String pin) async {
    try {
      await _storage
          .write(key: _pinKey, value: _hashPin(pin))
          .timeout(_timeout);
    } catch (_) {
      // If write fails, silently ignore — user will be asked to set PIN again
    }
  }

  static Future<bool> verifyPin(String pin) async {
    try {
      final stored =
          await _storage.read(key: _pinKey).timeout(_timeout);
      if (stored == null || stored.isEmpty) return false;
      return stored == _hashPin(pin);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> hasPin() async {
    try {
      final stored =
          await _storage.read(key: _pinKey).timeout(_timeout);
      return stored != null && stored.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<void> clearPin() async {
    try {
      await _storage.delete(key: _pinKey).timeout(_timeout);
    } catch (_) {}
  }
}
