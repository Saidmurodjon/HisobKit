import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../models/auth_state.dart';
import '../../../core/theme/app_theme.dart';

class EmailInputScreen extends ConsumerStatefulWidget {
  const EmailInputScreen({super.key});

  @override
  ConsumerState<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends ConsumerState<EmailInputScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

    ref.listen<AuthFlowState>(authFlowProvider, (_, next) {
      if (next is AuthFlowEmailOtpPending) {
        context.go('/auth/otp');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            notifier.goBack();
            context.go('/auth/welcome');
          },
        ),
        title: Text('Email bilan kirish',
            style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
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
                const SizedBox(height: 16),
                Text(
                  'Email manzilingizni kiriting',
                  style: GoogleFonts.sora(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ushbu emailga 6 xonali tasdiqlash kodi yuboriladi.',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  style: GoogleFonts.inter(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'misol@gmail.com',
                    prefixIcon: const Icon(Icons.email_outlined,
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
                      borderSide: const BorderSide(
                          color: AppTheme.accent, width: 2),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withAlpha(13)
                        : const Color(0xFFF8FAFC),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email kiritilmagan';
                    final reg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!reg.hasMatch(v.trim())) return 'Email formati noto\'g\'ri';
                    return null;
                  },
                ),

                if (state is AuthFlowError) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(state.message,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.red.shade700)),
                      ),
                    ]),
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
                              notifier.sendEmailOtp(_controller.text.trim());
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
                        : Text('Davom etish',
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
