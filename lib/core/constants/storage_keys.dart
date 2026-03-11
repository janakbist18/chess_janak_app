/// Storage keys for local and secure storage
class StorageKeys {
  // Auth
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';

  // User preferences
  static const String userLanguage = 'user_language';
  static const String themeMode = 'theme_mode';
  static const String soundEnabled = 'sound_enabled';
  static const String notificationsEnabled = 'notifications_enabled';

  // Game preferences
  static const String lastSelectedTimeControl = 'last_time_control';
  static const String favoriteOpponents = 'favorite_opponents';

  // Cache
  static const String cachedUser = 'cached_user';
  static const String cachedMatches = 'cached_matches';
}
