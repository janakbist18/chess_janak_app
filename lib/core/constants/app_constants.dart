/// App-wide constants
class AppConstants {
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts (in seconds)
  static const int apiTimeout = 30;
  static const int wsTimeout = 60;

  // Game settings
  static const int gameTimePerMove = 300; // 5 minutes in seconds
  static const int minPlayersPerRoom = 2;
  static const int maxPlayersPerRoom = 2;

  // Storage
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String refreshTokenKey = 'refresh_token';
}
