import 'package:hive_flutter/hive_flutter.dart';

import 'package:wisecare_agent/utils/storage_keys.dart';

/// Persists and reads auth tokens via Hive [StorageKeys.settingsBox].
/// Ensure the box is opened (e.g. in SplashService) before calling.
class AuthStorageService {
  AuthStorageService._();

  static String? getStoredAuthToken() {
    try {
      if (!Hive.isBoxOpen(StorageKeys.settingsBox)) return null;
      final box = Hive.box<dynamic>(StorageKeys.settingsBox);
      final value = box.get(StorageKeys.authToken);
      return value is String ? value : null;
    } catch (_) {
      return null;
    }
  }

  static String? getStoredRefreshToken() {
    try {
      if (!Hive.isBoxOpen(StorageKeys.settingsBox)) return null;
      final box = Hive.box<dynamic>(StorageKeys.settingsBox);
      final value = box.get(StorageKeys.refreshToken);
      return value is String ? value : null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> hasStoredAuthToken() async {
    final token = getStoredAuthToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveAuthTokens(String accessToken, [String? refreshToken]) async {
    try {
      final box = await Hive.openBox<dynamic>(StorageKeys.settingsBox);
      await box.put(StorageKeys.authToken, accessToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await box.put(StorageKeys.refreshToken, refreshToken);
      }
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> clearAuthTokens() async {
    try {
      if (!Hive.isBoxOpen(StorageKeys.settingsBox)) return;
      final box = Hive.box<dynamic>(StorageKeys.settingsBox);
      await box.delete(StorageKeys.authToken);
      await box.delete(StorageKeys.refreshToken);
    } catch (_) {
      rethrow;
    }
  }
}
