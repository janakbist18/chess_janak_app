import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/app_providers.dart';
import 'theme_persistence.dart';

final themePersistenceProvider = Provider<ThemePersistence>((ref) {
  final prefs = ref.watch(sharedPrefsServiceReadyProvider);
  return ThemePersistence(prefs);
});

// Simple notifier for theme mode
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
