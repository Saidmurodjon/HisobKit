import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../models/auth_state.dart';
import '../../../core/theme/app_theme.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthFlowState>(authFlowProvider, (_, next) {
      if (next is AuthFlowGoogleOtpPending || next is AuthFlowEmailOtpPending) {
        context.go('/auth/otp');
      } else if (next is AuthFlowSuccess) {
        context.go('/');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF163A5E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),

              Text(
                'HisobKit',
                style: GoogleFonts.sora(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Moliyangizni nazorat qiling',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),

              const Spacer(flex: 3),

              // Google button
              if (state is AuthFlowLoading)
                const CircularProgressIndicator()
              else ...[
                _AuthButton(
                  onTap: () => notifier.signInWithGoogle(),
                  icon: _GoogleIcon(),
                  label: 'Google bilan kirish',
                  isPrimary: true,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('yoki',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade500)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 16),

                _AuthButton(
                  onTap: () => context.go('/auth/email'),
                  icon: const Icon(Icons.email_outlined,
                      color: AppTheme.primary, size: 22),
                  label: 'Email bilan kirish',
                  isPrimary: false,
                ),
              ],

              if (state is AuthFlowError) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(state.message,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.red.shade700)),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Kirish — Foydalanish shartlariga rozilik',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String label;
  final bool isPrimary;

  const _AuthButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isPrimary
          ? FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary)),
                ],
              ),
            ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                'G',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Arial',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
