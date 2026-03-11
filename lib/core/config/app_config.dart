import 'env.dart';

class AppConfig {
  const AppConfig._();

  static String get appName => Env.appName;
  static String get apiBaseUrl => Env.apiBaseUrl;
  static String get webBaseUrl => Env.webBaseUrl;
  static String get wsBaseUrl => Env.wsBaseUrl;
}