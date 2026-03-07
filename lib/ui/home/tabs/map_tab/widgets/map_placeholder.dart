part of '../map_tab_screen.dart';

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.map_outlined,
          size: _MapTabDimens.iconSize,
          color: Skin.color(Co.loginSubtitle),
        ),
        const SizedBox(height: _MapTabDimens.gapAfterIcon),
        Text(
          'Map',
          style: GoogleFonts.lexend(
            fontSize: _MapTabDimens.titleFontSize,
            fontWeight: FontWeight.w700,
            color: Skin.color(Co.loginHeading),
          ),
        ),
        const SizedBox(height: _MapTabDimens.gapAfterTitle),
        Text(
          'Map view coming soon',
          style: GoogleFonts.lexend(
            fontSize: _MapTabDimens.subtitleFontSize,
            color: Skin.color(Co.loginSubtitle),
          ),
        ),
      ],
    );
  }
}
