import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keeps track of which page onboarding should jump to when the screen
/// is re-entered (e.g. after returning from OTP / profile-setup screens).
final onboardingPageProvider = StateProvider<int>((ref) => 0);
