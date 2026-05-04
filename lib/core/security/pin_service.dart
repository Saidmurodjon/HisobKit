import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static const _pinKey = 'hisobkit_pin_hash';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static String _hashPin(String pin) {
    final bytes = utf8.encode(pin + 'hisobkit_salt_2024');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: _hashPin(pin));
  }

  static Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _pinKey);
    if (stored == null || stored.isEmpty) return false;
    return stored == _hashPin(pin);
  }

  static Future<bool> hasPin() async {
    final stored = await _storage.read(key: _pinKey);
    return stored != null && stored.isNotEmpty;
  }

  static Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
  }
}
