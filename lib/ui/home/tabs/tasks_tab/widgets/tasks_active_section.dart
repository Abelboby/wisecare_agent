part of '../tasks_tab_screen.dart';

class _TasksActiveSection extends StatelessWidget {
  const _TasksActiveSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final newCount = provider.newTasksCount;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Tasks',
              style: GoogleFonts.lexend(
                fontSize: _TasksTabDimens.sectionTitleSize,
                fontWeight: FontWeight.w700,
                height: _TasksTabDimens.sectionTitleHeight / _TasksTabDimens.sectionTitleSize,
                letterSpacing: -0.6,
                color: Skin.color(Co.loginHeading),
              ),
            ),
            if (newCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: _TasksTabDimens.badgePaddingV,
                  horizontal: _TasksTabDimens.badgePaddingH,
                ),
                decoration: BoxDecoration(
                  color: Skin.color(Co.primary),
                  borderRadius:
                      BorderRadius.circular(_TasksTabDimens.badgeRadius),
                ),
                child: Text(
                  '$newCount NEW',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 16 / 12,
                    color: Skin.color(Co.onPrimary),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
