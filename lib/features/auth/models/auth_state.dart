import 'user_model.dart';

sealed class AuthFlowState {
  const AuthFlowState();
}

class AuthInitial extends AuthFlowState {
  const AuthInitial();
}

class AuthLoading extends AuthFlowState {
  const AuthLoading();
}

/// OTP sent — maskedEmail is e.g. "al***@gmail.com"
class AuthOtpSent extends AuthFlowState {
  final String email;        // full (lowercase, for API calls)
  final String maskedEmail;  // display only
  final int expiresIn;       // seconds, default 300
  const AuthOtpSent({
    required this.email,
    required this.maskedEmail,
    required this.expiresIn,
  });
}

class AuthNeedsProfile extends AuthFlowState {
  final String email;
  const AuthNeedsProfile({required this.email});
}

class AuthSuccess extends AuthFlowState {
  final UserModel user;
  const AuthSuccess({required this.user});
}

class AuthError extends AuthFlowState {
  final String message;
  final String? code;
  final int? attemptsLeft;
  const AuthError({
    required this.message,
    this.code,
    this.attemptsLeft,
  });
}

// ── Backward-compat aliases (for any code that still uses old names) ──────────
typedef AuthFlowInitial = AuthInitial;
typedef AuthFlowLoading = AuthLoading;
typedef AuthFlowEmailOtpPending = AuthOtpSent;
typedef AuthFlowNeedsProfile = AuthNeedsProfile;
typedef AuthFlowSuccess = AuthSuccess;
typedef AuthFlowError = AuthError;
