import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/storage/shared_prefs_service.dart';
import '../../core/websocket/socket_client.dart';
import '../../core/theme/theme_mode_notifier.dart';
import '../../core/theme/theme_persistence.dart';

/// Central location for all app providers
class AppProviders {
  // Network providers
  static final apiClient = apiClientProvider;
  static final socketClient = socketClientProvider;

  // Storage providers
  static final secureStorage = secureStorageProvider;
  static final sharedPrefs = sharedPrefsProvider;

  // Theme providers
  static final themeMode = themeModeProvider;
  static final themePersistence = themePersistenceProvider;
}
