import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../providers/onboarding_page_provider.dart';
import '../models/auth_state.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/theme/app_theme.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final isLoading = state is AuthLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthFlowState>(authFlowProvider, (_, next) async {
      if (next is AuthSuccess) {
        if (!context.mounted) return;
        ref.read(authProvider.notifier).unlock();
        final onboardingDone =
            ref.read(appSettingsProvider).value?.onboardingComplete ?? false;
        if (!onboardingDone) {
          // Return to onboarding at security page (page 2)
          ref.read(onboardingPageProvider.notifier).state = 2;
          context.go('/onboarding');
        } else {
          context.go('/');
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profilni to\'ldiring',
          style:
              GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.accent],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.person_outline,
                        size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Ismingizni kiriting',
                  style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.primary),
                ),
                const SizedBox(height: 6),
                Text(
                  'Bu ism ilovada sizni aks ettiradi.',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameCtrl,
                  autofocus: true,
                  style: GoogleFonts.inter(fontSize: 16),
                  textCapitalization: TextCapitalization.words,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: 'To\'liq ism',
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppTheme.accent),
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
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ism kiritilmagan';
                    }
                    if (v.trim().length < 2) {
                      return 'Ism kamida 2 harf bo\'lsin';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (_formKey.currentState!.validate()) {
                      notifier.submitProfile(_nameCtrl.text.trim());
                    }
                  },
                ),

                if (state is AuthError) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.red.shade400),
                  ),
                ],

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              notifier.submitProfile(_nameCtrl.text.trim());
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
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
                            'Keyingi',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
