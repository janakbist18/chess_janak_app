class Env {
  const Env._();

  static const String appName = 'Chess Janak';

  // Android emulator -> 10.0.2.2
  // Physical device -> your laptop local IP, e.g. 192.168.1.5
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api';
  static const String webBaseUrl = 'http://10.0.2.2:8000';
  static const String wsBaseUrl = 'ws://10.0.2.2:8000';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}