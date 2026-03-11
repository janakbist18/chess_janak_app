import 'app_config.dart';

class WebsocketEndpoints {
  const WebsocketEndpoints._();

  static String roomSocket({
    required String roomId,
    required String accessToken,
  }) {
    return '${AppConfig.wsBaseUrl}/ws/room/$roomId/?token=$accessToken';
  }
}