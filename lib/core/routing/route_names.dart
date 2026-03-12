class RouteNames {
  const RouteNames._();

  // Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otp-verify';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Dashboard routes
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Room routes
  static const String createRoom = '/create-room';
  static const String joinRoom = '/join-room';
  static const String waitingRoom = '/waiting-room';

  // Chess routes
  static const String gameRoom = '/game-room/:gameId';
  static const String findGame = '/find-game';
  static const String gameHistory = '/game-history/:playerId';
  static const String leaderboard = '/leaderboard';
  static const String playerProfile = '/player-profile/:playerId';
}
