import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IdentityService {
  static const _storage = FlutterSecureStorage();
  static const _privateKeyStorageKey = 'hisobkit_ed25519_private_key';
  static const _publicKeyStorageKey = 'hisobkit_ed25519_public_key';

  static final _algorithm = Ed25519();

  static Future<SimpleKeyPair> getOrCreateKeypair() async {
    final storedPrivate = await _storage.read(key: _privateKeyStorageKey);
    if (storedPrivate != null) {
      final privateBytes = base64Decode(storedPrivate);
      return await _algorithm.newKeyPairFromSeed(privateBytes.sublist(0, 32));
    }
    final keypair = await _algorithm.newKeyPair();
    final privateBytes = await keypair.extractPrivateKeyBytes();
    await _storage.write(
        key: _privateKeyStorageKey, value: base64Encode(privateBytes));
    final publicKey = await keypair.extractPublicKey();
    await _storage.write(
        key: _publicKeyStorageKey, value: base64Encode(publicKey.bytes));
    return keypair;
  }

  static Future<String> getMyPublicKey() async {
    final stored = await _storage.read(key: _publicKeyStorageKey);
    if (stored != null) return stored;
    final keypair = await getOrCreateKeypair();
    final publicKey = await keypair.extractPublicKey();
    return base64Encode(publicKey.bytes);
  }

  static Future<String> signData(Map<String, dynamic> data) async {
    final keypair = await getOrCreateKeypair();
    final canonical = _canonicalJson(data);
    final bytes = utf8.encode(canonical);
    final sig = await _algorithm.sign(bytes, keyPair: keypair);
    return base64Encode(sig.bytes);
  }

  static Future<bool> verifySignature({
    required Map<String, dynamic> data,
    required String signature,
    required String publicKey,
  }) async {
    try {
      final pkBytes = base64Decode(publicKey);
      final pk = SimplePublicKey(pkBytes, type: KeyPairType.ed25519);
      final sig = Signature(base64Decode(signature), publicKey: pk);
      final canonical = _canonicalJson(data);
      final bytes = utf8.encode(canonical);
      return await _algorithm.verify(bytes, signature: sig);
    } catch (_) {
      return false;
    }
  }

  static Future<String> exportPublicKeyAsQR({String name = 'HisobKit'}) async {
    final pk = await getMyPublicKey();
    return jsonEncode({'name': name, 'pk': pk});
  }

  static String _canonicalJson(Map<String, dynamic> data) {
    final sorted = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return jsonEncode(sorted);
  }
}
