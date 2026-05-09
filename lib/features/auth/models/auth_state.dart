import 'user_model.dart';

sealed class AuthFlowState {
  const AuthFlowState();
}

class AuthFlowInitial extends AuthFlowState {
  const AuthFlowInitial();
}

class AuthFlowLoading extends AuthFlowState {
  const AuthFlowLoading();
}

class AuthFlowGoogleOtpPending extends AuthFlowState {
  final String email;
  final String maskedEmail;
  final String name;
  final String? avatarUrl;
  final String idToken;
  final int expiresIn;
  const AuthFlowGoogleOtpPending({
    required this.email,
    required this.maskedEmail,
    required this.name,
    this.avatarUrl,
    required this.idToken,
    required this.expiresIn,
  });
}

class AuthFlowEmailOtpPending extends AuthFlowState {
  final String email;
  final int expiresIn;
  const AuthFlowEmailOtpPending({
    required this.email,
    required this.expiresIn,
  });
}

class AuthFlowNeedsProfile extends AuthFlowState {
  final String email;
  final String? googleName;
  final String? avatarUrl;
  final String? idToken; // non-null = google flow
  final String pendingOtp;
  const AuthFlowNeedsProfile({
    required this.email,
    this.googleName,
    this.avatarUrl,
    this.idToken,
    required this.pendingOtp,
  });
}

class AuthFlowSuccess extends AuthFlowState {
  final UserModel user;
  const AuthFlowSuccess({required this.user});
}

class AuthFlowError extends AuthFlowState {
  final String message;
  final String? code;
  final int? attemptsLeft;
  const AuthFlowError({
    required this.message,
    this.code,
    this.attemptsLeft,
  });
}
