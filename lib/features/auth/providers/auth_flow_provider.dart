import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';
import '../services/google_auth_service.dart';
import '../services/token_service.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/sync_service.dart';

// ── Service providers ──────────────────────────────────────────────────────────
final tokenServiceProvider = Provider<TokenService>((ref) => TokenService());

final googleAuthServiceProvider =
    Provider<GoogleAuthService>((ref) => GoogleAuthService());

// ── Muhim: wrangler deploy dan keyin bu URL ni yangilang
// wrangler deploy → "Published to https://hisobkit-api.XXXX.workers.dev"
const String _apiBaseUrl = 'https://hisobkit-api.saidmurodjon1020.workers.dev';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(
    baseUrl: _apiBaseUrl,
    tokenService: ref.read(tokenServiceProvider),
  );
});

// ── Auth flow notifier ────────────────────────────────────────────────────────
class AuthFlowNotifier extends StateNotifier<AuthFlowState> {
  final AuthApiService _api;
  final GoogleAuthService _google;
  final TokenService _tokens;
  final Ref _ref;

  AuthFlowNotifier(this._api, this._google, this._tokens, this._ref)
      : super(const AuthInitial()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _tokens.getAccessToken();
    final user = await _tokens.getUser();
    if (token != null && user != null && !_tokens.isTokenExpired(token)) {
      state = AuthSuccess(user: user);
    }
    // Try refresh if access expired but refresh available
    else if (user != null) {
      final refresh = await _tokens.getRefreshToken();
      if (refresh != null && !_tokens.isTokenExpired(refresh)) {
        state = AuthSuccess(user: user);
      }
    }
  }

