part of '../home_screen.dart';

class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav();

  static const List<_NavItemData> _items = [
    _NavItemData(icon: Icons.task_alt_rounded, label: 'TASKS'),
    _NavItemData(icon: Icons.map_outlined, label: 'MAP'),
    _NavItemData(icon: Icons.person_outline_rounded, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.only(
            top: _HomeDimens.navBarPaddingTop,
            left: _HomeDimens.navBarPaddingH,
            right: _HomeDimens.navBarPaddingH,
            bottom: _HomeDimens.navBarPaddingBottom,
          ),
          constraints: const BoxConstraints(minHeight: _HomeDimens.navBarHeight),
          decoration: BoxDecoration(
            color: Skin.color(Co.cardSurface),
            border: Border(
              top: BorderSide(
                color: Skin.color(Co.homeNavBarBorder),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = provider.currentTab.index == index;
              return _NavLink(
                icon: item.icon,
                label: item.label,
                isSelected: isSelected,
                onTap: () {
                  context.read<HomeProvider>().switchTab(AppTab.values[index]);
                },
              );
            }),
          ),
        );
      },
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? Skin.color(Co.primary) : Skin.color(Co.homeNavIconInactive);
    final labelColor = isSelected ? Skin.color(Co.primary) : Skin.color(Co.homeNavIconInactive);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _HomeDimens.navBarIconSize, color: iconColor),
          const SizedBox(height: _HomeDimens.navBarIconLabelGap),
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: _HomeDimens.navBarFontSize,
              fontWeight: FontWeight.w700,
              height: 15 / 10,
              letterSpacing: 0.5,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
