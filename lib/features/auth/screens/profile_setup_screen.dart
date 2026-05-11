import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_flow_provider.dart';
import '../models/auth_state.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/security/pin_service.dart';
import '../../../core/theme/app_theme.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _language = 'uz'; // uz | ru | en
  final _pinCtrl = TextEditingController();
  final _pinConfirmCtrl = TextEditingController();
  bool _pinVisible = false;
  bool _pinConfirmVisible = false;
  int _step = 0; // 0 = name+lang, 1 = pin

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _pinConfirmCtrl.dispose();
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
        // Save PIN to PinService (SHA-256 hash) so lock screen can verify it
        final pin = _pinCtrl.text.trim();
        if (pin.length == 6) {
          await PinService.setPin(pin);
        }
        // Cloud auth succeeded → also unlock device lock so no second login
        if (context.mounted) {
          ref.read(authProvider.notifier).unlock();
          context.go('/');
        }
      }
      // On error: isLoading becomes false automatically, error shown in UI
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_step == 0 ? 'Profilni to\'ldiring' : 'PIN kodini o\'rnating',
            style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: _step == 0
                ? _NameLangStep(
                    nameCtrl: _nameCtrl,
                    language: _language,
                    onLanguageChanged: (v) => setState(() => _language = v),
                    isDark: isDark,
                    isLoading: isLoading,
                    state: state,
                    onNext: () => setState(() => _step = 1),
                  )
                : _PinStep(
                    pinCtrl: _pinCtrl,
                    pinConfirmCtrl: _pinConfirmCtrl,
                    pinVisible: _pinVisible,
                    pinConfirmVisible: _pinConfirmVisible,
                    onTogglePin: () => setState(() => _pinVisible = !_pinVisible),
                    onTogglePinConfirm: () =>
                        setState(() => _pinConfirmVisible = !_pinConfirmVisible),
                    isDark: isDark,
                    isLoading: isLoading,
                    state: state,
                    onBack: () => setState(() => _step = 0),
                    onSubmit: () {
                      if (_formKey.currentState!.validate()) {
                        notifier.submitProfile(_nameCtrl.text.trim());
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _NameLangStep extends StatelessWidget {
  final TextEditingController nameCtrl;
  final String language;
  final void Function(String) onLanguageChanged;
  final bool isDark;
  final bool isLoading;
  final AuthFlowState state;
  final VoidCallback onNext;

  const _NameLangStep({
    required this.nameCtrl,
    required this.language,
    required this.onLanguageChanged,
    required this.isDark,
    required this.isLoading,
    required this.state,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Step indicator
        Row(children: [
          _StepDot(active: true),
          const SizedBox(width: 6),
          _StepDot(active: false),
        ]),
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
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 24),

        TextFormField(
          controller: nameCtrl,
          autofocus: true,
          style: GoogleFonts.inter(fontSize: 16),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'To\'liq ism',
            prefixIcon: const Icon(Icons.person_outline, color: AppTheme.accent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.accent, width: 2),
            ),
            filled: true,
            fillColor: isDark ? Colors.white.withAlpha(13) : const Color(0xFFF8FAFC),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Ism kiritilmagan';
            if (v.trim().length < 2) return 'Ism kamida 2 harf bo\'lsin';
            return null;
          },
        ),

        const SizedBox(height: 24),

        Text(
          'Til tanlang',
          style: GoogleFonts.sora(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppTheme.primary),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            _LangChip(
              label: 'O\'zbek',
              value: 'uz',
              selected: language == 'uz',
              onTap: () => onLanguageChanged('uz'),
              isDark: isDark,
            ),
            const SizedBox(width: 10),
            _LangChip(
              label: 'Рус',
              value: 'ru',
              selected: language == 'ru',
              onTap: () => onLanguageChanged('ru'),
              isDark: isDark,
            ),
            const SizedBox(width: 10),
            _LangChip(
              label: 'English',
              value: 'en',
              selected: language == 'en',
              onTap: () => onLanguageChanged('en'),
              isDark: isDark,
            ),
          ],
        ),

        if (state is AuthError) ...[
          const SizedBox(height: 12),
          Text((state as AuthError).message,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.red.shade400)),
        ],

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    if (nameCtrl.text.trim().length >= 2) {
                      onNext();
                    }
                  },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Keyingi',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class _PinStep extends StatelessWidget {
  final TextEditingController pinCtrl;
  final TextEditingController pinConfirmCtrl;
  final bool pinVisible;
  final bool pinConfirmVisible;
  final VoidCallback onTogglePin;
  final VoidCallback onTogglePinConfirm;
  final bool isDark;
  final bool isLoading;
  final AuthFlowState state;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const _PinStep({
    required this.pinCtrl,
    required this.pinConfirmCtrl,
    required this.pinVisible,
    required this.pinConfirmVisible,
    required this.onTogglePin,
    required this.onTogglePinConfirm,
    required this.isDark,
    required this.isLoading,
    required this.state,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _StepDot(active: false),
          const SizedBox(width: 6),
          _StepDot(active: true),
        ]),
        const SizedBox(height: 24),

        Text(
          'PIN kod o\'rnating',
          style: GoogleFonts.sora(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppTheme.primary),
        ),
        const SizedBox(height: 6),
        Text(
          'Keyingi kirişlarda PIN yoki biometrik ishlatiladi.',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 28),

        _PinField(
          controller: pinCtrl,
          label: 'PIN kod (6 raqam)',
          visible: pinVisible,
          onToggle: onTogglePin,
          isDark: isDark,
          validator: (v) {
            if (v == null || v.trim().length != 6) return '6 ta raqam kiriting';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _PinField(
          controller: pinConfirmCtrl,
          label: 'PIN ni tasdiqlang',
          visible: pinConfirmVisible,
          onToggle: onTogglePinConfirm,
          isDark: isDark,
          validator: (v) {
            if (v != pinCtrl.text) return 'PIN kodlar mos kelmadi';
            return null;
          },
        ),

        if (state is AuthError) ...[
          const SizedBox(height: 12),
          Text((state as AuthError).message,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.red.shade400)),
        ],

        const Spacer(),

        Row(children: [
          OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: isDark ? Colors.white30 : Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: Text('Orqaga',
                style: GoogleFonts.inter(
                    color: isDark ? Colors.white70 : AppTheme.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : onSubmit,
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
                    : Text('Boshlash',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}

class _PinField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool visible;
  final VoidCallback onToggle;
  final bool isDark;
  final String? Function(String?)? validator;

  const _PinField({
    required this.controller,
    required this.label,
    required this.visible,
    required this.onToggle,
    required this.isDark,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: GoogleFonts.sora(fontSize: 24, letterSpacing: 8),
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          onPressed: onToggle,
          color: Colors.grey.shade400,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.accent, width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(13) : const Color(0xFFF8FAFC),
      ),
      validator: validator,
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _LangChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary
              : isDark
                  ? Colors.white.withAlpha(18)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppTheme.primary
                : isDark
                    ? Colors.white24
                    : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  const _StepDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppTheme.accent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
