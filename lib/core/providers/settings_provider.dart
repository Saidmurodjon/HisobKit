import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class AppSettingsState {
  final String language;
  final String baseCurrency;
  final ThemeMode themeMode;
  final bool biometricsEnabled;
  final int autoLockMinutes;
  final bool onboardingComplete;

  const AppSettingsState({
    this.language = 'uz',
    this.baseCurrency = 'UZS',
    this.themeMode = ThemeMode.system,
    this.biometricsEnabled = false,
    this.autoLockMinutes = 5,
    this.onboardingComplete = false,
  });

  AppSettingsState copyWith({
    String? language,
    String? baseCurrency,
    ThemeMode? themeMode,
    bool? biometricsEnabled,
    int? autoLockMinutes,
    bool? onboardingComplete,
  }) =>
      AppSettingsState(
        language: language ?? this.language,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        themeMode: themeMode ?? this.themeMode,
        biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
        autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      );
}

class AppSettingsNotifier extends AsyncNotifier<AppSettingsState> {
  @override
  Future<AppSettingsState> build() async {
    final db = ref.watch(databaseProvider);
    final all = await db.settingsDao.getAllSettings();

    ThemeMode themeMode;
    switch (all['theme'] ?? 'system') {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return AppSettingsState(
      language: all['language'] ?? 'uz',
      baseCurrency: all['base_currency'] ?? 'UZS',
      themeMode: themeMode,
      biometricsEnabled: all['biometrics_enabled'] == 'true',
      autoLockMinutes: int.tryParse(all['auto_lock_minutes'] ?? '5') ?? 5,
      onboardingComplete: all['onboarding_complete'] == 'true',
    );
  }

  Future<void> setLanguage(String lang) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue('language', lang);
    state = AsyncData(state.value!.copyWith(language: lang));
  }

  Future<void> setBaseCurrency(String currency) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue('base_currency', currency);
    state = AsyncData(state.value!.copyWith(baseCurrency: currency));
  }

  Future<void> setTheme(ThemeMode mode) async {
    final db = ref.read(databaseProvider);
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      default:
        value = 'system';
    }
    await db.settingsDao.setValue('theme', value);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }

  Future<void> setBiometrics(bool enabled) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue('biometrics_enabled', enabled.toString());
    state = AsyncData(state.value!.copyWith(biometricsEnabled: enabled));
  }

  Future<void> setAutoLock(int minutes) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue('auto_lock_minutes', minutes.toString());
    state = AsyncData(state.value!.copyWith(autoLockMinutes: minutes));
  }

  Future<void> completeOnboarding() async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.setValue('onboarding_complete', 'true');
    state = AsyncData(state.value!.copyWith(onboardingComplete: true));
  }
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettingsState>(
  AppSettingsNotifier.new,
);
