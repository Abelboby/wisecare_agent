part of '../task_details_screen.dart';

/// Task detail header (no overlay; content flows below).
class _TaskDetailHeader extends StatelessWidget {
  const _TaskDetailHeader({
    required this.taskId,
    required this.assignedSubtitle,
    required this.onBack,
  });

  final String taskId;
  final String assignedSubtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Skin.color(Co.homeHeaderBg),
        border: Border(
          bottom: BorderSide(color: Skin.color(Co.loginContactBorder), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(9999),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Skin.color(Co.loginContactBorder),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Skin.color(Co.loginLabel),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Request #$taskId',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 22 / 18,
                    color: Skin.color(Co.loginHeading),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  assignedSubtitle,
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 15 / 10,
                    letterSpacing: -0.25,
                    color: Skin.color(Co.primary),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
