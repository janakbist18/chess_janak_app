import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

/// App routing configuration
class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: RouteNames.splash,
      routes: [
        // Splash
        GoRoute(
          path: RouteNames.splash,
          builder: (context, state) =>
              const SizedBox(), // Replace with SplashScreen
          name: 'splash',
        ),

        // Auth routes
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) =>
              const SizedBox(), // Replace with LoginScreen
          name: 'login',
        ),
        GoRoute(
          path: RouteNames.register,
          builder: (context, state) =>
              const SizedBox(), // Replace with RegisterScreen
          name: 'register',
        ),

        // Dashboard
        GoRoute(
          path: RouteNames.dashboard,
          builder: (context, state) =>
              const SizedBox(), // Replace with DashboardScreen
          name: 'dashboard',
        ),

        // Profile
        GoRoute(
          path: RouteNames.profile,
          builder: (context, state) =>
              const SizedBox(), // Replace with ProfileScreen
          name: 'profile',
        ),

        // Settings
        GoRoute(
          path: RouteNames.settings,
          builder: (context, state) =>
              const SizedBox(), // Replace with SettingsScreen
          name: 'settings',
        ),
      ],
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
    );
  }
}

/// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter();
});
