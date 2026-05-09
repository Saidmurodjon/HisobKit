import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../models/auth_state.dart';
import '../../../core/theme/app_theme.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = ref.read(authFlowProvider);
    if (state is AuthFlowNeedsProfile && state.googleName != null) {
      _controller.text = state.googleName!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final isLoading = state is AuthFlowLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String? avatarUrl;
    if (state is AuthFlowNeedsProfile) avatarUrl = state.avatarUrl;

    ref.listen<AuthFlowState>(authFlowProvider, (_, next) {
      if (next is AuthFlowSuccess) context.go('/');
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil sozlash',
            style: GoogleFonts.sora(
                fontSize: 18, fontWeight: FontWeight.w700)),
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
                const SizedBox(height: 20),

                Center(
                  child: avatarUrl != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(avatarUrl),
                        )
                      : Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.accent],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_outline,
                              color: Colors.white, size: 48),
                        ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Ismingizni kiriting',
                  style: GoogleFonts.sora(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bu ism ilovada sizni aks ettiradi.',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _controller,
                  autofocus: true,
                  style: GoogleFonts.inter(fontSize: 16),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'To\'liq ism',
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppTheme.accent),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.5),
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
                    if (v == null || v.trim().isEmpty) return 'Ism kiritilmagan';
                    if (v.trim().length < 2) return 'Ism kamida 2 harf bo\'lsin';
                    return null;
                  },
                ),

                if (state is AuthFlowError) ...[
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: Colors.red.shade600)),
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
                              notifier
                                  .submitProfile(_controller.text.trim());
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text('Boshlash',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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
