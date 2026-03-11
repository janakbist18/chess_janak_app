import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../constants/storage_keys.dart';

/// Service for persisting theme preference
class ThemePersistenceService {
  final SharedPreferences _prefs;

  ThemePersistenceService(this._prefs);

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode.toString());
  }

  ThemeMode getThemeMode() {
    final saved = _prefs.getString(StorageKeys.themeMode);
    if (saved == null) return ThemeMode.system;

    if (saved.contains('light')) return ThemeMode.light;
    if (saved.contains('dark')) return ThemeMode.dark;
    return ThemeMode.system;
  }
}

/// Provider for theme persistence service
final themePersistenceProvider = Provider<ThemePersistenceService>((ref) {
  throw UnimplementedError('Should be implemented in app_providers.dart');
});
