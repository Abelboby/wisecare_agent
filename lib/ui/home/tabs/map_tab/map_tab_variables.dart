part of 'map_tab_screen.dart';

/// Map tab layout constants. Matches Figma Agent View design.
abstract final class _MapTabDimens {
  _MapTabDimens._();

  // Header (Figma: 92px height, padding 24/16/16)
  static const double headerHeight = 92;
  static const double headerPaddingTop = 24;
  static const double headerPaddingH = 16;
  static const double headerPaddingBottom = 16;
  static const double headerActiveDutyFontSize = 10;
  static const double headerActiveDutyHeight = 15;
  static const double headerTitleFontSize = 24;
  static const double headerTitleHeight = 32;

  // Map area (Figma: top 105px, bottom 96px)
  static const double mapOverlayButtonSize = 38;
  static const double mapOverlayGap = 8;
  static const double mapOverlayRight = 16;
  static const double mapOverlayTop = 16;
  static const double mapOverlayButtonRadius = 16;
  static const double mapOverlayIconSize = 22;

  // Bottom sheet (Figma: 314px height, 24px top radius)
  static const double sheetBorderRadius = 24;
  static const double sheetPaddingH = 24;
  static const double sheetPaddingBottom = 16;
  static const double sheetDragHandleWidth = 48;
  static const double sheetDragHandleHeight = 6;
  static const double sheetDragHandlePaddingV = 12;
  static const double sheetContentGap = 16;
  // Status & header
  static const double sheetStatusPillFontSize = 12;
  static const double sheetDetailTitleFontSize = 20;
  static const double sheetDetailTitleHeight = 25;
  static const double sheetDetailSubtitleFontSize = 16;
  static const double sheetDetailSubtitleHeight = 24;
  static const double sheetAvatarSize = 56;
  // Location card
  static const double sheetLocationCardRadius = 24;
  static const double sheetLocationCardPadding = 16;
  static const double sheetLocationIconSize = 48;
  static const double sheetAddressLine1FontSize = 16;
  static const double sheetAddressLine1Height = 24;
  static const double sheetAddressLine2FontSize = 14;
  static const double sheetAddressLine2Height = 20;
  // Action buttons
  static const double sheetCtaHeight = 64;
  static const double sheetCtaRadius = 24;
  static const double sheetCtaFontSize = 18;
  static const double sheetCtaFontHeight = 28;

  // Map style modal
  static const double sheetTitleFontSize = 18;
  static const double sheetTitleHeight = 28;
}
