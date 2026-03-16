class Env {
  const Env._();

  static const String appName = 'Chess Janak';

  /// Django Backend URLs
  /// Web/Chrome: http://127.0.0.1:8000 (or http://localhost:8000)
  /// Android Emulator: 10.0.2.2 (special alias for host machine)
  /// Android Device: Use your local IP (e.g., 192.168.1.100)
  /// Production: Use your deployed domain (e.g., https://api.example.com)

  // ✅ For Web (Chrome/Firefox): http://127.0.0.1:8000
  // For Android Emulator: http://10.0.2.2:8000
  // For Physical Device: http://YOUR_LOCAL_IP:8000
  static const String apiBaseUrl = 'http://127.0.0.1:8000/api';
  static const String webBaseUrl = 'http://127.0.0.1:8000';
  static const String wsBaseUrl = 'ws://127.0.0.1:8000';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
