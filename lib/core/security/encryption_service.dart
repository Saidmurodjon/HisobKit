import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

/// DB encryption key is stored in a plain file inside the app's private
/// documents directory.  No Keystore / flutter_secure_storage involved —
/// eliminates hang issues on Honor/EMUI devices entirely.
///
/// Security: the file lives in /data/data/<package>/app_flutter/ which is
/// sandboxed (inaccessible to other apps on non-rooted devices).
class EncryptionService {
  static const _keyFileName = '.hk_db_key';

  static Future<String> getDatabaseKey() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final keyFile = File('${dir.path}/$_keyFileName');
      if (await keyFile.exists()) {
        final key = await keyFile.readAsString();
        if (key.length >= 16) return key;
      }
    } catch (_) {}

    // Generate and persist a new key
    final newKey = _generateKey(32);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final keyFile = File('${dir.path}/$_keyFileName');
      await keyFile.writeAsString(newKey);
    } catch (_) {}
    return newKey;
  }

  static Future<void> deleteKey() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final keyFile = File('${dir.path}/$_keyFileName');
      if (await keyFile.exists()) await keyFile.delete();
    } catch (_) {}
  }

  static String _generateKey(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)])
        .join();
  }
}
