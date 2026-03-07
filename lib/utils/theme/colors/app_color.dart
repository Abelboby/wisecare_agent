import 'package:flutter/material.dart';

/// One semantic color token with three concrete colors (light, grayscale, dark).
class AppColor {
  const AppColor({
    required this.light,
    required this.dark,
    required this.grayscale,
  });

  final Color light;
  final Color dark;
  final Color grayscale;
}

/// Semantic color tokens. Use with Skin.color(Co.xxx).
class Co {
  Co._();

  static const AppColor primary = AppColor(
    light: Color(0xFFFF6933),
    dark: Color(0xFFFF6933),
    grayscale: Color(0xFF424242),
  );

  static const AppColor secondary = AppColor(
    light: Color(0xFF625B71),
    dark: Color(0xFFCCC2DC),
    grayscale: Color(0xFF616161),
  );

  static const AppColor background = AppColor(
    light: Color(0xFFFFFBFE),
    dark: Color(0xFF1C1B1F),
    grayscale: Color(0xFFFAFAFA),
  );

  static const AppColor surface = AppColor(
    light: Color(0xFFFFFBFE),
    dark: Color(0xFF1C1B1F),
    grayscale: Color(0xFFFAFAFA),
  );

  static const AppColor error = AppColor(
    light: Color(0xFFB3261E),
    dark: Color(0xFFF2B8B5),
    grayscale: Color(0xFF757575),
  );

