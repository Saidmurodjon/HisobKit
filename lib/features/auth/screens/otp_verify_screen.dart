import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../models/auth_state.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _countdown = 300;
  Timer? _timer;
  String _maskedEmail = '';

  @override
  void initState() {
    super.initState();
    final s = ref.read(authFlowProvider);
    if (s is AuthOtpSent) {
      _maskedEmail = s.maskedEmail;
      _countdown = s.expiresIn;
    }
    _startCountdown();
  }

  void _startCountdown([int? seconds]) {
    _timer?.cancel();
    if (seconds != null) setState(() => _countdown = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _submit() {
    final otp = _otp;
    if (otp.length != 6) return;
    ref.read(authFlowProvider.notifier).verifyEmailOtp(otp);
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_otp.length == 6) _submit();
  }

  void _clearInputs() {
    for (final c in _controllers) c.clear();
    if (mounted) _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Keep maskedEmail even when state transitions to error/loading
    if (state is AuthOtpSent) _maskedEmail = state.maskedEmail;

    ref.listen<AuthFlowState>(authFlowProvider, (prev, next) {
      if (next is AuthSuccess) {
        // Cloud auth succeeded → also unlock device lock so no second login
        ref.read(authProvider.notifier).unlock();
        context.go('/');
      }
      if (next is AuthNeedsProfile) context.go('/auth/profile');
      if (next is AuthError) _clearInputs();
    });

    final isLoading = state is AuthLoading;
    final isBlocked = state is AuthError && state.code == 'blocked';
    final hasError = state is AuthError;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            notifier.goBack();
            context.go('/auth/welcome');
          },
        ),
        title: Text('Tasdiqlash kodi',
            style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Email icon
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.mark_email_unread_outlined,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),

              Text(
                'Emailingizni tasdiqlang',
                style: GoogleFonts.sora(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppTheme.primary),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.grey.shade500),
                  children: [
                    const TextSpan(text: 'Kod '),
                    TextSpan(
                      text: _maskedEmail,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : AppTheme.primary),
                    ),
                    const TextSpan(text: ' ga yuborildi'),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return Container(
                    width: 46,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextFormField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      enabled: !isLoading && !isBlocked,
                      style: GoogleFonts.sora(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: hasError ? Colors.red.shade400 : null,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: hasError
                            ? (isDark
                                ? Colors.red.shade900.withAlpha(80)
                                : Colors.red.shade50)
                            : isDark
                                ? Colors.white.withAlpha(18)
                                : const Color(0xFFF4F6F9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: hasError
                                ? Colors.red.shade300
                                : isDark
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: hasError ? Colors.red : AppTheme.accent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      onChanged: (v) => _onDigitChanged(i, v),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Status
              if (isLoading)
                const SizedBox(
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2.5))
              else if (state case AuthError(:final message, :final attemptsLeft) when !isBlocked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                  child: Column(children: [
                    Text(
                      message,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: Colors.red.shade400),
                      textAlign: TextAlign.center,
                    ),
                    if (attemptsLeft != null)
                      Text(
                        '$attemptsLeft ta urinish qoldi',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w600),
                      ),
                  ]),
                ),

              if (isBlocked)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.orange.shade900.withAlpha(80)
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDark
                            ? Colors.orange.shade700
                            : Colors.orange.shade200),
                  ),
                  child: Text(
                    '30 daqiqa bloklandingiz. Keyinroq urinib ko\'ring.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.orange.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),

              const Spacer(),

              // Timer + Resend
              if (!isBlocked) ...[
                // Countdown ring
                if (_countdown > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 16,
                          color: _countdown < 60
                              ? Colors.orange.shade400
                              : Colors.grey.shade400),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(_countdown),
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _countdown < 60
                              ? Colors.orange.shade400
                              : (isDark ? Colors.white54 : Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: _countdown == 0 && !isLoading
                      ? () {
                          notifier.resendOtp();
                          _startCountdown(300);
                          _clearInputs();
                        }
                      : null,
                  child: Text(
                    'Qayta yuborish',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _countdown == 0
                            ? AppTheme.accent
                            : Colors.grey.shade400),
                  ),
                ),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
