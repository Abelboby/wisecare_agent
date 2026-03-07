import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:wisecare_agent/utils/storage_keys.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/enums/app_enums.dart';

/// Theme state via ValueNotifier. Persists mode in Hive (StorageKeys.themeBox).
/// Not a Provider — use ValueListenableBuilder or listen to themeMode.
class Skin {
  Skin._();

  static final ValueNotifier<AppThemeMode> themeMode =
      ValueNotifier<AppThemeMode>(AppThemeMode.light);

  static final ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);

  /// Returns the current color from [color] based on [themeMode].
  static Color color(AppColor color) {
    switch (themeMode.value) {
      case AppThemeMode.dark:
        return color.dark;
      case AppThemeMode.system:
        return color.grayscale;
      case AppThemeMode.light:
        return color.light;
    }
  }

  /// Returns [dark] when theme is dark, otherwise [light]. Grayscale treated as light.
  static Color colorSeparate(Color light, Color dark) {
    return themeMode.value == AppThemeMode.dark ? dark : light;
  }

  /// Loads saved theme from Hive into themeMode and isDarkTheme.
  static Future<void> retrieveTheme() async {
    try {
      final box = await Hive.openBox<int>(StorageKeys.themeBox);
      final index = box.get(StorageKeys.themeMode);
      if (index != null &&
          index >= 0 &&
          index < AppThemeMode.values.length) {
        themeMode.value = AppThemeMode.values[index];
        isDarkTheme.value = themeMode.value == AppThemeMode.dark;
      }
    } catch (_) {
      themeMode.value = AppThemeMode.light;
      isDarkTheme.value = false;
    }
  }

  /// Updates theme mode, persists to Hive, and syncs isDarkTheme.
  static Future<void> changeTheme({required AppThemeMode mode}) async {
    themeMode.value = mode;
    isDarkTheme.value = mode == AppThemeMode.dark;
    try {
      final box = await Hive.openBox<int>(StorageKeys.themeBox);
      await box.put(
        StorageKeys.themeMode,
        AppThemeMode.values.indexOf(mode),
      );
    } catch (_) {}
  }
}
