import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';
import '../services/google_auth_service.dart';
import '../services/token_service.dart';

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

  AuthFlowNotifier(this._api, this._google, this._tokens)
      : super(const AuthFlowInitial()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _tokens.getAccessToken();
    final user = await _tokens.getUser();
    if (token != null && user != null && !_tokens.isTokenExpired(token)) {
      state = AuthFlowSuccess(user: user);
    }
    // Try refresh if access expired but refresh available
    else if (user != null) {
      final refresh = await _tokens.getRefreshToken();
      if (refresh != null && !_tokens.isTokenExpired(refresh)) {
        state = AuthFlowSuccess(user: user);
      }
    }
  }

  // ── Google sign-in ──────────────────────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    state = const AuthFlowLoading();
    try {
      final idToken = await _google.signIn();
      if (idToken == null) {
        // User cancelled — go back to initial quietly
        state = const AuthFlowInitial();
        return;
      }
      final res = await _api.googleInit(idToken);
      state = AuthFlowGoogleOtpPending(
        email: res['email'] as String,
        maskedEmail: res['maskedEmail'] as String? ?? res['email'] as String,
        name: res['name'] as String? ?? '',
        avatarUrl: res['avatarUrl'] as String?,
        idToken: idToken,
        expiresIn: res['expiresIn'] as int? ?? 300,
      );
    } on GoogleAuthException catch (e) {
      dev.log('Google sign-in error: $e');
      state = AuthFlowError(message: e.message, code: e.code);
    } on DioException catch (e) {
      dev.log('Google API error: $e');
      state = AuthFlowError(message: _extractError(e) ?? 'Google kirish xatosi');
    } catch (e) {
      dev.log('Google unexpected error: $e');
      state = AuthFlowError(message: 'Xatolik: $e');
    }
  }

  // ── Email OTP send ──────────────────────────────────────────────────────────
  Future<void> sendEmailOtp(String email) async {
    state = const AuthFlowLoading();
    try {
      final res = await _api.emailSendOtp(email);
      state = AuthFlowEmailOtpPending(
        email: email,
        expiresIn: res['expiresIn'] as int? ?? 300,
      );
    } on DioException catch (e) {
      dev.log('sendEmailOtp error: ${e.response?.statusCode} ${e.response?.data}');
      state = AuthFlowError(message: _extractError(e) ?? 'Email yuborishda xato');
    } catch (e) {
      dev.log('sendEmailOtp unexpected: $e');
      state = AuthFlowError(message: 'Xatolik: $e');
    }
  }

  // ── Google OTP verify ───────────────────────────────────────────────────────
  Future<void> verifyGoogleOtp(String otp) async {
    final current = state;
    if (current is! AuthFlowGoogleOtpPending) return;

    state = const AuthFlowLoading();
    try {
      final res = await _api.googleVerify(idToken: current.idToken, otp: otp);
      await _handleSuccess(res);
    } on DioException catch (e) {
      _handleOtpError(e, current);
    }
  }

  // ── Email OTP verify ────────────────────────────────────────────────────────
  Future<void> verifyEmailOtp(String otp, {String? displayName}) async {
    final current = state;
    if (current is! AuthFlowEmailOtpPending && current is! AuthFlowNeedsProfile) return;

    final email = current is AuthFlowEmailOtpPending
        ? current.email
        : (current as AuthFlowNeedsProfile).email;

    state = const AuthFlowLoading();
    try {
      final res = await _api.emailVerifyOtp(
        email: email,
        otp: otp,
        displayName: displayName,
      );

      // Backend said: new user but no display name sent
      if (res['code'] == 'needs_profile') {
        state = AuthFlowNeedsProfile(
          email: email,
          pendingOtp: otp,
        );
        return;
      }

      await _handleSuccess(res);
    } on DioException catch (e) {
      final data = e.response?.data as Map<String, dynamic>?;
      if (data?['code'] == 'needs_profile') {
        state = AuthFlowNeedsProfile(
          email: email,
          pendingOtp: otp,
        );
        return;
      }
      final prev = current is AuthFlowEmailOtpPending
          ? current
          : AuthFlowEmailOtpPending(email: email, expiresIn: 300);
      _handleOtpError(e, prev);
    }
  }

  // ── Submit profile (display name) ───────────────────────────────────────────
  Future<void> submitProfile(String displayName) async {
    final current = state;
    if (current is! AuthFlowNeedsProfile) return;
    state = const AuthFlowLoading();
    try {
      final res = await _api.emailVerifyOtp(
        email: current.email,
        otp: current.pendingOtp,
        displayName: displayName,
      );
      await _handleSuccess(res);
    } on DioException catch (e) {
      state = AuthFlowError(message: _extractError(e) ?? 'Xatolik');
    }
  }

  // ── Resend OTP ──────────────────────────────────────────────────────────────
  Future<void> resendOtp() async {
    final current = state;
    String? email;
    if (current is AuthFlowEmailOtpPending) email = current.email;
    if (current is AuthFlowGoogleOtpPending) email = current.email;
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
    state = const AuthFlowInitial();
  }

  // ── Back to initial ─────────────────────────────────────────────────────────
  void goBack() => state = const AuthFlowInitial();

  // ── Helpers ─────────────────────────────────────────────────────────────────
  Future<void> _handleSuccess(Map<String, dynamic> res) async {
    final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
    await _tokens.saveTokens(
      access: res['accessToken'] as String,
      refresh: res['refreshToken'] as String,
    );
    await _tokens.saveUser(user);
    state = AuthFlowSuccess(user: user);
  }

  void _handleOtpError(DioException e, AuthFlowState prev) {
    final data = e.response?.data as Map<String, dynamic>?;
    state = AuthFlowError(
      message: data?['error'] as String? ?? 'Xatolik',
      code: data?['code'] as String?,
      attemptsLeft: data?['attemptsLeft'] as int?,
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && state is AuthFlowError) state = prev;
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
  );
});
