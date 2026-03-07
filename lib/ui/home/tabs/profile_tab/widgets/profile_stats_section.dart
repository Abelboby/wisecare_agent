part of '../profile_tab_screen.dart';

class _ProfileStatsSection extends StatelessWidget {
  const _ProfileStatsSection({required this.tasksCount});

  final int tasksCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ProfileStatCard(
          label: 'Tasks',
          value: '$tasksCount',
        ),
        const SizedBox(width: 12),
        const _ProfileStatCard(
          label: 'Avg Resp',
          value: '4.2m',
        ),
        const SizedBox(width: 12),
        const _ProfileStatCard(
          label: 'Rating',
          value: '4.9',
          showStar: true,
        ),
      ],
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.label,
    required this.value,
    this.showStar = false,
  });

  final String label;
  final String value;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Skin.color(Co.cardSurface),
          border: Border.all(color: Skin.color(Co.homeCardBorder)),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                color: Skin.color(Co.homeStatsLabel),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                if (showStar) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: Skin.color(Co.profileStarRating),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
