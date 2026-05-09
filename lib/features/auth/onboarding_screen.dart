import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/security/pin_service.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  // Setup state
  String _selectedLanguage = 'uz';
  String _selectedCurrency = 'UZS';
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _pinError;
  bool _biometricsAvailable = false;
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    final available = await BiometricService.isAvailable();
    if (mounted) setState(() => _biometricsAvailable = available);
  }

  void _goNext() {
    if (_page < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    // Validate PIN
    if (_pinController.text.length < 4) {
      setState(() => _pinError = 'PIN must be at least 4 digits');
      return;
    }
    if (_pinController.text != _confirmPinController.text) {
      setState(() => _pinError = 'PINs do not match');
      return;
    }
    setState(() => _pinError = null);

    final settingsNotifier = ref.read(appSettingsProvider.notifier);
    final authNotifier = ref.read(authProvider.notifier);

    if (_pinController.text.isNotEmpty) {
      await PinService.setPin(_pinController.text);
    }

    await settingsNotifier.setLanguage(_selectedLanguage);
    await settingsNotifier.setBaseCurrency(_selectedCurrency);
    await settingsNotifier.setBiometrics(_biometricsEnabled);

    authNotifier.unlock();
    await settingsNotifier.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (p) => setState(() => _page = p),
            children: [
              _WelcomePage(
                selectedLanguage: _selectedLanguage,
                onLanguageSelect: (l) => setState(() => _selectedLanguage = l),
              ),
              _SecurityPage(
                biometricsAvailable: _biometricsAvailable,
                biometricsEnabled: _biometricsEnabled,
                onBiometricsToggle: (v) => setState(() => _biometricsEnabled = v),
              ),
              _SetupPage(
                selectedCurrency: _selectedCurrency,
                onCurrencySelect: (c) => setState(() => _selectedCurrency = c),
                pinController: _pinController,
                confirmPinController: _confirmPinController,
                pinError: _pinError,
              ),
            ],
          ),

          // Navigation controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i
                              ? AppTheme.accent
                              : AppTheme.accent.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_page > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goBack,
                            child: const Text('Back'),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox.shrink()),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _goNext,
                          child: Text(_page == 2 ? 'Boshlash' : 'Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 1: Welcome + Language ────────────────────────────────────────────────
class _WelcomePage extends StatelessWidget {
  final String selectedLanguage;
  final void Function(String) onLanguageSelect;

  const _WelcomePage({
    required this.selectedLanguage,
    required this.onLanguageSelect,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'uz', 'name': "O'zbek", 'flag': '🇺🇿'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF163A5E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.savings_outlined, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'HisobKit',
              style: GoogleFonts.sora(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Your private finance tracker',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Choose your language',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ...languages.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onLanguageSelect(l['code']!),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: selectedLanguage == l['code']
                          ? AppTheme.accent.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selectedLanguage == l['code']
                            ? AppTheme.accent
                            : (Theme.of(context).dividerTheme.color ?? Colors.transparent),
                        width: selectedLanguage == l['code'] ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(l['flag']!, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Text(
                          l['name']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: selectedLanguage == l['code']
                                    ? AppTheme.accent
                                    : null,
                              ),
                        ),
                        const Spacer(),
                        if (selectedLanguage == l['code'])
                          const Icon(Icons.check_circle_rounded,
                              color: AppTheme.accent, size: 20),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ── Page 2: Security ──────────────────────────────────────────────────────────
class _SecurityPage extends StatelessWidget {
  final bool biometricsAvailable;
  final bool biometricsEnabled;
  final void Function(bool) onBiometricsToggle;

  const _SecurityPage({
    required this.biometricsAvailable,
    required this.biometricsEnabled,
    required this.onBiometricsToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.shield_outlined,
                  size: 48, color: AppTheme.accent),
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'Your data, your device',
              style: GoogleFonts.sora(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'HisobKit stores all data encrypted on your device only. Nothing is sent to any server.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Security features list
          _SecurityFeature(
            icon: Icons.lock_outline,
            color: AppTheme.primary,
            title: 'SQLCipher encryption',
            subtitle: 'Military-grade AES-256 database encryption',
          ),
          const SizedBox(height: 12),
          _SecurityFeature(
            icon: Icons.wifi_off_outlined,
            color: AppTheme.accent,
            title: '100% offline',
            subtitle: 'No internet required, no telemetry',
          ),
          const SizedBox(height: 12),
          _SecurityFeature(
            icon: Icons.fingerprint,
            color: AppTheme.warning,
            title: 'Biometric unlock',
            subtitle: 'Fingerprint or Face ID for quick access',
          ),
          if (biometricsAvailable) ...[
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
              ),
              child: SwitchListTile(
                value: biometricsEnabled,
                onChanged: onBiometricsToggle,
                title: const Text('Enable biometrics'),
                subtitle: const Text('Fingerprint or Face ID'),
                secondary: const Icon(Icons.fingerprint, color: AppTheme.accent),
                activeColor: AppTheme.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SecurityFeature extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _SecurityFeature({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
              Text(subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Page 3: Setup (currency + PIN) ────────────────────────────────────────────
class _SetupPage extends StatelessWidget {
  final String selectedCurrency;
  final void Function(String) onCurrencySelect;
  final TextEditingController pinController;
  final TextEditingController confirmPinController;
  final String? pinError;

  const _SetupPage({
    required this.selectedCurrency,
    required this.onCurrencySelect,
    required this.pinController,
    required this.confirmPinController,
    this.pinError,
  });

  @override
  Widget build(BuildContext context) {
    const currencies = ['UZS', 'USD', 'EUR', 'RUB', 'GBP', 'KZT'];
    const symbols = {
      'UZS': "so'm",
      'USD': '\$',
      'EUR': '€',
      'RUB': '₽',
      'GBP': '£',
      'KZT': '₸',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Setup',
            style: GoogleFonts.sora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Configure your base currency and security PIN.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 28),

          // Currency
          Text('Base Currency',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: currencies.map((c) {
              final selected = c == selectedCurrency;
              return GestureDetector(
                onTap: () => onCurrencySelect(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.primary
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? AppTheme.primary
                          : (Theme.of(context).dividerTheme.color ?? Colors.transparent),
                    ),
                  ),
                  child: Text(
                    '$c — ${symbols[c]}',
                    style: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // PIN setup
          Text('Set PIN',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 4),
          Text(
            'Create a 4–8 digit PIN to protect your data.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 8,
            decoration: const InputDecoration(
              labelText: 'PIN (4–8 digits)',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 8,
            decoration: const InputDecoration(
              labelText: 'Confirm PIN',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          if (pinError != null) ...[
            const SizedBox(height: 8),
            Text(
              pinError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
