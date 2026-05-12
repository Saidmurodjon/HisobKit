import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_flow_provider.dart';
import '../services/auth_api_service.dart';
import '../services/token_service.dart';
import '../models/user_model.dart';

// ── State ─────────────────────────────────────────────────────────────────────
enum _TgStep { enterEmail, otpSent, done }

class _TgOtpState {
  final _TgStep step;
  final String email;
  final bool loading;
  final String? error;
  final int expiresIn;

  const _TgOtpState({
    this.step = _TgStep.enterEmail,
    this.email = '',
    this.loading = false,
    this.error,
    this.expiresIn = 300,
  });

  _TgOtpState copyWith({
    _TgStep? step,
    String? email,
    bool? loading,
    String? error,
    int? expiresIn,
  }) =>
      _TgOtpState(
        step: step ?? this.step,
        email: email ?? this.email,
        loading: loading ?? this.loading,
        error: error,
        expiresIn: expiresIn ?? this.expiresIn,
      );
}

// ── Screen ────────────────────────────────────────────────────────────────────
class TelegramOtpScreen extends ConsumerStatefulWidget {
  const TelegramOtpScreen({super.key});

  @override
  ConsumerState<TelegramOtpScreen> createState() => _TelegramOtpScreenState();
}

class _TelegramOtpScreenState extends ConsumerState<TelegramOtpScreen> {
  _TgOtpState _state = const _TgOtpState();

  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // ── Send OTP via Telegram ─────────────────────────────────────────────────
  Future<void> _sendOtp() async {
    if (!(_emailKey.currentState?.validate() ?? false)) return;
    setState(() => _state = _state.copyWith(loading: true, error: null));

    final api = ref.read(authApiServiceProvider);
    try {
      final res = await api.telegramSendOtp(_emailCtrl.text.trim());
      setState(() => _state = _state.copyWith(
            step: _TgStep.otpSent,
            email: _emailCtrl.text.trim().toLowerCase(),
            loading: false,
            expiresIn: res['expiresIn'] as int? ?? 300,
          ));
    } on DioException catch (e) {
      final data = e.response?.data as Map<String, dynamic>?;
      final msg = data?['error'] as String?;
      if (msg != null && msg.contains('bog\'lanmagan')) {
        setState(() => _state = _state.copyWith(
              loading: false,
              error:
                  'Bu email Telegram ga bog\'lanmagan.\nAvval ilovada Telegram ni bog\'lang.',
            ));
      } else {
        setState(() =>
            _state = _state.copyWith(loading: false, error: msg ?? 'Xato'));
      }
    } catch (e) {
      setState(() => _state = _state.copyWith(loading: false, error: '$e'));
    }
  }

  // ── Verify OTP ────────────────────────────────────────────────────────────
  Future<void> _verifyOtp() async {
    if (!(_otpKey.currentState?.validate() ?? false)) return;
    setState(() => _state = _state.copyWith(loading: true, error: null));

    final api = ref.read(authApiServiceProvider);
    final tokens = ref.read(tokenServiceProvider);

    try {
      final res = await api.telegramVerifyOtp(
        email: _state.email,
        otp: _otpCtrl.text.trim(),
        displayName:
            _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : null,
      );

      if (res['code'] == 'needs_profile') {
        setState(
            () => _state = _state.copyWith(loading: false, error: null));
        // Show name field
        _showNameDialog();
        return;
      }

      final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
      await tokens.saveTokens(
        access: res['accessToken'] as String,
        refresh: res['refreshToken'] as String,
      );
      await tokens.saveUser(user);

      setState(
          () => _state = _state.copyWith(loading: false, step: _TgStep.done));

      if (mounted) context.go('/');
    } on DioException catch (e) {
      final data = e.response?.data as Map<String, dynamic>?;
      setState(() => _state = _state.copyWith(
            loading: false,
            error: data?['error'] as String? ?? 'Kod noto\'g\'ri',
          ));
    } catch (e) {
      setState(() => _state = _state.copyWith(loading: false, error: '$e'));
    }
  }

  void _showNameDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ismingizni kiriting'),
        content: TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'To\'liq ism',
            prefixIcon: Icon(Icons.person),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Bekor'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _verifyOtp();
            },
            child: const Text('Davom'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram orqali kirish'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Telegram logo / header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0088CC).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.telegram, size: 56, color: Color(0xFF0088CC)),
                  const SizedBox(height: 12),
                  Text(
                    _state.step == _TgStep.enterEmail
                        ? 'Email kiritingki, Telegram kodini oling'
                        : 'Telegram ga kod yuborildi',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_state.step == _TgStep.otpSent) ...[
                    const SizedBox(height: 4),
                    Text(
                      '📱 ${_state.email}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Step 1: Email
            if (_state.step == _TgStep.enterEmail)
              Form(
                key: _emailKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email shart';
                        if (!v.contains('@')) return 'Email noto\'g\'ri';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _state.loading ? null : _sendOtp,
                      icon: _state.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send),
                      label: Text(
                          _state.loading ? 'Yuborilmoqda...' : 'Telegram kod olish'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFF0088CC),
                      ),
                    ),
                  ],
                ),
              ),

            // Step 2: OTP
            if (_state.step == _TgStep.otpSent)
              Form(
                key: _otpKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 8),
                      decoration: const InputDecoration(
                        labelText: 'Telegram kodi',
                        hintText: '000000',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.length != 6) return '6 raqamli kod kiriting';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_state.expiresIn ~/ 60} daqiqa amal qiladi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _state.loading ? null : _verifyOtp,
                      icon: _state.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check),
                      label: Text(_state.loading ? 'Tekshirilmoqda...' : 'Tasdiqlash'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          setState(() => _state = _state.copyWith(
                                step: _TgStep.enterEmail,
                                error: null,
                              )),
                      child: const Text('Emailni o\'zgartirish'),
                    ),
                  ],
                ),
              ),

            // Error message
            if (_state.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _state.error!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Help text
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Text('Telegram ga qanday bog\'lash?',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '1. Sozlamalar → Hisobim → Telegram bog\'lash\n'
                    '2. Tugmani bosing va botni oching\n'
                    '3. /start komandasini yuboring\n'
                    '4. Qaytib keling va bu ekrandan kiring',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
