part of '../map_tab_screen.dart';

/// Map tab header: ACTIVE DUTY label and Agent View title (no notification/settings icons).
class _MapHeader extends StatelessWidget {
  const _MapHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: _MapTabDimens.headerPaddingTop,
        left: _MapTabDimens.headerPaddingH,
        right: _MapTabDimens.headerPaddingH,
        bottom: _MapTabDimens.headerPaddingBottom,
      ),
      decoration: BoxDecoration(
        color: Skin.color(Co.mapHeaderBg),
        border: Border(
          bottom: BorderSide(
            color: Skin.color(Co.mapHeaderBorder),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ACTIVE DUTY',
                style: GoogleFonts.lexend(
                  fontSize: _MapTabDimens.headerActiveDutyFontSize,
                  fontWeight: FontWeight.w700,
                  height: _MapTabDimens.headerActiveDutyHeight /
                      _MapTabDimens.headerActiveDutyFontSize,
                  letterSpacing: 1,
                  color: Skin.color(Co.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Agent View',
                style: GoogleFonts.lexend(
                  fontSize: _MapTabDimens.headerTitleFontSize,
                  fontWeight: FontWeight.w700,
                  height: _MapTabDimens.headerTitleHeight /
                      _MapTabDimens.headerTitleFontSize,
                  color: Skin.color(Co.mapAgentViewTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
