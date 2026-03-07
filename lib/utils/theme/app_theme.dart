import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';
import 'package:wisecare_agent/utils/theme/typography/app_typography.dart';

/// Scroll behavior: mouse-drag scrolling on web so scrollables respond to all pointer devices.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => kIsWeb
      ? {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.invertedStylus,
        }
      : super.dragDevices;
}

/// Builds ThemeData from Skin and Co. Use commonThemeData in MaterialApp.
class AppTheme {
  AppTheme._();

  static ScrollBehavior get appScrollBehavior => AppScrollBehavior();

  static ThemeData get commonThemeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Skin.isDarkTheme.value ? Brightness.dark : Brightness.light,
      primaryColor: Skin.color(Co.primary),
      colorScheme: ColorScheme(
        brightness: Skin.isDarkTheme.value ? Brightness.dark : Brightness.light,
        primary: Skin.color(Co.primary),
        onPrimary: Skin.color(Co.onPrimary),
        secondary: Skin.color(Co.secondary),
        onSecondary: Skin.color(Co.onSecondary),
        error: Skin.color(Co.error),
        onError: Skin.color(Co.onError),
        surface: Skin.color(Co.surface),
        onSurface: Skin.color(Co.onSurface),
      ),
      scaffoldBackgroundColor: Skin.color(Co.background),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.resolveWith((_) => false),
        trackVisibility: WidgetStateProperty.resolveWith((_) => false),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge: AppTypography.titleLarge,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        labelLarge: AppTypography.labelLarge,
      ),
    );
  }
}
