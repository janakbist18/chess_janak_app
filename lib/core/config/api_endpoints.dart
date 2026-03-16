import 'app_config.dart';

class ApiEndpoints {
  const ApiEndpoints._();

  static String get base => AppConfig.apiBaseUrl;
  static String get wsBase => AppConfig.wsBaseUrl;

  static String get register => '$base/auth/register/';
  static String get verifyOtp => '$base/auth/verify-otp/';
  static String get resendOtp => '$base/auth/resend-otp/';
  static String get login => '$base/auth/login/';
  static String get forgotPassword => '$base/auth/forgot-password/';
  static String get resetPassword => '$base/auth/reset-password/';
  static String get googleSignIn => '$base/auth/google/';
  static String get me => '$base/auth/me/';
  static String get tokenRefresh => '$base/auth/token/refresh/';

  static String get createRoom => '$base/rooms/create/';
  static String get joinRoom => '$base/rooms/join/';
  static String get myRooms => '$base/rooms/mine/';
  static String roomDetail(String roomId) => '$base/rooms/$roomId/';
  static String inviteLookup(String inviteCode) =>
      '$base/rooms/invite/$inviteCode/';

  static String roomMatch(String roomId) => '$base/chess/room/$roomId/';
  static String roomMoves(String roomId) => '$base/chess/room/$roomId/moves/';

  static String get profiles => '$base/profiles/';
  static String profileDetail(String userId) => '$base/profiles/$userId/';
  static String profileAvatar(String userId) => '$base/profiles/$userId/avatar/';
}
