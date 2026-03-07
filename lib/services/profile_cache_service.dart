import 'package:hive_flutter/hive_flutter.dart';

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/utils/storage_keys.dart';

/// Persists and reads profile JSON via Hive [StorageKeys.userBox].
/// Ensure the box is opened (e.g. in SplashService) before calling.
class ProfileCacheService {
  ProfileCacheService._();

  /// Returns cached profile if present and valid; otherwise null.
  static ProfileModel? getCachedProfile() {
    try {
      if (!Hive.isBoxOpen(StorageKeys.userBox)) return null;
      final box = Hive.box<dynamic>(StorageKeys.userBox);
      final value = box.get(StorageKeys.cachedProfile);
      if (value is! Map) return null;
      return ProfileModel.fromJson(Map<String, dynamic>.from(value));
    } catch (_) {
      return null;
    }
  }

  /// Saves profile to cache. No-op if [profile] is null.
  static Future<void> saveCachedProfile(ProfileModel? profile) async {
    if (profile == null) return;
    try {
      final box = await Hive.openBox<dynamic>(StorageKeys.userBox);
      await box.put(StorageKeys.cachedProfile, profile.toJson());
    } catch (_) {
      // Best effort; ignore cache write errors
    }
  }

  /// Clears cached profile (e.g. on sign out).
  static Future<void> clearCachedProfile() async {
    try {
      if (!Hive.isBoxOpen(StorageKeys.userBox)) return;
      final box = Hive.box<dynamic>(StorageKeys.userBox);
      await box.delete(StorageKeys.cachedProfile);
    } catch (_) {
      // Best effort
    }
  }
}
