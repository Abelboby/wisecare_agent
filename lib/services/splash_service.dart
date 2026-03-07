import 'package:hive_flutter/hive_flutter.dart';

import 'package:wisecare_agent/utils/storage_keys.dart';

/// Progress callback: 0.0 to 1.0.
typedef SplashProgressCallback = void Function(double progress);

/// Splash initialization: Hive, prefs, etc.
class SplashService {
  Future<void> initialize({SplashProgressCallback? onProgress}) async {
    try {
      onProgress?.call(0.0);
      await Hive.initFlutter();
      onProgress?.call(0.33);
      await Hive.openBox<dynamic>(StorageKeys.settingsBox);
      onProgress?.call(0.66);
      await Hive.openBox<dynamic>(StorageKeys.userBox);
      onProgress?.call(1.0);
    } catch (_) {
      onProgress?.call(1.0);
    }
  }
}
