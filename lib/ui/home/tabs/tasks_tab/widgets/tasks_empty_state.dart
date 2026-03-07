part of '../tasks_tab_screen.dart';

/// Shown when the agent has no assigned tasks. Sets expectation that tasks will appear here.
class _TasksEmptyState extends StatelessWidget {
  const _TasksEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Skin.color(Co.primary).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 40,
                color: Skin.color(Co.primary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No tasks assigned yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 24 / 18,
                color: Skin.color(Co.loginHeading),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tasks will show up here when they’re assigned to you. Stay online to receive new requests.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                color: Skin.color(Co.loginSubtitle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
