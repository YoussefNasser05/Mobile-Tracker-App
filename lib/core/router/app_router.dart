import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/subscriptions/add_edit_subscription_screen.dart';
import '../../screens/subscriptions/subscription_detail_screen.dart';
import '../../screens/subscriptions/subscription_list_screen.dart';
import '../../widgets/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey();

GoRouter buildRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, _) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          int index = 0;
          final loc = state.matchedLocation;
          if (loc.startsWith('/subscriptions')) index = 1;
          if (loc.startsWith('/settings')) index = 2;
          return MainScaffold(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/subscriptions',
            builder: (_, _) => const SubscriptionListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, _) => const AddEditSubscriptionScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) => SubscriptionDetailScreen(
                  subscriptionId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => AddEditSubscriptionScreen(
                      subscriptionId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
