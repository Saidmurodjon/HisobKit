import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class TokenService {
  static const _accessKey = 'hk_access_token';
  static const _refreshKey = 'hk_refresh_token';
  static const _deviceKey = 'hk_device_id';
  static const _userKey = 'hk_user_data';

  final FlutterSecureStorage _storage;

  TokenService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  Future<String> getOrCreateDeviceId() async {
    final existing = await _storage.read(key: _deviceKey);
    if (existing != null) return existing;
    // Simple UUID v4 generation without external package
    final bytes = List<int>.generate(16, (_) {
      return DateTime.now().microsecondsSinceEpoch & 0xFF;
    });
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;
    String hex(int b) => b.toRadixString(16).padLeft(2, '0');
    final id =
        '${bytes.sublist(0, 4).map(hex).join()}-${bytes.sublist(4, 6).map(hex).join()}-${bytes.sublist(6, 8).map(hex).join()}-${bytes.sublist(8, 10).map(hex).join()}-${bytes.sublist(10).map(hex).join()}';
    await _storage.write(key: _deviceKey, value: id);
    return id;
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> saveUser(UserModel user) =>
      _storage.write(key: _userKey, value: user.toJsonString());

  Future<UserModel?> getUser() async {
    final data = await _storage.read(key: _userKey);
    if (data == null) return null;
    try {
      return UserModel.fromJsonString(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() => _storage.deleteAll();

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = jsonDecode(
        utf8.decode(
          base64Url.decode(base64Url.normalize(parts[1])),
        ),
      ) as Map<String, dynamic>;
      final exp = payload['exp'] as int;
      return DateTime.now().millisecondsSinceEpoch / 1000 >= exp - 60;
    } catch (_) {
      return true;
    }
  }
}
