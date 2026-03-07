part of '../tasks_tab_screen.dart';

class _TasksMediumPriorityCard extends StatelessWidget {
  const _TasksMediumPriorityCard({required this.task});

  final AgentTaskModel task;

  @override
  Widget build(BuildContext context) {
    final detailLine = _buildDetailLine();
    return Container(
      padding: const EdgeInsets.all(_TasksTabDimens.mediumCardPadding),
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        border: Border.all(color: Skin.color(Co.homeCardBorder)),
        borderRadius: BorderRadius.circular(_TasksTabDimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.subtitle ?? 'MEDIUM PRIORITY',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 16 / 12,
                    letterSpacing: 0.6,
                    color: Skin.color(Co.homePriorityMedium),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.title,
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 20 / 16,
                    color: Skin.color(Co.loginHeading),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detailLine,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: Skin.color(Co.loginSubtitle),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Skin.color(Co.homeCardBorder),
                      foregroundColor: Skin.color(Co.loginHeading),
                      padding: const EdgeInsets.symmetric(
                        horizontal: _TasksTabDimens.viewDetailsButtonPaddingH,
                        vertical: _TasksTabDimens.viewDetailsButtonPaddingV,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(_TasksTabDimens.buttonRadius),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 20 / 14,
                        color: Skin.color(Co.loginHeading),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _TasksTabDimens.mediumCardGap),
          Container(
            width: _TasksTabDimens.mediumCardImageSize,
            height: _TasksTabDimens.mediumCardImageSize,
            decoration: BoxDecoration(
              color: Skin.color(Co.homeCardBorder),
              borderRadius:
                  BorderRadius.circular(_TasksTabDimens.mediumCardImageRadius),
            ),
            child: task.productImageUrl != null &&
                    task.productImageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(_TasksTabDimens.mediumCardImageRadius),
                    child: Image.network(
                      task.productImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    ),
                  )
                : _imagePlaceholder(),
          ),
        ],
      ),
    );
  }

  String _buildDetailLine() {
    final parts = <String>[];
    if (task.itemCount != null && task.itemCount! > 0) {
      parts.add('${task.itemCount} items');
    }
    if (task.scheduledAt != null && task.scheduledAt!.isNotEmpty) {
      parts.add('Scheduled for ${task.scheduledAt}');
    }
    return parts.isEmpty ? '—' : parts.join(' • ');
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(
        Icons.medication_outlined,
        size: 40,
        color: Skin.color(Co.loginSubtitle),
      ),
    );
  }
}