  // ── Google sign-in ──────────────────────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final idToken = await _google.signIn();
      if (idToken == null) {
        // User cancelled — go back to initial quietly
        state = const AuthInitial();
        return;
      }
      // Direct login — no OTP step
      final res = await _api.googleLogin(idToken);
      await _handleSuccess(res);
    } on GoogleAuthException catch (e) {
      dev.log('Google sign-in error: $e');
      state = AuthError(message: e.message, code: e.code);
    } on DioException catch (e) {
      dev.log('Google API error: ${e.response?.data}');
      state = AuthError(message: _extractError(e) ?? 'Google kirish xatosi');
    } catch (e) {
      dev.log('Google unexpected: $e');
      state = AuthError(message: 'Xatolik: $e');
    }
  }

  // ── Email OTP send ──────────────────────────────────────────────────────────
  Future<void> sendEmailOtp(String email) async {
    state = const AuthLoading();
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final res = await _api.sendOtp(normalizedEmail);
      state = AuthOtpSent(
        email: normalizedEmail,
        maskedEmail: res['maskedEmail'] as String? ?? _maskEmail(normalizedEmail),
        expiresIn: res['expiresIn'] as int? ?? 300,
      );
    } on DioException catch (e) {
      dev.log('sendEmailOtp error: ${e.response?.statusCode} ${e.response?.data}');
      state = AuthError(message: _extractError(e) ?? 'Email yuborishda xato');
    } catch (e) {
      dev.log('sendEmailOtp unexpected: $e');
      state = AuthError(message: 'Xatolik: $e');
    }
  }

  static String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '$name***@$domain';
    return '${name.substring(0, 2)}***@$domain';
  }

  // ── Email OTP verify ────────────────────────────────────────────────────────
  Future<void> verifyEmailOtp(String otp, {String? displayName}) async {
    final current = state;
    if (current is! AuthOtpSent && current is! AuthNeedsProfile) return;

    final email = current is AuthOtpSent
        ? current.email
        : (current as AuthNeedsProfile).email;

    state = const AuthLoading();
    try {
      final res = await _api.verifyOtp(
        email: email,
        otp: otp,
        displayName: displayName,
      );

      // Backend said: new user but no display name sent
      if (res['code'] == 'needs_profile') {
        state = AuthNeedsProfile(email: email);
        return;
      }

      await _handleSuccess(res);
    } on DioException catch (e) {
      final data = e.response?.data as Map<String, dynamic>?;
      if (data?['code'] == 'needs_profile') {
        state = AuthNeedsProfile(email: email);
        return;
      }
      final prev = current is AuthOtpSent
          ? current
          : AuthOtpSent(
              email: email,
              maskedEmail: _maskEmail(email),
              expiresIn: 300,
            );
      _handleOtpError(e, prev);
    } catch (e) {
      dev.log('verifyEmailOtp unexpected: $e');
      state = AuthError(message: 'Xatolik yuz berdi. Qayta urinib ko\'ring.');
    }
  }

  // ── Submit profile (display name) ───────────────────────────────────────────
  // Backend checks pre_verified:{email} KV and creates the user with displayName
  Future<void> submitProfile(String displayName) async {
    final current = state;
    if (current is! AuthNeedsProfile) return;
    state = const AuthLoading();
    try {
      final res = await _api.verifyOtp(
        email: current.email,
        otp: '',
        displayName: displayName,
      );
      await _handleSuccess(res);
    } on DioException catch (e) {
      dev.log('submitProfile DioException: ${e.response?.statusCode} ${e.response?.data}');
      state = AuthError(message: _extractError(e) ?? 'Xatolik yuz berdi');
    } catch (e) {
      dev.log('submitProfile unexpected: $e');
      state = AuthError(message: 'Xatolik yuz berdi. Qayta urinib ko\'ring.');
    }
  }

  // ── Resend OTP ──────────────────────────────────────────────────────────────
  Future<void> resendOtp() async {
    final current = state;
    String? email;
    if (current is AuthOtpSent) email = current.email;
    if (email == null) return;
    try {
      await _api.resendOtp(email);
    } catch (_) {}
  }

  // ── Logout ──────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final deviceId = await _tokens.getOrCreateDeviceId();
      await _api.logout(deviceId: deviceId);
    } catch (_) {}
    await _tokens.clearAll();
    await _google.signOut();
    state = const AuthInitial();
  }

  // ── Back to initial ─────────────────────────────────────────────────────────
  void goBack() => state = const AuthInitial();

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Muvaffaqiyatli logindan keyin:
  /// 1. Agar boshqa foydalanuvchi bo'lsa → eski ma'lumotlarni push → DB tozala
  /// 2. Yangi tokenlarni saqlash
  /// 3. Yangi foydalanuvchi ma'lumotlarini pull
  Future<void> _handleSuccess(Map<String, dynamic> res) async {
    final newUser = UserModel.fromJson(res['user'] as Map<String, dynamic>);
    final oldUser = await _tokens.getUser();

    final isUserSwitch = oldUser != null && oldUser.id != newUser.id;

    if (isUserSwitch) {
      dev.log('Hisob almashinmoqda: ${oldUser.email} → ${newUser.email}');
      final db = _ref.read(databaseProvider);

      // Eski foydalanuvchi ma'lumotlarini serverga yuborish
      try {
        final syncSvc = SyncService(db: db, api: _api);
        await syncSvc.pushAll();
        dev.log('Eski foydalanuvchi ma\'lumotlari serverga yuborildi');
      } catch (e) {
        dev.log('Push (switch before) xatosi (o\'tkazib yuborilyapti): $e');
      }

      // Local bazani tozalash (PIN va sozlamalar saqlanib qoladi)
      try {
        await db.clearUserData();
        dev.log('Local baza tozalandi');
      } catch (e) {
        dev.log('clearUserData xatosi: $e');
      }
    }

    // Yangi tokenlarni va profilni saqlash
    await _tokens.saveTokens(
      access: res['accessToken'] as String,
      refresh: res['refreshToken'] as String,
    );
    await _tokens.saveUser(newUser);

    // Yangi foydalanuvchi ma'lumotlarini serverdan yuklash
    if (isUserSwitch) {
      try {
        final db = _ref.read(databaseProvider);
        final syncSvc = SyncService(db: db, api: _api);
        await syncSvc.pullAll();
        dev.log('Yangi foydalanuvchi ma\'lumotlari yuklandi');
      } catch (e) {
        dev.log('Pull (switch after) xatosi (o\'tkazib yuborilyapti): $e');
      }
    }

    state = AuthSuccess(user: newUser);
  }

  void _handleOtpError(DioException e, AuthFlowState prev) {
    final data = e.response?.data as Map<String, dynamic>?;
    state = AuthError(
      message: data?['error'] as String? ?? 'Kod noto\'g\'ri',
      code: data?['code'] as String?,
      attemptsLeft: data?['attemptsLeft'] as int?,
    );
    // Reset to previous state after 2s so user can re-enter OTP
    final errorState = state;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && identical(state, errorState)) state = prev;
    });
  }

  String? _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) return data['error'] as String?;
    return null;
  }
}

final authFlowProvider =
    StateNotifierProvider<AuthFlowNotifier, AuthFlowState>((ref) {
  return AuthFlowNotifier(
    ref.read(authApiServiceProvider),
    ref.read(googleAuthServiceProvider),
    ref.read(tokenServiceProvider),
    ref,
  );
});
