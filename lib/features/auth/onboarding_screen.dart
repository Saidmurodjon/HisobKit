import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/security/pin_service.dart';
import '../../core/security/biometric_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  // Page 1: language
  String _selectedLanguage = 'uz';

  // Page 2: base currency
  String _selectedCurrency = 'UZS';

  // Page 3: PIN
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _pinError;

  // Page 4: biometrics
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

  void _nextPage() {
    if (_page == 2) {
      // Validate PIN before advancing
      if (_pinController.text.length < 4) {
        setState(() => _pinError = 'PIN must be at least 4 digits');
        return;
      }
      if (_pinController.text != _confirmPinController.text) {
        setState(() => _pinError = 'PINs do not match');
        return;
      }
      setState(() => _pinError = null);
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    // Capture notifier references before any await that might dispose the widget
    final settingsNotifier = ref.read(appSettingsProvider.notifier);
    final authNotifier = ref.read(authProvider.notifier);

    // Save PIN (no routing side-effects)
    if (_pinController.text.isNotEmpty) {
      await PinService.setPin(_pinController.text);
    }

    // Save non-routing settings
    await settingsNotifier.setLanguage(_selectedLanguage);
    await settingsNotifier.setBaseCurrency(_selectedCurrency);
    await settingsNotifier.setBiometrics(_biometricsEnabled);

    // Unlock BEFORE completing onboarding so the router sees
    // authState == unlocked when it re-evaluates after the next line
    authNotifier.unlock();

    // This triggers router re-evaluation → navigates to '/'
    // Widget is disposed after this — do NOT use ref or context below
    await settingsNotifier.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_page + 1) / 4),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  _LanguagePage(
                    selected: _selectedLanguage,
                    onSelect: (l) => setState(() => _selectedLanguage = l),
                  ),
                  _CurrencyPage(
                    selected: _selectedCurrency,
                    onSelect: (c) => setState(() => _selectedCurrency = c),
                  ),
                  _PinPage(
                    pinController: _pinController,
                    confirmController: _confirmPinController,
                    error: _pinError,
                  ),
                  _BiometricsPage(
                    available: _biometricsAvailable,
                    enabled: _biometricsEnabled,
                    onToggle: (v) => setState(() => _biometricsEnabled = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_page > 0)
                    OutlinedButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox.shrink(),
                  if (_page < 3)
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(120, 44),
                      ),
                      onPressed: _nextPage,
                      child: const Text('Next'),
                    )
                  else
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(140, 44),
                      ),
                      onPressed: _finish,
                      child: const Text('Get Started'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePage extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;

  const _LanguagePage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'uz', 'name': "O'zbek", 'flag': '🇺🇿'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Welcome to HisobKit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 8),
          Text('Choose your language',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 32),
          ...languages.map((l) => RadioListTile<String>(
                value: l['code']!,
                groupValue: selected,
                onChanged: (v) => onSelect(v!),
                title: Text('${l['flag']} ${l['name']}'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )),
        ],
      ),
    );
  }
}

class _CurrencyPage extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;

  const _CurrencyPage({required this.selected, required this.onSelect});

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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Base Currency',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 8),
          Text('Choose your main currency',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 32),
          ...currencies.map((c) => RadioListTile<String>(
                value: c,
                groupValue: selected,
                onChanged: (v) => onSelect(v!),
                title: Text('$c — ${symbols[c]}'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )),
        ],
      ),
    );
  }
}

class _PinPage extends StatelessWidget {
  final TextEditingController pinController;
  final TextEditingController confirmController;
  final String? error;

  const _PinPage({
    required this.pinController,
    required this.confirmController,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Set PIN',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 8),
          Text('Create a PIN to secure your data',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 32),
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
          const SizedBox(height: 16),
          TextField(
            controller: confirmController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 8,
            decoration: const InputDecoration(
              labelText: 'Confirm PIN',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error, fontSize: 14)),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BiometricsPage extends StatelessWidget {
  final bool available;
  final bool enabled;
  final void Function(bool) onToggle;

  const _BiometricsPage({
    required this.available,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Biometric Lock',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 8),
          Text('Use fingerprint or Face ID to unlock the app',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 32),
          if (!available)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 12),
                    const Expanded(
                        child: Text(
                            'Biometrics not available on this device.')),
                  ],
                ),
              ),
            )
          else
            SwitchListTile(
              value: enabled,
              onChanged: onToggle,
              title: const Text('Enable Biometrics'),
              subtitle: const Text('Fingerprint or Face ID'),
              secondary: const Icon(Icons.fingerprint, size: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
        ],
      ),
    );
  }
}
