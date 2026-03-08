part of '../tasks_tab_screen.dart';

/// Active / History tabs below header. Figma: 54px height, border-bottom.
class _TasksTabBar extends StatelessWidget {
  const _TasksTabBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _TasksTabDimens.tabsHeight,
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        border: Border(
          bottom: BorderSide(
            color: Skin.color(Co.primary).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              label: 'Active',
              isSelected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _TabItem(
              label: 'History',
              isSelected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Skin.color(Co.primary) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 21 / 14,
              color: isSelected ? Skin.color(Co.primary) : Skin.color(Co.loginSubtitle),
            ),
          ),
        ),
      ),
    );
  }
}
