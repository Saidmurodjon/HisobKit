import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../../features/auth/providers/auth_flow_provider.dart';
import 'sync_service.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum SyncStatus { idle, pushing, pulling, success, error }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncAt;
  final String? errorMessage;

  const SyncState({
    this.status = SyncStatus.idle,
    this.lastSyncAt,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncAt,
    String? errorMessage,
  }) =>
      SyncState(
        status: status ?? this.status,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        errorMessage: errorMessage,
      );

  bool get isBusy =>
      status == SyncStatus.pushing || status == SyncStatus.pulling;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncService _service;
  final _SettingsStore _store;

  SyncNotifier(this._service, this._store) : super(const SyncState()) {
    _loadLastSync();
  }

  Future<void> _loadLastSync() async {
    final ms = await _store.getLastSyncMs();
    if (ms != null) {
      state = state.copyWith(
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
      );
    }
  }

  Future<void> _saveLastSync(DateTime dt) =>
      _store.setLastSyncMs(dt.millisecondsSinceEpoch);

  /// Barcha ma'lumotlarni serverga yuboradi.
  Future<void> push() async {
    if (state.isBusy) return;
    state = state.copyWith(status: SyncStatus.pushing, errorMessage: null);
    try {
      final syncedAt = await _service.pushAll();
      await _saveLastSync(syncedAt);
      state = state.copyWith(status: SyncStatus.success, lastSyncAt: syncedAt);
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: 'Push xatosi: ${_friendlyError(e)}',
      );
    }
  }

  /// Serverdan ma'lumotlarni yuklaydi va local bazaga birlashtiradi.
  Future<void> pull() async {
    if (state.isBusy) return;
    state = state.copyWith(status: SyncStatus.pulling, errorMessage: null);
    try {
      final syncedAt = await _service.pullAll();
      await _saveLastSync(syncedAt);
      state = state.copyWith(status: SyncStatus.success, lastSyncAt: syncedAt);
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: 'Pull xatosi: ${_friendlyError(e)}',
      );
    }
  }

  void clearError() {
    if (state.status == SyncStatus.error) {
      state = state.copyWith(status: SyncStatus.idle);
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Token')) {
      return 'Tizimga kirishingiz kerak';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Internet aloqasi yo\'q';
    }
    if (msg.contains('TimeoutException') || msg.contains('timeout')) {
      return 'Ulanish vaqti tugadi';
    }
    return 'Serverda xato yuz berdi';
  }
}

// ── Settings store (uses Drift AppSettings table) ─────────────────────────────

class _SettingsStore {
  final dynamic _dao; // SettingsDao

  _SettingsStore(this._dao);

  Future<int?> getLastSyncMs() async {
    final v = await _dao.getValue('last_sync_at_ms') as String?;
    return v != null ? int.tryParse(v) : null;
  }

  Future<void> setLastSyncMs(int ms) =>
      _dao.setValue('last_sync_at_ms', ms.toString());
}

// ── Providers ─────────────────────────────────────────────────────────────────

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.read(databaseProvider);
  final api = ref.read(authApiServiceProvider);
  return SyncService(db: db, api: api);
});

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final service = ref.read(syncServiceProvider);
  final db = ref.read(databaseProvider);
  final store = _SettingsStore(db.settingsDao);
  return SyncNotifier(service, store);
});
