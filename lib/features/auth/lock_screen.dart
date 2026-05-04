import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/app_theme.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final List<String> _pin = [];
  bool _isError = false;
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometrics();
    });
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
      setState(() {
        _isError = true;
        _pin.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<MaterialLocalizations>(
        context, MaterialLocalizations)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(
              Icons.lock_outline,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'HisobKit',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter PIN',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _PinDots(
              length: _pin.length,
              isError: _isError,
            ),
            if (_isError) ...[
              const SizedBox(height: 8),
              Text(
                'Incorrect PIN. Try again.',
                style: TextStyle(color: colorScheme.error, fontSize: 14),
              ),
            ],
            const Spacer(),
            _NumPad(
              onDigit: _addDigit,
              onDelete: _removeDigit,
              onBiometrics: _biometricsAvailable ? _tryBiometrics : null,
            ),
            const SizedBox(height: 32),
          ],
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
    final color = isError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final filled = i < length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 16,
          height: 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          ...buttons.map((row) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row
                    .map((d) => _DigitButton(digit: d, onTap: onDigit))
                    .toList(),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (onBiometrics != null)
                _IconButton(
                  icon: Icons.fingerprint,
                  onTap: onBiometrics!,
                )
              else
                const SizedBox(width: 72, height: 72),
              _DigitButton(digit: '0', onTap: onDigit),
              _IconButton(
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
        child: Text(
          digit,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        child: Icon(icon, size: 28),
      ),
    );
  }
}
