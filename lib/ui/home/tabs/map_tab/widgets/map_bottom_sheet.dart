part of '../map_tab_screen.dart';

/// Draggable bottom sheet with Active Requests title and task list.
class _MapBottomSheet extends StatelessWidget {
  const _MapBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.32,
      minChildSize: 0.2,
      maxChildSize: 0.65,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Skin.color(Co.cardSurface),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_MapTabDimens.sheetBorderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: _MapTabDimens.sheetDragHandlePaddingV,
                ),
                child: Center(
                  child: Container(
                    width: _MapTabDimens.sheetDragHandleWidth,
                    height: _MapTabDimens.sheetDragHandleHeight,
                    decoration: BoxDecoration(
                      color: Skin.color(Co.mapSheetDragHandle),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _MapTabDimens.sheetPaddingH,
                ),
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    final tasks = homeProvider.activeTasks;
                    final nearCount = tasks.length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Requests',
                          style: GoogleFonts.lexend(
                            fontSize: _MapTabDimens.sheetTitleFontSize,
                            fontWeight: FontWeight.w700,
                            height: _MapTabDimens.sheetTitleHeight / _MapTabDimens.sheetTitleFontSize,
                            color: Skin.color(Co.mapAgentViewTitle),
                          ),
                        ),
                        if (nearCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Skin.color(Co.mapSheetNearBadgeBg),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              '$nearCount NEAR YOU',
                              style: GoogleFonts.lexend(
                                fontSize: _MapTabDimens.sheetBadgeFontSize,
                                fontWeight: FontWeight.w700,
                                height: _MapTabDimens.sheetBadgeHeight / _MapTabDimens.sheetBadgeFontSize,
                                color: Skin.color(Co.primary),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: _MapTabDimens.sheetTasksPaddingTop),
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    final tasks = homeProvider.activeTasks;
                    if (tasks.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _MapTabDimens.sheetPaddingH,
                        ),
                        child: Center(
                          child: Text(
                            'No active requests',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              color: Skin.color(Co.loginSubtitle),
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        _MapTabDimens.sheetPaddingH,
                        0,
                        _MapTabDimens.sheetPaddingH,
                        _MapTabDimens.sheetPaddingBottom,
                      ),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: _MapTabDimens.sheetTasksGap),
                      itemBuilder: (context, index) {
                        return _MapTaskCard(task: tasks[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Single task row in the map bottom sheet. Emergency (SOS) vs normal styling.
class _MapTaskCard extends StatelessWidget {
  const _MapTaskCard({required this.task});

  final AgentTaskModel task;

  @override
  Widget build(BuildContext context) {
    final isEmergency = task.priority == AgentTaskPriority.high || task.type == AgentTaskType.sos;
    return Container(
      padding: const EdgeInsets.all(_MapTabDimens.taskCardPadding),
      decoration: BoxDecoration(
        color: isEmergency ? Skin.color(Co.mapEmergencyCardBg) : Skin.color(Co.mapTaskCardBg),
        border: Border.all(
          color: isEmergency ? Skin.color(Co.mapEmergencyCardBorder) : Skin.color(Co.mapTaskCardBorder),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(_MapTabDimens.taskCardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: _MapTabDimens.taskCardIconSize,
            height: _MapTabDimens.taskCardIconSize,
            decoration: BoxDecoration(
              color: isEmergency ? Skin.color(Co.mapMarkerSos) : Skin.color(Co.mapMarkerPharmacy),
              borderRadius: BorderRadius.circular(
                _MapTabDimens.taskCardIconRadius,
              ),
            ),
            child: Icon(
              isEmergency ? Icons.warning_amber_rounded : Icons.local_pharmacy_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: _MapTabDimens.taskCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        task.title,
                        style: GoogleFonts.lexend(
                          fontSize: _MapTabDimens.taskCardTitleFontSize,
                          fontWeight: FontWeight.w700,
                          height: _MapTabDimens.taskCardTitleHeight / _MapTabDimens.taskCardTitleFontSize,
                          color: Skin.color(Co.mapAgentViewTitle),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isEmergency) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Skin.color(Co.mapMarkerSos),
                          borderRadius: BorderRadius.circular(
                            _MapTabDimens.taskCardBadgeRadius,
                          ),
                        ),
                        child: Text(
                          'SOS',
                          style: GoogleFonts.lexend(
                            fontSize: _MapTabDimens.taskCardBadgeFontSize,
                            fontWeight: FontWeight.w700,
                            height: _MapTabDimens.taskCardBadgeHeight / _MapTabDimens.taskCardBadgeFontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitleText(),
                  style: GoogleFonts.lexend(
                    fontSize: _MapTabDimens.taskCardSubtitleFontSize,
                    fontWeight: FontWeight.w400,
                    height: _MapTabDimens.taskCardSubtitleHeight / _MapTabDimens.taskCardSubtitleFontSize,
                    color: Skin.color(Co.loginSubtitle),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _MapTabDimens.taskCardGap),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onActionTap(context),
              borderRadius: BorderRadius.circular(
                _MapTabDimens.taskCardButtonRadius,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isEmergency ? Skin.color(Co.mapMarkerSos) : Skin.color(Co.mapAgentViewTitle),
                  borderRadius: BorderRadius.circular(
                    _MapTabDimens.taskCardButtonRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  isEmergency ? 'Accept' : 'Details',
                  style: GoogleFonts.lexend(
                    fontSize: _MapTabDimens.taskCardButtonFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _subtitleText() {
    final parts = <String>[];
    if (task.type == AgentTaskType.medicineDelivery) {
      parts.add('Medicine');
    }
    if (task.distanceAway != null && task.distanceAway!.isNotEmpty) {
      parts.add(task.distanceAway!);
    }
    if (parts.isEmpty && task.location != null) {
      parts.add(task.location!);
    }
    return parts.isEmpty ? '—' : parts.join(' • ');
  }

  Future<void> _onActionTap(BuildContext context) async {
    if (task.priority == AgentTaskPriority.high || task.type == AgentTaskType.sos) {
      final homeProvider = context.read<HomeProvider>();
      final error = await homeProvider.updateRequestStatus(
        task.id,
        'ACCEPTED',
        notes: null,
      );
      if (!context.mounted) return;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } else {
      // TODO: Navigate to task details.
    }
  }
}
