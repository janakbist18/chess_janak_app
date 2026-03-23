import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

/// Settings controller
class SettingsController extends StateNotifier<Map<String, dynamic>> {
  SettingsController()
      : super({
          'soundEnabled': true,
          'notificationsEnabled': true,
          'themeMode': 'light',
        });

  void toggleSound() {
    state = {...state, 'soundEnabled': !(state['soundEnabled'] as bool)};
  }

  void toggleNotifications() {
    state = {
      ...state,
      'notificationsEnabled': !(state['notificationsEnabled'] as bool),
    };
  }

  void setThemeMode(String mode) {
    state = {...state, 'themeMode': mode};
  }
}

/// Provider for settings controller
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, Map<String, dynamic>>((ref) {
  return SettingsController();
});
