import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// PIN hash is stored in a plain file inside the app's private directory.
/// No Keystore, no flutter_secure_storage, no SQLite — zero hang risk.
final pinServiceProvider = Provider<PinService>((_) => PinService());

class PinService {
  static const _pinFileName = '.hk_pin_hash';

  static String hashPin(String pin) {
    final bytes = utf8.encode(pin + 'hisobkit_salt_2024');
    return sha256.convert(bytes).toString();
  }

  static Future<File> _pinFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_pinFileName');
  }

  Future<void> setPin(String pin) async {
    try {
      final file = await _pinFile();
      await file.writeAsString(hashPin(pin));
    } catch (_) {}
  }

  Future<bool> verifyPin(String pin) async {
    try {
      final file = await _pinFile();
      if (!await file.exists()) return false;
      final stored = await file.readAsString();
      return stored.trim() == hashPin(pin);
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasPin() async {
    try {
      final file = await _pinFile();
      if (!await file.exists()) return false;
      final stored = await file.readAsString();
      return stored.trim().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearPin() async {
    try {
      final file = await _pinFile();
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
