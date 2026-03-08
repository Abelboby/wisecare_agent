part of '../tasks_tab_screen.dart';

/// Search bar and status filter chips. Figma: 16px padding, 12px gap.
class _TasksSearchFilter extends StatelessWidget {
  const _TasksSearchFilter({
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  static const String _filterAllActive = 'All Active';
  static const String _filterAssigned = 'Assigned';
  static const String _filterAccepted = 'Accepted';
  static const String _filterInProgress = 'In Progress';

  static const List<String> _filters = [
    _filterAllActive,
    _filterAssigned,
    _filterAccepted,
    _filterInProgress,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: _TasksTabDimens.searchHeight,
            decoration: BoxDecoration(
              color: Skin.color(Co.cardSurface),
              borderRadius: BorderRadius.circular(_TasksTabDimens.searchRadius),
              boxShadow: [
                BoxShadow(
                  color: Skin.color(Co.splashBadgeShadow),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search customer or ID',
                hintStyle: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 20 / 16,
                  color: Skin.color(Co.loginIconMuted),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: Skin.color(Co.loginIconMuted),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 20 / 16,
                color: Skin.color(Co.loginHeading),
              ),
            ),
          ),
          const SizedBox(height: _TasksTabDimens.searchFilterGap),
          SizedBox(
            height: _TasksTabDimens.filterChipHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = selectedFilter == filter;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onFilterChanged(filter),
                    borderRadius: BorderRadius.circular(_TasksTabDimens.filterChipRadius),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Skin.color(Co.primary) : Skin.color(Co.cardSurface),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: Skin.color(Co.primary).withValues(alpha: 0.1),
                                width: 1,
                              ),
                        borderRadius: BorderRadius.circular(_TasksTabDimens.filterChipRadius),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          color: isSelected ? Skin.color(Co.onPrimary) : Skin.color(Co.loginInstruction),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
