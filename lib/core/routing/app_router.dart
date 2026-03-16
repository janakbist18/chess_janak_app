import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_verify_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/chess/presentation/screens/game_room_screen.dart';
import '../../features/chess/presentation/screens/game_history_screen.dart';
import '../../features/chess/presentation/screens/leaderboard_screen.dart';
import '../../features/chess/presentation/screens/player_profile_screen.dart';
import '../../features/chess/presentation/screens/find_game_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/rooms/presentation/screens/create_room_screen.dart';
import '../../features/rooms/presentation/screens/join_room_screen.dart';
import '../../features/rooms/presentation/screens/waiting_room_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Auth routes
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.otpVerify,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return OtpVerifyScreen(email: email);
        },
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      // Dashboard routes
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      // Room routes
      GoRoute(
        path: RouteNames.createRoom,
        builder: (context, state) => const CreateRoomScreen(),
      ),
      GoRoute(
        path: RouteNames.joinRoom,
        builder: (context, state) => const JoinRoomScreen(),
      ),
      GoRoute(
        path: RouteNames.waitingRoom,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId'] ?? '';
          return WaitingRoomScreen(roomId: roomId);
        },
      ),
      // Chess routes
      GoRoute(
        path: '/game-room/:gameId',
        builder: (context, state) => GameRoomScreen(
          gameId: state.pathParameters['gameId'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteNames.findGame,
        builder: (context, state) => const FindGameScreen(),
      ),
      GoRoute(
        path: '/game-history/:playerId',
        builder: (context, state) => GameHistoryScreen(
          playerId: state.pathParameters['playerId'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteNames.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/player-profile/:playerId',
        builder: (context, state) => PlayerProfileScreen(
          playerId: state.pathParameters['playerId'] ?? '',
        ),
      ),
    ],
  );
});
