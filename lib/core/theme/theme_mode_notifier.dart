import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/app_providers.dart';
import 'theme_persistence.dart';

final themePersistenceProvider = Provider<ThemePersistence>((ref) {
  final prefs = ref.watch(sharedPrefsServiceReadyProvider);
  return ThemePersistence(prefs);
});

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final persistence = ref.watch(themePersistenceProvider);
  return ThemeModeNotifier(persistence)..loadTheme();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._themePersistence) : super(ThemeMode.system);

  final ThemePersistence _themePersistence;

  Future<void> loadTheme() async {
    state = await _themePersistence.loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _themePersistence.saveThemeMode(mode);
  }
}