import 'package:google_sign_in/google_sign_in.dart';

// Google Cloud Console → HisobKit project → OAuth 2.0 → Web Client ID
const String _webClientId = '489510485811-2esilpsbnglti0bjofpn97j766tq9anv.apps.googleusercontent.com';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // serverClientId — idToken olish uchun zarur (Web Client ID ishlatiladi)
    serverClientId: _webClientId,
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
