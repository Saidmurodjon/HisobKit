import 'package:google_sign_in/google_sign_in.dart';

// ── Muhim: Google Cloud Console → OAuth 2.0 → Web Client ID ni bu yerga qo'ying
// https://console.cloud.google.com → APIs & Services → Credentials
// "Web application" turli Client ID (idToken uchun kerak)
const String _webClientId = 'PLACEHOLDER_WEB_CLIENT_ID.apps.googleusercontent.com';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // serverClientId — idToken olish uchun zarur
    serverClientId: _webClientId == 'PLACEHOLDER_WEB_CLIENT_ID.apps.googleusercontent.com'
        ? null
        : _webClientId,
  );

  Future<String?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.idToken;
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
