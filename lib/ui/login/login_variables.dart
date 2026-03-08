part of 'login_screen.dart';

/// Login screen layout constants. Colors use [Co] in app_color.dart.
class _LoginDimens {
  _LoginDimens._();

  static const double screenPadding = 16;
  static const double cardMaxWidth = 440;
  static const double cardRadius = 24;
  static const double cardPaddingH = 32;
  static const double cardPaddingTop = 32;
  static const double cardPaddingBottom = 48;
  static const double headerIconSize = 72;
  static const double headerIconInner = 64;
  static const double gapAfterHeader = 16;
  static const double gapAfterTitle = 8;
  static const double gapSection = 24;
  static const double gapLabelField = 8;
  static const double gapBeforeButton = 24;
  static const double inputRadius = 16;
  static const double inputPaddingH = 16;
  static const double inputPaddingV = 13;
  static const double passwordIconSize = 22;
  static const double buttonHeight = 56;
  static const double buttonRadius = 16;
  static const double footerTop = 32;
  static const double footerDividerSpace = 16;
  static const double footerDisclaimerTop = 15;
}

/// Demo credentials for quick login (dev/demo only). Remove in production.
class _LoginDemoCredentials {
  _LoginDemoCredentials._();

  static const String email = 'night.agent@wisecare.com';
  static const String password = 'WiseCare@2024';

  /// Delay per character for demo typewriter animation (milliseconds).
  static const int typingDelayMs = 35;
}
