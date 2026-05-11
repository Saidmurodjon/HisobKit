import 'package:dio/dio.dart';
import 'token_service.dart';

class AuthApiService {
  late final Dio _dio;
  final String _baseUrl;
  final TokenService _tokenService;

  AuthApiService({required String baseUrl, required TokenService tokenService})
      : _baseUrl = baseUrl,
        _tokenService = tokenService {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefresh();
            if (refreshed) {
              final token = await _tokenService.getAccessToken();
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $token';
              try {
                final response = await _dio.fetch(opts);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _tryRefresh() async {
    try {
      final refresh = await _tokenService.getRefreshToken();
      final deviceId = await _tokenService.getOrCreateDeviceId();
      if (refresh == null) return false;

      final res = await Dio().post(
        '$_baseUrl/auth/refresh',
        data: {'refreshToken': refresh, 'deviceId': deviceId},
      );
      await _tokenService.saveTokens(
        access: res.data['accessToken'] as String,
        refresh: res.data['refreshToken'] as String,
      );
      return true;
    } catch (_) {
      await _tokenService.clearAll();
      return false;
    }
  }

  Future<Map<String, dynamic>> googleInit(String idToken) =>
      _post('/auth/google/init', {'idToken': idToken});

  Future<Map<String, dynamic>> googleLogin(String idToken,
          {String? deviceName}) =>
      _post('/auth/google/login', {
        'idToken': idToken,
        if (deviceName != null) 'deviceName': deviceName,
      });

  Future<Map<String, dynamic>> googleVerify({
    required String idToken,
    required String otp,
    String? deviceName,
  }) =>
      _post('/auth/google/verify', {
        'idToken': idToken,
        'otp': otp,
        if (deviceName != null) 'deviceName': deviceName,
      });

  Future<Map<String, dynamic>> emailSendOtp(String email) =>
      _post('/auth/email/send-otp', {'email': email});

  Future<Map<String, dynamic>> emailVerifyOtp({
    required String email,
    required String otp,
    String? displayName,
    String? deviceName,
  }) =>
      _post('/auth/email/verify-otp', {
        'email': email,
        'otp': otp,
        if (displayName != null) 'displayName': displayName,
        if (deviceName != null) 'deviceName': deviceName,
      });

  Future<Map<String, dynamic>> resendOtp(String email) =>
      _post('/auth/resend-otp', {'email': email});

  /// New unified endpoint — returns { maskedEmail, expiresIn }
  Future<Map<String, dynamic>> sendOtp(String email) =>
      _post('/auth/send-otp', {'email': email.trim().toLowerCase()});

  /// New unified endpoint — returns { accessToken, refreshToken, user, isNewUser } or { code: 'needs_profile' }
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    String? displayName,
    String? platform,
  }) =>
      _post('/auth/verify-otp', {
        'email': email.trim().toLowerCase(),
        'otp': otp,
        if (displayName != null) 'displayName': displayName,
        if (platform != null) 'platform': platform,
      });

  Future<void> logout({String? deviceId}) =>
      _post('/auth/logout', {if (deviceId != null) 'deviceId': deviceId});

  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get('/auth/me');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> data) async {
    final res = await _dio.post(path, data: data);
    return res.data as Map<String, dynamic>;
  }
}
