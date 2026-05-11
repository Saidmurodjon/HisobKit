import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory flag: true when user taps "Keyinroq" on the welcome screen.
/// Resets to false on app restart (intentional — users should set up cloud auth).
final cloudAuthSkippedProvider = StateProvider<bool>((ref) => false);
