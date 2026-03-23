class Env {
  const Env._();

  static const String appName = 'Chess Janak';

  /// Django Backend URLs
  /// Android Emulator: 10.0.2.2 (special alias for host machine)
  /// Physical Device: Use your local IP (e.g., 192.168.1.100)
  /// Production: Use your deployed domain (e.g., https://api.example.com)

  // Change 10.0.2.2 to your local IP for device testing
  // Example: http://192.168.1.100:8000
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api';
  static const String webBaseUrl = 'http://10.0.2.2:8000';
  static const String wsBaseUrl = 'ws://10.0.2.2:8000';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
