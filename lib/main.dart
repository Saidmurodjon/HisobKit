import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/database_provider.dart';
import 'core/navigation/router.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prefer portrait, allow landscape on tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize the encrypted database
  final db = await initDatabase();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const HisobKitApp(),
    ),
  );
}

class HisobKitApp extends ConsumerWidget {
  const HisobKitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(appSettingsProvider);

    final themeMode = settingsAsync.value?.themeMode ?? ThemeMode.system;
    final locale = settingsAsync.value?.language ?? 'uz';

    return GestureDetector(
      // Reset inactivity timer on any touch
      behavior: HitTestBehavior.translucent,
      onTap: () =>
          ref.read(authProvider.notifier).resetInactivityTimer(),
      onPanDown: (_) =>
          ref.read(authProvider.notifier).resetInactivityTimer(),
      child: MaterialApp.router(
        title: 'HisobKit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: router,
        locale: Locale(locale),
        supportedLocales: const [
          Locale('uz'),
          Locale('ru'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supported) {
          if (locale == null) return supported.first;
          for (final s in supported) {
            if (s.languageCode == locale.languageCode) return s;
          }
          return supported.first;
        },
      ),
    );
  }
}
