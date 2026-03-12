import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  const SharedPrefsService(this._prefs);

  final SharedPreferences _prefs;

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  Future<bool> clear() {
    return _prefs.clear();
  }
}
