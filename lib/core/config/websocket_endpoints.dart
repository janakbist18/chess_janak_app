import 'env.dart';

/// WebSocket endpoints configuration
class WebSocketEndpoints {
  static const String baseUrl = Env.wsBaseUrl;

  // Channel paths
  static const String gameRoom = '/game/{roomId}';
  static const String chat = '/chat/{roomId}';
  static const String videoCall = '/call/{roomId}';
  static const String notifications = '/notifications';
  static const String presence = '/presence';
}
