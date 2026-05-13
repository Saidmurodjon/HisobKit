import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_flow_provider.dart';
import '../services/token_service.dart';
import '../models/user_model.dart';

// ── State ─────────────────────────────────────────────────────────────────────
enum _TgStep { idle, waitingConfirm, confirmed, expired, error }

class _TgState {
  final _TgStep step;
  final String code;
  final String deepLink;
  final bool loading;
  final String? errorMsg;
  final int secondsLeft;

  const _TgState({
    this.step = _TgStep.idle,
    this.code = '',
    this.deepLink = '',
    this.loading = false,
    this.errorMsg,
    this.secondsLeft = 300,
  });

  _TgState copyWith({
    _TgStep? step,
    String? code,
    String? deepLink,
    bool? loading,
    String? errorMsg,
    int? secondsLeft,
  }) =>
      _TgState(
        step: step ?? this.step,
        code: code ?? this.code,
        deepLink: deepLink ?? this.deepLink,
        loading: loading ?? this.loading,
        errorMsg: errorMsg,
        secondsLeft: secondsLeft ?? this.secondsLeft,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
class TelegramOtpScreen extends ConsumerStatefulWidget {
  const TelegramOtpScreen({super.key});

  @override
  ConsumerState<TelegramOtpScreen> createState() => _TelegramOtpScreenState();
}

class _TelegramOtpScreenState extends ConsumerState<TelegramOtpScreen> {
  _TgState _s = const _TgState();
  Timer? _pollTimer;
  Timer? _countdownTimer;
  int _pollErrors = 0;

  @override
  void dispose() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── 1. Telegram login start ───────────────────────────────────────────────
  Future<void> _startTelegramLogin() async {
    setState(() => _s = _s.copyWith(loading: true, errorMsg: null));

    final api = ref.read(authApiServiceProvider);
    try {
      final res = await api.telegramLoginStart();
      final code = res['code'] as String;
      final deepLink = res['deepLink'] as String;
      final expiresIn = (res['expiresIn'] as int? ?? 300);

      setState(() => _s = _s.copyWith(
            step: _TgStep.waitingConfirm,
            code: code,
            deepLink: deepLink,
            loading: false,
            secondsLeft: expiresIn,
          ));

      // Telegram ilovasini ochish
      await _openTelegram(deepLink);

      // Polling va countdown ni boshlash
      _startPolling(code);
      _startCountdown(expiresIn);
    } on DioException catch (e) {
      final msg =
          (e.response?.data as Map<String, dynamic>?)?['error'] as String? ??
              'Server bilan bog\'lanib bo\'lmadi';
      setState(() => _s = _s.copyWith(loading: false, errorMsg: msg));
    } catch (e) {
      setState(() => _s = _s.copyWith(loading: false, errorMsg: '$e'));
    }
  }

  // ── 2. Telegram ilovasini ochish ─────────────────────────────────────────
  Future<void> _openTelegram(String deepLink) async {
    // Avval Telegram ilovasini ochishga harakat qilamiz
    final tgUri = Uri.parse(deepLink.replaceFirst('https://t.me/', 'tg://resolve?domain=HisobKitBot&start=').replaceAll('?start=', '&start='));
    final webUri = Uri.parse(deepLink);

    try {
      if (await canLaunchUrl(tgUri)) {
        await launchUrl(tgUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  // ── 3. Polling — har 2 sekundda tekshirish ────────────────────────────────
  void _startPolling(String code) {
    _pollErrors = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!mounted) {
        _pollTimer?.cancel();
        return;
      }
      await _checkConfirmation(code);
    });
  }

  Future<void> _checkConfirmation(String code) async {
    final api = ref.read(authApiServiceProvider);
    try {
      final res = await api.telegramCheckLogin(code);
      final status = res['status'] as String? ?? 'pending';

      if (status == 'confirmed') {
        _pollTimer?.cancel();
        _countdownTimer?.cancel();
        await _handleConfirmed(res);
      } else if (status == 'expired') {
        _pollTimer?.cancel();
        _countdownTimer?.cancel();
        if (mounted) {
          setState(() => _s = _s.copyWith(step: _TgStep.expired));
        }
      }
      // 'pending' → davom etish
    } catch (_) {
      _pollErrors++;
      if (_pollErrors >= 10) {
        // 10 ta xato ketma-ket → to'xtatish
        _pollTimer?.cancel();
        if (mounted) {
          setState(() => _s = _s.copyWith(
                step: _TgStep.error,
                errorMsg: 'Internet aloqasi uzildi. Qaytadan urinib ko\'ring.',
              ));
        }
      }
    }
  }

  Future<void> _handleConfirmed(Map<String, dynamic> res) async {
    final tokens = ref.read(tokenServiceProvider);
    final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
    await tokens.saveTokens(
      access: res['accessToken'] as String,
      refresh: res['refreshToken'] as String,
    );
    await tokens.saveUser(user);

    if (mounted) {
      setState(() => _s = _s.copyWith(step: _TgStep.confirmed));
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) context.go('/');
    }
  }

  // ── 4. Countdown ──────────────────────────────────────────────────────────
  void _startCountdown(int seconds) {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final left = _s.secondsLeft - 1;
      if (left <= 0) {
        _countdownTimer?.cancel();
        _pollTimer?.cancel();
        setState(() => _s = _s.copyWith(step: _TgStep.expired, secondsLeft: 0));
      } else {
        setState(() => _s = _s.copyWith(secondsLeft: left));
      }
    });
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void _reset() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    setState(() => _s = const _TgState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram orqali kirish'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _pollTimer?.cancel();
            _countdownTimer?.cancel();
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0088CC).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.telegram, size: 64, color: Color(0xFF0088CC)),
          const SizedBox(height: 12),
          Text(
            _headerText(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          if (_s.step == _TgStep.waitingConfirm) ...[
            const SizedBox(height: 8),
            Text(
              'Telegram ilovasi ochildimi? Bot xabari kuting.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  String _headerText() {
    switch (_s.step) {
      case _TgStep.idle:
        return 'Telegramda bir tugma bilan kiring';
      case _TgStep.waitingConfirm:
        return 'Telegram botda "✅ Tasdiqlash" tugmasini bosing';
      case _TgStep.confirmed:
        return '✅ Tasdiqlandi! Kirmoqdasiz...';
      case _TgStep.expired:
        return '⏰ Vaqt tugadi. Qaytadan urinib ko\'ring.';
      case _TgStep.error:
        return '❌ Xatolik yuz berdi';
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (_s.step) {
      case _TgStep.idle:
        return _buildIdleStep();
      case _TgStep.waitingConfirm:
        return _buildWaitingStep();
      case _TgStep.confirmed:
        return _buildConfirmedStep();
      case _TgStep.expired:
        return _buildExpiredStep();
      case _TgStep.error:
        return _buildErrorStep();
    }
  }

  // ── Idle: "Telegram orqali kirish" tugmasi ────────────────────────────────
  Widget _buildIdleStep() {
    return Column(
      children: [
        if (_s.errorMsg != null) ...[
          _ErrorBox(msg: _s.errorMsg!),
          const SizedBox(height: 20),
        ],
        FilledButton.icon(
          onPressed: _s.loading ? null : _startTelegramLogin,
          icon: _s.loading
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.telegram, size: 22),
          label: Text(_s.loading ? 'Yuklanmoqda...' : 'Telegram orqali kirish'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            backgroundColor: const Color(0xFF0088CC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 32),
        _buildHowItWorks(),
      ],
    );
  }

  // ── Waiting: ochilgan, polling ketmoqda ───────────────────────────────────
  Widget _buildWaitingStep() {
    final mins = _s.secondsLeft ~/ 60;
    final secs = _s.secondsLeft % 60;
    final timeStr = '$mins:${secs.toString().padLeft(2, '0')}';

    return Column(
      children: [
        // Animated waiting indicator
        const SizedBox(height: 8),
        const _PulsingDot(),
        const SizedBox(height: 16),
        Text(
          'Bot xabari kutilmoqda...',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          '⏱ $timeStr qoldi',
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.primary),
        ),
        const SizedBox(height: 24),

        // Re-open Telegram button
        OutlinedButton.icon(
          onPressed: () => _openTelegram(_s.deepLink),
          icon: const Icon(Icons.open_in_new, size: 18),
          label: const Text('Telegram ni qayta ochish'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
            foregroundColor: const Color(0xFF0088CC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),

        TextButton(
          onPressed: _reset,
          child: Text('Bekor qilish',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ),

        const SizedBox(height: 24),
        _buildSteps(),
      ],
    );
  }

  Widget _buildSteps() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Qanday qilish kerak?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          SizedBox(height: 8),
          _Step(n: '1', text: 'Telegram ilovasi ochildi → @HisobKitBot da xabar keladi'),
          _Step(n: '2', text: '"✅ Tasdiqlash" tugmasini bosing'),
          _Step(n: '3', text: 'Ilova avtomatik kiradi ✓'),
        ],
      ),
    );
  }

  // ── Confirmed ─────────────────────────────────────────────────────────────
  Widget _buildConfirmedStep() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: AppTheme.accent.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: AppTheme.accent, size: 48),
        ),
        const SizedBox(height: 16),
        const Text('Kirish tasdiqlandi!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Bosh ekranga yo\'naltirilmoqda...',
            style: TextStyle(color: Colors.grey.shade500)),
        const SizedBox(height: 20),
        const LinearProgressIndicator(),
      ],
    );
  }

  // ── Expired ───────────────────────────────────────────────────────────────
  Widget _buildExpiredStep() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Icon(Icons.timer_off, size: 56, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text('Vaqt tugadi (5 daqiqa)',
            style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          label: const Text('Qaytadan urinish'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFF0088CC),
          ),
        ),
      ],
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  Widget _buildErrorStep() {
    return Column(
      children: [
        if (_s.errorMsg != null) _ErrorBox(msg: _s.errorMsg!),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          label: const Text('Qaytadan urinish'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.info_outline, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text('Qanday ishlaydi?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          const _Step(n: '1', text: 'Tugmani bosing → Telegram ilovasi ochiladi'),
          const _Step(n: '2', text: '@HisobKitBot dan kirish so\'rovi keladi'),
          const _Step(n: '3', text: '"✅ Tasdiqlash" ni bosing → Ilova o\'zi kiradi'),
          const SizedBox(height: 8),
          Text(
            '⚠️ Ishlashi uchun avval ilovada Telegram ni bog\'langan bo\'lishi kerak\n'
            '(Sozlamalar → Telegram bog\'lash)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _ErrorBox extends StatelessWidget {
  final String msg;
  const _ErrorBox({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(msg,
                  style: const TextStyle(color: Colors.red, fontSize: 13))),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String n;
  final String text;
  const _Step({required this.n, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(
                color: Color(0xFF0088CC), shape: BoxShape.circle),
            child: Center(
              child: Text(n,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 16, height: 16,
        decoration: const BoxDecoration(
            color: Color(0xFF0088CC), shape: BoxShape.circle),
      ),
    );
  }
}
