import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../security/biometric_service.dart';
import '../security/pin_service.dart';
import 'settings_provider.dart';

enum AuthState { locked, unlocked, noAuth }

class AuthNotifier extends Notifier<AuthState> {
  Timer? _lockTimer;

  @override
  AuthState build() => AuthState.locked;

  void unlock() {
    state = AuthState.unlocked;
    _resetLockTimer();
  }

  void lock() {
    state = AuthState.locked;
    _lockTimer?.cancel();
  }

  void _resetLockTimer() {
    _lockTimer?.cancel();
    final settings = ref.read(appSettingsProvider).value;
    final minutes = settings?.autoLockMinutes ?? 5;
    if (minutes == 0) return; // 0 = never

    _lockTimer = Timer(Duration(minutes: minutes), () {
      state = AuthState.locked;
    });
  }

  void resetInactivityTimer() {
    if (state == AuthState.unlocked) _resetLockTimer();
  }

  Future<bool> authenticateWithBiometrics() async {
    final success = await BiometricService.authenticate(
      localizedReason: 'Open HisobKit',
    );
    if (success) unlock();
    return success;
  }

  Future<bool> authenticateWithPin(String pin) async {
    final success = await PinService.verifyPin(pin);
    if (success) unlock();
    return success;
  }

  Future<bool> checkHasAuth() async {
    final hasPin = await PinService.hasPin();
    if (!hasPin) {
      state = AuthState.noAuth;
      return false;
    }
    return true;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
