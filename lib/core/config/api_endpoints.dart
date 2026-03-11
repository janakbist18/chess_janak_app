import 'env.dart';

/// API endpoints configuration
class ApiEndpoints {
  static const String baseUrl = Env.apiBaseUrl;

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String googleSignIn = '/auth/google-signin';
  static const String refreshToken = '/auth/refresh-token';

  // Profile endpoints
  static const String getProfile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String uploadAvatar = '/profile/avatar';

  // Rooms endpoints
  static const String createRoom = '/rooms/create';
  static const String joinRoom = '/rooms/join';
  static const String getRooms = '/rooms';
  static const String getRoomDetails = '/rooms/{roomId}';
  static const String leaveRoom = '/rooms/{roomId}/leave';

  // Match endpoints
  static const String getMatches = '/matches';
  static const String getMatchDetails = '/matches/{matchId}';
  static const String getMatchHistory = '/matches/history';
}
