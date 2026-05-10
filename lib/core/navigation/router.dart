import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

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
import '../../features/debts/islamic_contract_screen.dart';
import '../../features/debts/trust/add_contact_screen.dart';
import '../../features/debts/trust/send_debt_screen.dart';
import '../../features/debts/trust/incoming_requests_screen.dart';
import '../../features/debts/trust/debt_verification_screen.dart';
import '../../features/debts/trust/debt_audit_screen.dart';
import '../database/app_database.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/export/export_screen.dart';
import '../../features/house/house_dashboard_screen.dart';
import '../../features/house/add_house_expense_screen.dart';
import '../../features/house/settlement_screen.dart';
import '../../features/house/shopping_list_screen.dart';
import '../../features/house/house_members_screen.dart';
import '../../features/house/house_sync_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/email_input_screen.dart';
import '../../features/auth/screens/otp_verify_screen.dart';
import '../../features/auth/screens/profile_setup_screen.dart';

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

      // Auth flow routes
      GoRoute(
        path: '/auth/welcome',
        builder: (ctx, _) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth/email',
        builder: (ctx, _) => const EmailInputScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (ctx, _) => const OtpVerifyScreen(),
      ),
      GoRoute(
        path: '/auth/profile',
        builder: (ctx, _) => const ProfileSetupScreen(),
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
            path: '/house',
            builder: (ctx, _) => const HouseDashboardScreen(),
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
      // Trust system routes — must be BEFORE /debts/:id to match correctly
      GoRoute(
        path: '/debts/contacts/add',
        builder: (ctx, _) => const AddContactScreen(),
      ),
      GoRoute(
        path: '/debts/incoming',
        builder: (ctx, _) => const IncomingRequestsScreen(),
      ),
      GoRoute(
        path: '/debts/:id',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DebtDetailScreen(debtId: id);
        },
      ),
      GoRoute(
        path: '/debts/:id/send',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SendDebtScreen(debtId: id);
        },
      ),
      GoRoute(
        path: '/debts/:id/verify',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DebtVerificationScreen(debtId: id);
        },
      ),
      GoRoute(
        path: '/debts/:id/audit',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DebtAuditScreen(debtId: id);
        },
      ),
      GoRoute(
        path: '/export',
        builder: (ctx, _) => const ExportScreen(),
      ),
      GoRoute(
        path: '/debts/:id/contract',
        builder: (ctx, state) {
          final debt = state.extra as Debt;
          return IslamicContractScreen(debt: debt);
        },
      ),

      // House sub-routes
      GoRoute(
        path: '/house/add-expense',
        builder: (ctx, state) {
          final groupId = state.extra as int? ?? 0;
          return AddHouseExpenseScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/house/settlement',
        builder: (ctx, state) {
          final groupId = state.extra as int? ?? 0;
          return SettlementScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/house/shopping',
        builder: (ctx, state) {
          final groupId = state.extra as int? ?? 0;
          return ShoppingListScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/house/members',
        builder: (ctx, state) {
          final groupId = state.extra as int? ?? 0;
          return HouseMembersScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/house/sync',
        builder: (ctx, state) {
          final groupId = state.extra as int? ?? 0;
          return HouseSyncScreen(groupId: groupId);
        },
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/'); break;
            case 1: context.go('/transactions'); break;
            case 2: context.go('/reports'); break;
            case 3: context.go('/debts'); break;
            case 4: context.go('/settings'); break;
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Asosiy',
          ),
          const NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: "O'tkazma",
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Hisobot',
          ),
          const NavigationDestination(
            icon: Icon(Icons.handshake_outlined),
            selectedIcon: Icon(Icons.handshake),
            label: 'Qarz',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