  static const AppColor onPrimary = AppColor(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFFFFFFFF),
    grayscale: Color(0xFFFFFFFF),
  );

  static const AppColor onSecondary = AppColor(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF332D41),
    grayscale: Color(0xFFFFFFFF),
  );

  static const AppColor onBackground = AppColor(
    light: Color(0xFF1C1B1F),
    dark: Color(0xFFE6E1E5),
    grayscale: Color(0xFF1E1E1E),
  );

  static const AppColor onSurface = AppColor(
    light: Color(0xFF1C1B1F),
    dark: Color(0xFFE6E1E5),
    grayscale: Color(0xFF1E1E1E),
  );

  static const AppColor onError = AppColor(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF601410),
    grayscale: Color(0xFFFFFFFF),
  );

  static const AppColor navyBrand = AppColor(
    light: Color(0xFF1F234D),
    dark: Color(0xFF1F234D),
    grayscale: Color(0xFF37474F),
  );

  static const AppColor gradientTop = AppColor(
    light: Color(0xFF1A1A2E),
    dark: Color(0xFF1A1A2E),
    grayscale: Color(0xFF1A1A2E),
  );

  static const AppColor gradientBottom = AppColor(
    light: Color(0xFF2D3561),
    dark: Color(0xFF2D3561),
    grayscale: Color(0xFF2D3561),
  );

  static const AppColor accentBlur = AppColor(
    light: Color(0xFF60A5FA),
    dark: Color(0xFF60A5FA),
    grayscale: Color(0xFF90A4AE),
  );

  static const AppColor warmBackground = AppColor(
    light: Color(0xFFF8F6F5),
    dark: Color(0xFF1C1B1F),
    grayscale: Color(0xFFFAFAFA),
  );

  static const AppColor loginHeader = AppColor(
    light: Color(0xFF0E1C36),
    dark: Color(0xFF0E1C36),
    grayscale: Color(0xFF37474F),
  );

  static const AppColor headerSubtitle = AppColor(
    light: Color(0xFFDBEAFE),
    dark: Color(0xFFDBEAFE),
    grayscale: Color(0xFF90A4AE),
  );

  static const AppColor cardSurface = AppColor(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF2D2D2D),
    grayscale: Color(0xFFFAFAFA),
  );

  static const AppColor textMuted = AppColor(
    light: Color(0xFF63504B),
    dark: Color(0xFFB0A8A4),
    grayscale: Color(0xFF757575),
  );

  static const AppColor outline = AppColor(
    light: Color(0xFFE5E7EB),
    dark: Color(0xFF49454F),
    grayscale: Color(0xFFE0E0E0),
  );

  static const AppColor iconShield = AppColor(
    light: Color(0xFF354670),
    dark: Color(0xFF354670),
    grayscale: Color(0xFF4A5568),
  );

  static const AppColor splashSubtitle = AppColor(
    light: Color(0xE6FF6933),
    dark: Color(0xE6FF6933),
    grayscale: Color(0xE6FF6933),
  );

  static const AppColor splashLoadingLabel = AppColor(
    light: Color(0x66FFFFFF),
    dark: Color(0x66FFFFFF),
    grayscale: Color(0x66FFFFFF),
  );

  static const AppColor splashLoadingPercent = AppColor(
    light: Color(0x99FFFFFF),
    dark: Color(0x99FFFFFF),
    grayscale: Color(0x99FFFFFF),
  );

  static const AppColor splashStatusText = AppColor(
    light: Color(0x4DFFFFFF),
    dark: Color(0x4DFFFFFF),
    grayscale: Color(0x4DFFFFFF),
  );

  static const AppColor splashProgressTrack = AppColor(
    light: Color(0x1AFFFFFF),
    dark: Color(0x1AFFFFFF),
    grayscale: Color(0x1AFFFFFF),
  );

  static const AppColor splashLogoRingFill = AppColor(
    light: Color(0x0DFFFFFF),
    dark: Color(0x0DFFFFFF),
    grayscale: Color(0x0DFFFFFF),
  );

  static const AppColor splashLogoRingBorder = AppColor(
    light: Color(0x1AFFFFFF),
    dark: Color(0x1AFFFFFF),
    grayscale: Color(0x1AFFFFFF),
  );

  static const AppColor splashBlurOrangeTop = AppColor(
    light: Color(0x33FF6933),
    dark: Color(0x33FF6933),
    grayscale: Color(0x33FF6933),
  );

  static const AppColor splashBlurOrangeBottom = AppColor(
    light: Color(0x1AFF6933),
    dark: Color(0x1AFF6933),
    grayscale: Color(0x1AFF6933),
  );

  static const AppColor splashBadgeShadow = AppColor(
    light: Color(0x1A000000),
    dark: Color(0x1A000000),
    grayscale: Color(0x1A000000),
  );

  static const AppColor loginCardBorder = AppColor(
    light: Color(0xFFE2E8F0),
    dark: Color(0xFFE2E8F0),
    grayscale: Color(0xFFE2E8F0),
  );

  static const AppColor loginHeading = AppColor(
    light: Color(0xFF0F172A),
    dark: Color(0xFF0F172A),
    grayscale: Color(0xFF0F172A),
  );

  static const AppColor loginSubtitle = AppColor(
    light: Color(0xFF64748B),
    dark: Color(0xFF64748B),
    grayscale: Color(0xFF64748B),
  );

  static const AppColor loginInstruction = AppColor(
    light: Color(0xFF475569),
    dark: Color(0xFF475569),
    grayscale: Color(0xFF475569),
  );

  static const AppColor loginLabel = AppColor(
    light: Color(0xFF334155),
    dark: Color(0xFF334155),
    grayscale: Color(0xFF334155),
  );

  static const AppColor loginInputBg = AppColor(
    light: Color(0xFFF8FAFC),
    dark: Color(0xFFF8FAFC),
    grayscale: Color(0xFFF8FAFC),
  );

  static const AppColor loginInputBorder = AppColor(
    light: Color(0xFFE2E8F0),
    dark: Color(0xFFE2E8F0),
    grayscale: Color(0xFFE2E8F0),
  );

  static const AppColor loginPlaceholder = AppColor(
    light: Color(0xFF6B7280),
    dark: Color(0xFF6B7280),
    grayscale: Color(0xFF6B7280),
  );

  static const AppColor loginIconMuted = AppColor(
    light: Color(0xFF94A3B8),
    dark: Color(0xFF94A3B8),
    grayscale: Color(0xFF94A3B8),
  );

  static const AppColor loginContactBorder = AppColor(
    light: Color(0xFFF1F5F9),
    dark: Color(0xFFF1F5F9),
    grayscale: Color(0xFFF1F5F9),
  );

  static const AppColor loginFooterDivider = AppColor(
    light: Color(0xFF94A3B8),
    dark: Color(0xFF94A3B8),
    grayscale: Color(0xFF94A3B8),
  );

  static const AppColor loginFooterBrand = AppColor(
    light: Color(0xFF475569),
    dark: Color(0xFF475569),
    grayscale: Color(0xFF475569),
  );

  static const AppColor loginFooterDisclaimer = AppColor(
    light: Color(0xFF94A3B8),
    dark: Color(0xFF94A3B8),
    grayscale: Color(0xFF94A3B8),
  );

  static const AppColor loginLogoIconBg = AppColor(
    light: Color(0x1AFF6933),
    dark: Color(0x1AFF6933),
    grayscale: Color(0x1AFF6933),
  );

  static const AppColor loginButtonShadow = AppColor(
    light: Color(0x33FF6933),
    dark: Color(0x33FF6933),
    grayscale: Color(0x33FF6933),
  );
}
