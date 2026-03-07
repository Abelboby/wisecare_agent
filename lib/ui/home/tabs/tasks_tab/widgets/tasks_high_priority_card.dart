part of '../tasks_tab_screen.dart';

class _TasksHighPriorityCard extends StatelessWidget {
  const _TasksHighPriorityCard({required this.task});

  final AgentTaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        border: Border(
          left: BorderSide(
            color: Skin.color(Co.homePriorityHigh),
            width: _TasksTabDimens.cardBorderLeftHigh,
          ),
        ),
        borderRadius: BorderRadius.circular(_TasksTabDimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Skin.color(Co.primary).withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
            spreadRadius: -3,
          ),
          BoxShadow(
            color: Skin.color(Co.primary).withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: _TasksTabDimens.mapHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Skin.color(Co.homeCardBorder),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(_TasksTabDimens.cardRadius),
                  ),
                ),
                child: task.mapImageUrl != null && task.mapImageUrl!.isNotEmpty
                    ? Image.network(
                        task.mapImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _mapPlaceholder(),
                      )
                    : _mapPlaceholder(),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Skin.color(Co.homePriorityHigh),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    'EMERGENCY',
                    style: GoogleFonts.lexend(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 15 / 10,
                      letterSpacing: 1,
                      color: Skin.color(Co.onPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(_TasksTabDimens.cardContentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.subtitle ?? 'HIGH PRIORITY',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 16 / 12,
                    letterSpacing: 0.6,
                    color: Skin.color(Co.homePriorityHigh),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: Skin.color(Co.loginHeading),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 22 / 18,
                          color: Skin.color(Co.loginHeading),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _TasksTabDimens.cardContentGap),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Skin.color(Co.loginSubtitle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.location ?? 'Location not set',
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: Skin.color(Co.loginSubtitle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _TasksTabDimens.cardContentGap),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Skin.color(Co.primary),
                      foregroundColor: Skin.color(Co.onPrimary),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(_TasksTabDimens.buttonRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.navigation_rounded,
                          size: 16,
                          color: Skin.color(Co.onPrimary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Accept & Navigate',
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 24 / 16,
                            color: Skin.color(Co.onPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPlaceholder() {
    return Center(
      child: Icon(
        Icons.map_outlined,
        size: 48,
        color: Skin.color(Co.loginSubtitle),
      ),
    );
  }
}
