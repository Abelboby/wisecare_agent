part of '../tasks_tab_screen.dart';

class _TasksCompletedTodaySection extends StatelessWidget {
  const _TasksCompletedTodaySection();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final stats = provider.completedToday ??
            const CompletedTodayModel(tasksCount: 5, distanceKm: 12);
        return Container(
          padding: const EdgeInsets.all(_TasksTabDimens.statsSectionPadding),
          decoration: BoxDecoration(
            color: Skin.color(Co.homeCompletedSectionBg),
            border: Border.all(
              color: Skin.color(Co.homeCompletedSectionBorder),
            ),
            borderRadius: BorderRadius.circular(_TasksTabDimens.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMPLETED TODAY',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                  letterSpacing: 1.4,
                  color: Skin.color(Co.primary),
                ),
              ),
              const SizedBox(height: _TasksTabDimens.statsSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _StatsCard(
                      icon: Icons.check_circle_rounded,
                      iconBgColor: Skin.color(Co.homeStatsTasksBg),
                      iconColor: Skin.color(Co.homeStatsTasksIcon),
                      value: '${stats.tasksCount}',
                      label: 'TASKS',
                    ),
                  ),
                  const SizedBox(width: _TasksTabDimens.statsSectionGap),
                  Expanded(
                    child: _StatsCard(
                      icon: Icons.route_rounded,
                      iconBgColor: Skin.color(Co.homeStatsDistanceBg),
                      iconColor: Skin.color(Co.homeStatsDistanceIcon),
                      value: '${stats.distanceKm.toInt()}km',
                      label: 'DISTANCE',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_TasksTabDimens.statsCardPadding),
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: _TasksTabDimens.statsIconSize,
            height: _TasksTabDimens.statsIconSize,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: _TasksTabDimens.statsCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: GoogleFonts.lexend(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 28 / 20,
                    color: Skin.color(Co.loginHeading),
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 15 / 10,
                    color: Skin.color(Co.homeStatsLabel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
