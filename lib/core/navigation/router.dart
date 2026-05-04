import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/lock_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/transactions/transactions_screen.dart';
import '../../features/transactions/add_transaction_screen.dart';
import '../../features/transactions/accounts_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/budgets/budgets_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/debts/debts_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/export/export_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

// ── Router Notifier ───────────────────────────────────────────────────────────
// ChangeNotifier that listens to auth + settings and notifies the GoRouter
// to re-evaluate its redirect — WITHOUT rebuilding the GoRouter itself.
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AppSettingsState>>(
      appSettingsProvider,
      (_, __) => notifyListeners(),
    );
    _ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final settingsAsync = _ref.read(appSettingsProvider);
    final authState = _ref.read(authProvider);

    final settings = settingsAsync.value;
    if (settings == null) return null; // Still loading — stay put

    final onboardingDone = settings.onboardingComplete;
    final isOnboarding = state.matchedLocation == '/onboarding';

    if (!onboardingDone) {
      return isOnboarding ? null : '/onboarding';
    }

    // Onboarding complete — if still on onboarding page, go to home
    if (isOnboarding) return '/';

    final isLocked = authState == AuthState.locked;
    final isLockScreen = state.matchedLocation == '/lock';

    if (isLocked && !isLockScreen) return '/lock';
    if (!isLocked && isLockScreen) return '/';

    return null;
  }
}

final _routerNotifierProvider = ChangeNotifierProvider<_RouterNotifier>((ref) {
  return _RouterNotifier(ref);
});

// ── Router Provider ───────────────────────────────────────────────────────────
// The GoRouter is created ONCE. State changes only trigger redirect re-eval
// via refreshListenable — they do NOT recreate the router.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (ctx, _) => const OnboardingScreen(),
      ),

      // Lock screen
      GoRoute(
        path: '/lock',
        builder: (ctx, _) => const LockScreen(),
      ),

      // Main shell with bottom nav
      ShellRoute(
        builder: (ctx, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (ctx, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/transactions',
            builder: (ctx, _) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (ctx, _) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/debts',
            builder: (ctx, _) => const DebtsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (ctx, _) => const SettingsScreen(),
          ),
        ],
      ),

      // Detail routes (pushed on top of shell)
      GoRoute(
        path: '/transactions/add',
        builder: (ctx, _) => const AddTransactionScreen(),
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AddTransactionScreen(transactionId: id);
        },
      ),
      GoRoute(
        path: '/accounts',
        builder: (ctx, _) => const AccountsScreen(),
      ),
      GoRoute(
        path: '/accounts/add',
        builder: (ctx, _) => const AccountsScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (ctx, _) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/budgets',
        builder: (ctx, _) => const BudgetsScreen(),
      ),
      GoRoute(
        path: '/budgets/add',
        builder: (ctx, _) => const BudgetsScreen(),
      ),
      GoRoute(
        path: '/debts/:id',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DebtDetailScreen(debtId: id);
        },
      ),
      GoRoute(
        path: '/export',
        builder: (ctx, _) => const ExportScreen(),
      ),
    ],
  );
});

// ── Main Shell (bottom navigation) ───────────────────────────────────────────
class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/transactions')) return 1;
    if (location.startsWith('/reports')) return 2;
    if (location.startsWith('/debts')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/transactions');
              break;
            case 2:
              context.go('/reports');
              break;
            case 3:
              context.go('/debts');
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.handshake_outlined),
            selectedIcon: Icon(Icons.handshake),
            label: 'Debts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
