import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../providers/cloud_auth_skip_provider.dart';
import '../models/auth_state.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = state is AuthLoading;

    ref.listen<AuthFlowState>(authFlowProvider, (_, next) {
      if (next is AuthOtpSent) context.go('/auth/otp');
      if (next is AuthSuccess) {
        // Cloud auth (Google) succeeded → also unlock device lock
        ref.read(authProvider.notifier).unlock();
        context.go('/');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF163A5E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withAlpha(60),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 20),
                Text(
                  'HisobKit',
                  style: GoogleFonts.sora(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Moliyangizni nazorat qiling',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                  ),
                ),

                const Spacer(flex: 2),

                // Email input
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  enabled: !isLoading,
                  style: GoogleFonts.inter(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'misol@gmail.com',
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
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
                      borderSide:
                          const BorderSide(color: AppTheme.accent, width: 2),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withAlpha(13)
                        : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email kiritilmagan';
                    final reg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!reg.hasMatch(v.trim())) return 'Email formati noto\'g\'ri';
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(notifier),
                ),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 5),
                    Text(
                      'Gmail, Mail.ru — istalgan email',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),

                // Error
                if (state is AuthError) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.red.shade900.withAlpha(80)
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isDark
                              ? Colors.red.shade700
                              : Colors.red.shade200),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(state.message,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.red.shade400)),
                      ),
                    ]),
                  ),
                ],

                const SizedBox(height: 20),

                // Davom etish button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: isLoading ? null : () => _submit(notifier),
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
                        : Text('Davom etish',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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
                      child: Text('yoki',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500)),
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
                    onPressed:
                        isLoading ? null : () => notifier.signInWithGoogle(),
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
                        const Text('G',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Arial')),
                        const SizedBox(width: 10),
                        Text('Google bilan kirish',
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.primary)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Telegram button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed:
                        isLoading ? null : () => context.push('/auth/telegram'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF0088CC), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.telegram,
                            color: Color(0xFF0088CC), size: 22),
                        const SizedBox(width: 10),
                        Text('Telegram orqali kirish',
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0088CC))),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Skip button — offline mode
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref.read(cloudAuthSkippedProvider.notifier).state =
                              true;
                          context.go('/');
                        },
                  child: Text(
                    'Keyinroq kiraman (oflayn rejim)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Kirish — Foydalanish shartlariga rozilik',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(AuthFlowNotifier notifier) {
    if (_formKey.currentState!.validate()) {
      notifier.sendEmailOtp(_emailCtrl.text.trim());
    }
  }
}
