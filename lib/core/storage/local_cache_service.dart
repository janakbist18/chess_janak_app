import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/app_providers.dart';
import 'shared_prefs_service.dart';

/// Service for local caching
class LocalCacheService {
  final SharedPrefsService _prefs;

  LocalCacheService(this._prefs);

  Future<void> cache<T>(String key, String value, {Duration? ttl}) async {
    await _prefs.setString(key, value);
    if (ttl != null) {
      await _prefs.setInt(
        '${key}_expiry',
        DateTime.now().add(ttl).millisecondsSinceEpoch,
      );
    }
  }

  String? getCache(String key) {
    final expiry = _prefs.getInt('${key}_expiry');
    if (expiry != null) {
      if (DateTime.now().millisecondsSinceEpoch > expiry) {
        _prefs.remove(key);
        _prefs.remove('${key}_expiry');
        return null;
      }
    }
    return _prefs.getString(key);
  }

  Future<void> clearCache(String key) async {
    await _prefs.remove(key);
    await _prefs.remove('${key}_expiry');
  }

  Future<void> clearAllCache() async {
    await _prefs.clear();
  }
}

/// Provider for local cache
final localCacheProvider = Provider<LocalCacheService>((ref) {
  final prefs = ref.watch(sharedPrefsServiceReadyProvider);
  return LocalCacheService(prefs);
});
