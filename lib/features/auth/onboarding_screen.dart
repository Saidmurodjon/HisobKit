import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/security/pin_service.dart';
import '../../core/security/biometric_service.dart';
import '../../core/theme/app_theme.dart';
import 'providers/auth_flow_provider.dart';
import 'providers/cloud_auth_skip_provider.dart';
import 'providers/onboarding_page_provider.dart';
import 'models/auth_state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  bool _isFinishing = false;

  // Page 0
  String _selectedLanguage = 'uz';

  // Page 2 (security)
  bool _biometricsAvailable = false;
  bool _biometricsEnabled = false;

  // Page 3 (currency + PIN)
  String _selectedCurrency = 'UZS';
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _pinError;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Jump to saved page (e.g. returning from OTP after auth)
      final savedPage = ref.read(onboardingPageProvider);
      final authFlow = ref.read(authFlowProvider);
      final skipped = ref.read(cloudAuthSkippedProvider);

      int targetPage = savedPage;
      // If already authenticated, skip past email page
      if ((authFlow is AuthSuccess || skipped) && targetPage <= 1) {
        targetPage = 2;
      }
      if (targetPage > 0 && mounted) {
        _pageController.jumpToPage(targetPage);
        setState(() => _page = targetPage);
      }
    });
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

  Future<void> _goNext() async {
    if (_page == 1) {
      // Skip cloud auth — mark as skipped and advance
      ref.read(cloudAuthSkippedProvider.notifier).state = true;
      ref.read(onboardingPageProvider.notifier).state = 2;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else if (_page < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    if (_pinController.text.length != 4) {
      setState(() => _pinError = 'PIN aynan 4 ta raqam bo\'lsin');
      return;
    }
    if (_pinController.text != _confirmPinController.text) {
      setState(() => _pinError = 'PIN kodlar mos kelmadi');
      return;
    }
    setState(() {
      _pinError = null;
      _isFinishing = true;
    });

    try {
      final settingsNotifier = ref.read(appSettingsProvider.notifier);
      final authNotifier = ref.read(authProvider.notifier);

      print('[FINISH] 1 setPin start');
      await ref.read(pinServiceProvider).setPin(_pinController.text);
      print('[FINISH] 2 setPin done');

      await settingsNotifier.setLanguage(_selectedLanguage);
      print('[FINISH] 3 setLanguage done');

      await settingsNotifier.setBaseCurrency(_selectedCurrency);
      print('[FINISH] 4 setCurrency done');

      await settingsNotifier.setBiometrics(_biometricsEnabled);
      print('[FINISH] 5 setBiometrics done');

      authNotifier.unlock();
      print('[FINISH] 6 unlock done');

      ref.read(onboardingPageProvider.notifier).state = 0;
      await settingsNotifier.completeOnboarding();
      print('[FINISH] 7 completeOnboarding done');
    } catch (e) {
      print('[FINISH] ERROR: $e');
      if (mounted) setState(() => _isFinishing = false);
    }
  }

  String get _nextLabel {
    if (_page == 1) return 'O\'tkazib yuborish';
    if (_page == 3) return 'Boshlash';
    return 'Keyingi';
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes while on email page
    ref.listen<AuthFlowState>(authFlowProvider, (_, next) {
      if (!mounted) return;
      if (next is AuthOtpSent && _page == 1) {
        // Navigate to OTP screen; on success it will context.go('/onboarding')
        context.push('/auth/otp');
      }
      if (next is AuthNeedsProfile && _page == 1) {
        context.push('/auth/profile');
      }
      if (next is AuthSuccess && _page == 1) {
        ref.read(authProvider.notifier).unlock();
        ref.read(onboardingPageProvider.notifier).state = 2;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (p) => setState(() => _page = p),
            children: [
              // Page 0: Language
              _WelcomePage(
                selectedLanguage: _selectedLanguage,
                onLanguageSelect: (l) => setState(() => _selectedLanguage = l),
              ),
              // Page 1: Cloud auth (optional)
              const _EmailAuthPage(),
              // Page 2: Security info
              _SecurityPage(
                biometricsAvailable: _biometricsAvailable,
                biometricsEnabled: _biometricsEnabled,
                onBiometricsToggle: (v) =>
                    setState(() => _biometricsEnabled = v),
              ),
              // Page 3: Currency + PIN
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
                    color: Theme.of(context).dividerTheme.color ??
                        Colors.transparent,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator dots (4 pages)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
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
                            child: const Text('Orqaga'),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox.shrink()),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _isFinishing ? null : _goNext,
                          child: _isFinishing && _page == 3
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                )
                              : Text(_nextLabel),
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

// ── Page 1: Welcome + Language ─────────────────────────────────────────────────
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
              child: const Icon(Icons.savings_outlined,
                  size: 48, color: Colors.white),
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
              'Shaxsiy moliya ilovasi',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Tilni tanlang',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...languages.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onLanguageSelect(l['code']!),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: selectedLanguage == l['code']
                          ? AppTheme.accent.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selectedLanguage == l['code']
                            ? AppTheme.accent
                            : (Theme.of(context).dividerTheme.color ??
                                Colors.transparent),
                        width: selectedLanguage == l['code'] ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(l['flag']!,
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Text(
                          l['name']!,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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

// ── Page 2: Email / Cloud auth (optional) ─────────────────────────────────────
class _EmailAuthPage extends ConsumerStatefulWidget {
  const _EmailAuthPage();

  @override
  ConsumerState<_EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends ConsumerState<_EmailAuthPage> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authFlowProvider.notifier)
          .sendEmailOtp(_emailCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowProvider);
    final isLoading = state is AuthLoading;
    final isSuccess = state is AuthSuccess;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 200),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(50),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.cloud_sync_outlined,
                    size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Sinxronlash (ixtiyoriy)',
                style: GoogleFonts.sora(
                    fontSize: 24, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Email orqali kirish — bir necha qurilma orasida ma\'lumotlarni sinxronlash imkonini beradi.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            if (isSuccess) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.green.withOpacity(0.4)),
                ),
                child: Row(children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    'Muvaffaqiyatli kirdingiz!',
                    style: GoogleFonts.inter(
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
            ] else ...[
              const SizedBox(height: 32),

              // Email input
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                style: GoogleFonts.inter(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'misol@gmail.com',
                  hintStyle:
                      GoogleFonts.inter(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.email_outlined,
                      color: isDark ? AppTheme.accent : AppTheme.primary,
                      size: 22),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: isDark
                            ? Colors.white24
                            : Colors.grey.shade300,
                        width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: AppTheme.accent, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withAlpha(13)
                      : const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email kiritilmagan';
                  }
                  final reg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!reg.hasMatch(v.trim())) {
                    return 'Email formati noto\'g\'ri';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),

              if (state is AuthError) ...[
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: Colors.red.shade400),
                ),
              ],

              const SizedBox(height: 16),

              // Davom etish button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'Davom etish',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Divider + Google
              Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: isDark
                              ? Colors.white24
                              : Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'yoki',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white38
                              : Colors.grey.shade500),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          color: isDark
                              ? Colors.white24
                              : Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () => ref
                          .read(authFlowProvider.notifier)
                          .signInWithGoogle(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: isDark
                            ? Colors.white30
                            : Colors.grey.shade300,
                        width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'G',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Arial'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Google bilan kirish',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppTheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Page 3: Security info + biometrics ────────────────────────────────────────
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
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
              'Ma\'lumotlaringiz — qurilmangizda',
              style: GoogleFonts.sora(
                  fontSize: 22, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'HisobKit barcha ma\'lumotlarni faqat qurilmangizda shifrlangan holda saqlaydi.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          _SecurityFeature(
            icon: Icons.lock_outline,
            color: AppTheme.primary,
            title: 'SQLCipher shifrlash',
            subtitle: 'AES-256 harbiy darajali ma\'lumotlar bazasi',
          ),
          const SizedBox(height: 12),
          _SecurityFeature(
            icon: Icons.wifi_off_outlined,
            color: AppTheme.accent,
            title: '100% oflayn',
            subtitle: 'Internet shart emas, telemetriya yo\'q',
          ),
          const SizedBox(height: 12),
          _SecurityFeature(
            icon: Icons.fingerprint,
            color: AppTheme.warning,
            title: 'Biometrik kirish',
            subtitle: 'Barmoq izi yoki Face ID',
          ),
          if (biometricsAvailable) ...[
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.accent.withOpacity(0.2)),
              ),
              child: SwitchListTile(
                value: biometricsEnabled,
                onChanged: onBiometricsToggle,
                title: const Text('Biometrikani yoqish'),
                subtitle: const Text('Barmoq izi yoki Face ID'),
                secondary: const Icon(Icons.fingerprint,
                    color: AppTheme.accent),
                activeColor: AppTheme.accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Page 4: Setup (currency + PIN) ────────────────────────────────────────────
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
            'Sozlamalar',
            style: GoogleFonts.sora(
                fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Asosiy valyuta va mahalliy parolni o\'rnating.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 28),

          // Currency
          Text(
            'Asosiy valyuta',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.primary
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? AppTheme.primary
                          : (Theme.of(context).dividerTheme.color ??
                              Colors.transparent),
                    ),
                  ),
                  child: Text(
                    '$c — ${symbols[c]}',
                    style: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // PIN setup
          Text(
            'Mahalliy parol o\'rnating',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Ilovani himoya qilish uchun 4 ta raqamli parol.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: '4 ta raqamli parol',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: 'Parolni tasdiqlang',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          if (pinError != null) ...[
            const SizedBox(height: 8),
            Text(
              pinError!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
