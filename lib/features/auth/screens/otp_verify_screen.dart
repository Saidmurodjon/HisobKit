import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../models/auth_state.dart';
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

  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _resendCountdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _submit() {
    final otp = _otp;
    if (otp.length != 6) return;
    final state = ref.read(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    if (state is AuthFlowGoogleOtpPending) {
      notifier.verifyGoogleOtp(otp);
    } else if (state is AuthFlowEmailOtpPending) {
      notifier.verifyEmailOtp(otp);
    }
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
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthFlowState>(authFlowProvider, (prev, next) {
      if (next is AuthFlowSuccess) {
        context.go('/');
      } else if (next is AuthFlowNeedsProfile) {
        context.go('/auth/profile');
      } else if (next is AuthFlowError) {
        _clearInputs();
      }
    });

    String maskedEmail = '';
    String? name;
    String? avatarUrl;

    if (state is AuthFlowGoogleOtpPending) {
      maskedEmail = state.maskedEmail;
      name = state.name;
      avatarUrl = state.avatarUrl;
    } else if (state is AuthFlowEmailOtpPending) {
      maskedEmail = state.email;
    } else if (state is AuthFlowError) {
      // keep showing previous info
    }

    final isBlocked = state is AuthFlowError && state.code == 'blocked';
    final isExpired = state is AuthFlowError && state.code == 'expired';
    final isLoading = state is AuthFlowLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/auth/welcome'),
        ),
        title: Text('Tasdiqlash kodi',
            style: GoogleFonts.sora(
                fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Avatar / icon
              if (avatarUrl != null)
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(avatarUrl),
                )
              else
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email_outlined,
                      color: Colors.white, size: 32),
                ),

              const SizedBox(height: 20),

              if (name != null) ...[
                Text(name,
                    style: GoogleFonts.sora(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.primary)),
                const SizedBox(height: 4),
              ],

              Text(
                'Kod $maskedEmail ga yuborildi',
                style: GoogleFonts.inter(
                    fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final hasError = state is AuthFlowError;
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
                        color: hasError ? Colors.red : null,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: hasError
                            ? Colors.red.shade50
                            : isDark
                                ? Colors.white.withAlpha(13)
                                : Colors.grey.shade50,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: hasError
                                ? Colors.red.shade300
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

              // Status messages
              if (isLoading)
                const CircularProgressIndicator()
              else if (state is AuthFlowError) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        state.message,
                        style: GoogleFonts.inter(
                            fontSize: 13, color: Colors.red.shade700),
                        textAlign: TextAlign.center,
                      ),
                      if (state.attemptsLeft != null)
                        Text(
                          '${state.attemptsLeft} ta urinish qoldi',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.red.shade500,
                              fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Resend button
              if (!isBlocked)
                TextButton(
                  onPressed: _resendCountdown == 0 && !isLoading
                      ? () {
                          notifier.resendOtp();
                          _startCountdown();
                          _clearInputs();
                        }
                      : null,
                  child: Text(
                    _resendCountdown > 0
                        ? 'Qayta yuborish (${_resendCountdown}s)'
                        : 'Qayta yuborish',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _resendCountdown == 0
                            ? AppTheme.accent
                            : Colors.grey.shade400),
                  ),
                ),

              if (isBlocked)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '30 daqiqa bloklandingiz. Keyinroq urinib ko\'ring.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.orange.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (isExpired) ...[
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () {
                    notifier.resendOtp();
                    _startCountdown();
                    _clearInputs();
                  },
                  child: const Text('Yangi kod so\'rash'),
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
