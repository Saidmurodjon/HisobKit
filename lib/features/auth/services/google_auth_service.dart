import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Google Cloud Console → HisobKit project → OAuth 2.0 → Web Client ID
const String _webClientId = '489510485811-2esilpsbnglti0bjofpn97j766tq9anv.apps.googleusercontent.com';

class GoogleAuthException implements Exception {
  final String message;
  final String? code;
  GoogleAuthException(this.message, {this.code});
  @override
  String toString() => 'GoogleAuthException($code): $message';
}

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: _webClientId,
  );

  /// Returns idToken on success.
  /// Throws [GoogleAuthException] with a user-friendly Uzbek message on failure.
  /// Returns null if the user cancelled the sign-in dialog.
  Future<String?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // user cancelled

      final auth = await account.authentication;
      final token = auth.idToken;
      if (token == null) {
        throw GoogleAuthException(
          'Google token olinmadi. google-services.json va SHA1 sozlamalarini tekshiring.',
          code: 'null_id_token',
        );
      }
      return token;
    } on PlatformException catch (e) {
      final msg = switch (e.code) {
        'sign_in_failed'     => 'Google kirish muvaffaqiyatsiz. '
            'SHA1 fingerprint Google Cloud Console da ro\'yxatdan o\'tganligini tekshiring.',
        'sign_in_canceled'   => null, // user cancelled — return null
        'network_error'      => 'Internet aloqasi yo\'q.',
        'sign_in_required'   => 'Google akkauntiga kirishingiz kerak.',
        _                    => 'Google xatosi: ${e.code} — ${e.message}',
      };
      if (msg == null) return null;
      throw GoogleAuthException(msg, code: e.code);
    } catch (e) {
      throw GoogleAuthException('Kutilmagan xato: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
