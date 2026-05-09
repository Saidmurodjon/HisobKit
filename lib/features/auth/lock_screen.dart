import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/app_theme.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _pin = [];
  bool _isError = false;
  bool _biometricsAvailable = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
    _checkBiometrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometrics();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    final settings = ref.read(appSettingsProvider).value;
    final enabled = settings?.biometricsEnabled ?? false;
    if (enabled) {
      final available = await BiometricService.isAvailable();
      if (mounted) setState(() => _biometricsAvailable = available);
    }
  }

  Future<void> _tryBiometrics() async {
    if (!_biometricsAvailable) return;
    await ref.read(authProvider.notifier).authenticateWithBiometrics();
  }

  void _addDigit(String digit) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin.add(digit);
      _isError = false;
    });
    if (_pin.length >= 4) _tryUnlock();
  }

  void _removeDigit() {
    if (_pin.isEmpty) return;
    setState(() => _pin.removeLast());
  }

  Future<void> _tryUnlock() async {
    final pinStr = _pin.join();
    final success =
        await ref.read(authProvider.notifier).authenticateWithPin(pinStr);
    if (!success && mounted) {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0);
      setState(() {
        _isError = true;
        _pin.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, Color(0xFF1A3A5C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // App icon + title
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'HisobKit',
                style: GoogleFonts.sora(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter PIN',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 40),
              // PIN dots with shake
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  final shake = _isError
                      ? 12 * (_shakeAnimation.value > 0.5
                          ? 1 - _shakeAnimation.value
                          : _shakeAnimation.value)
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(shake * 2, 0),
                    child: child,
                  );
                },
                child: _PinDots(
                  length: _pin.length,
                  isError: _isError,
                ),
              ),
              if (_isError) ...[
                const SizedBox(height: 12),
                Text(
                  'Incorrect PIN. Try again.',
                  style: GoogleFonts.inter(
                    color: AppTheme.danger,
                    fontSize: 13,
                  ),
                ),
              ],
              const Spacer(),
              // Numpad
              _NumPad(
                onDigit: _addDigit,
                onDelete: _removeDigit,
                onBiometrics: _biometricsAvailable ? _tryBiometrics : null,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  final int length;
  final bool isError;

  const _PinDots({required this.length, required this.isError});

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppTheme.danger : AppTheme.accent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final filled = i < length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
        );
      }),
    );
  }
}

class _NumPad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onBiometrics;

  const _NumPad({
    required this.onDigit,
    required this.onDelete,
    this.onBiometrics,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          ...buttons.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      row.map((d) => _DigitButton(digit: d, onTap: onDigit)).toList(),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (onBiometrics != null)
                _IconNumButton(
                  icon: Icons.fingerprint,
                  onTap: onBiometrics!,
                )
              else
                const SizedBox(width: 72, height: 72),
              _DigitButton(digit: '0', onTap: onDigit),
              _IconNumButton(
                icon: Icons.backspace_outlined,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitButton extends StatelessWidget {
  final String digit;
  final void Function(String) onTap;

  const _DigitButton({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(digit),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Text(
          digit,
          style: GoogleFonts.sora(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _IconNumButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconNumButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        child: Icon(icon, size: 28, color: Colors.white70),
      ),
    );
  }
}
