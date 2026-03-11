import 'package:flutter/material.dart';
import '../constants/storage_keys.dart';
import '../storage/shared_prefs_service.dart';

class ThemePersistence {
  const ThemePersistence(this._prefsService);

  final SharedPrefsService _prefsService;

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefsService.setString(StorageKeys.themeMode, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final value = _prefsService.getString(StorageKeys.themeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}