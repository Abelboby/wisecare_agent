part of '../tasks_tab_screen.dart';

/// Single request card matching Figma: icon, customer, status, meta, action button.
class _TasksRequestCard extends StatelessWidget {
  const _TasksRequestCard({
    required this.task,
    required this.index,
  });

  final AgentTaskModel task;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isUrgent = task.priority == AgentTaskPriority.high;
    final status = task.status?.toUpperCase() ?? 'ASSIGNED';
    final iconData = _getIconForType(task.type);
    final iconColor = _getIconColor(task.type);
    final iconBgColor = _getIconBgColor(task.type);
    final statusStyle = _getStatusStyle(status);
    final buttonConfig = _getButtonConfig(context, status);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(_TasksTabDimens.cardContentPadding),
          decoration: BoxDecoration(
            color: Skin.color(Co.cardSurface),
            borderRadius: BorderRadius.circular(_TasksTabDimens.cardRadius),
            border: Border.all(
              color: isUrgent
                  ? Skin.color(Co.homePriorityHigh).withValues(alpha: 0.2)
                  : Skin.color(Co.primary).withValues(alpha: 0.05),
              width: isUrgent ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Skin.color(Co.splashBadgeShadow),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: _TasksTabDimens.cardIconSize,
                    height: _TasksTabDimens.cardIconSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(_TasksTabDimens.cardIconRadius),
                    ),
                    child: Icon(iconData, size: 25, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.customerName ?? 'Customer',
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 24 / 16,
                            color: Skin.color(Co.loginHeading),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#REQ-${task.id}',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            color: Skin.color(Co.loginSubtitle),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _TaskStatusTag(status: status, style: statusStyle),
                ],
              ),
              const SizedBox(height: _TasksTabDimens.cardContentGap),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 12,
                    color: Skin.color(Co.loginInstruction),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: Skin.color(Co.loginInstruction),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_getMetaSecondary(task) != null) ...[
                    Icon(
                      _getMetaIcon(task),
                      size: 12,
                      color: Skin.color(Co.loginInstruction),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getMetaSecondary(task)!,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: Skin.color(Co.loginInstruction),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Skin.color(Co.loginContactBorder),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getBottomLeftLabel(task),
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: Skin.color(Co.loginSubtitle),
                      ),
                    ),
                    _TaskActionButton(
                      config: buttonConfig,
                      onPressed: () => _onAction(context, buttonConfig.action),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isUrgent)
          Positioned(
            top: -10,
            right: 18,
            child: const _UrgentBadge(),
          ),
      ],
    );
  }

  void _onAction(BuildContext context, String action) {
    if (action == 'ACCEPT') {
      _navigateToDetail(context);
      _callUpdateStatusInBackground(context, 'ACCEPTED');
    } else if (action == 'START') {
      _navigateToDetail(context);
      _callUpdateStatusInBackground(context, 'IN_PROGRESS');
    } else if (action == 'UPDATE') {
      _navigateToDetail(context);
    }
  }

  /// Navigate to detail screen immediately (no wait for API).
  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TaskDetailsScreen(task: task),
      ),
    );
  }

  /// Call update status API in background; show snackbar on error.
  void _callUpdateStatusInBackground(BuildContext context, String status) {
    final homeProvider = context.read<HomeProvider>();
    homeProvider.updateRequestStatus(task.id, status, notes: null).then((String? error) {
      if (error != null && error.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    });
  }

  static IconData _getIconForType(AgentTaskType type) {
    switch (type) {
      case AgentTaskType.medicineDelivery:
        return Icons.medical_services_outlined;
      case AgentTaskType.sos:
        return Icons.warning_amber_rounded;
      default:
        return Icons.shopping_cart_outlined;
    }
  }

  static Color _getIconColor(AgentTaskType type) {
    switch (type) {
      case AgentTaskType.medicineDelivery:
        return Skin.color(Co.accentBlur);
      case AgentTaskType.sos:
        return Skin.color(Co.primary);
      default:
        return Skin.color(Co.primary);
    }
  }

  static Color _getIconBgColor(AgentTaskType type) {
    switch (type) {
      case AgentTaskType.medicineDelivery:
        return Skin.color(Co.accentBlur).withValues(alpha: 0.25);
      case AgentTaskType.sos:
        return Skin.color(Co.primary).withValues(alpha: 0.1);
      default:
        return Skin.color(Co.primary).withValues(alpha: 0.1);
    }
  }

  static _StatusStyle _getStatusStyle(String status) {
    switch (status) {
      case 'ASSIGNED':
        return _StatusStyle(
          bgColor: const Color(0xFFFFEDD5),
          textColor: const Color(0xFFC2410C),
        );
      case 'ACCEPTED':
        return _StatusStyle(
          bgColor: const Color(0xFFDCFCE7),
          textColor: const Color(0xFF15803D),
        );
      case 'IN_PROGRESS':
        return _StatusStyle(
          bgColor: const Color(0xFFDBEAFE),
          textColor: const Color(0xFF1D4ED8),
        );
      default:
        return _StatusStyle(
          bgColor: const Color(0xFFFFEDD5),
          textColor: const Color(0xFFC2410C),
        );
    }
  }

  static _ButtonConfig _getButtonConfig(BuildContext context, String status) {
    switch (status) {
      case 'ASSIGNED':
        return _ButtonConfig(
          label: 'Accept Task',
          filled: true,
          backgroundColor: Skin.color(Co.primary),
          textColor: Skin.color(Co.onPrimary),
          action: 'ACCEPT',
          enabled: true,
        );
      case 'ACCEPTED':
        return _ButtonConfig(
          label: 'Start Task',
          filled: false,
          backgroundColor: Colors.transparent,
          textColor: Skin.color(Co.primary),
          action: 'START',
          enabled: true,
        );
      case 'IN_PROGRESS':
        return _ButtonConfig(
          label: 'Update Status',
          filled: true,
          backgroundColor: Skin.color(Co.loginHeading),
          textColor: Skin.color(Co.onPrimary),
          action: 'UPDATE',
          enabled: true,
        );
      case 'COMPLETED':
        return _ButtonConfig(
          label: 'Completed',
          filled: false,
          backgroundColor: Colors.transparent,
          textColor: Skin.color(Co.loginIconMuted),
          action: 'NONE',
          enabled: false,
        );
      case 'REJECTED':
        return _ButtonConfig(
          label: 'Rejected',
          filled: false,
          backgroundColor: Colors.transparent,
          textColor: Skin.color(Co.loginIconMuted),
          action: 'NONE',
          enabled: false,
        );
      default:
        return _ButtonConfig(
          label: 'Accept Task',
          filled: true,
          backgroundColor: Skin.color(Co.primary),
          textColor: Skin.color(Co.onPrimary),
          action: 'ACCEPT',
          enabled: true,
        );
    }
  }

  static String? _getMetaSecondary(AgentTaskModel task) {
    if (task.scheduledAt != null && task.scheduledAt!.isNotEmpty) {
      return 'Due ${task.scheduledAt}';
    }
    if (task.distanceAway != null && task.distanceAway!.isNotEmpty) {
      return task.distanceAway;
    }
    if (task.location != null && task.location!.isNotEmpty) {
      return task.location;
    }
    return null;
  }

  static IconData _getMetaIcon(AgentTaskModel task) {
    if (task.distanceAway != null && task.distanceAway!.isNotEmpty) {
      return Icons.schedule_outlined;
    }
    if (task.location != null) return Icons.location_on_outlined;
    return Icons.schedule_outlined;
  }

  static String _getBottomLeftLabel(AgentTaskModel task) {
    if (task.status == 'IN_PROGRESS' && task.scheduledAt != null) {
      return 'Started at ${task.scheduledAt}';
    }
    if (task.scheduledAt != null && task.scheduledAt!.isNotEmpty) {
      return 'Scheduled for ${task.scheduledAt}';
    }
    if (task.distanceAway != null && task.distanceAway!.isNotEmpty) {
      return task.distanceAway!;
    }
    return '—';
  }
}

class _StatusStyle {
  const _StatusStyle({required this.bgColor, required this.textColor});
  final Color bgColor;
  final Color textColor;
}

class _ButtonConfig {
  const _ButtonConfig({
    required this.label,
    required this.filled,
    required this.backgroundColor,
    required this.textColor,
    required this.action,
    this.enabled = true,
  });
  final String label;
  final bool filled;
  final Color backgroundColor;
  final Color textColor;
  final String action;
  final bool enabled;
}

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Skin.color(Co.homePriorityHigh),
        borderRadius: BorderRadius.circular(_TasksTabDimens.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 10,
            color: Skin.color(Co.onPrimary),
          ),
          const SizedBox(width: 4),
          Text(
            'URGENT',
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 15 / 10,
              letterSpacing: 0.5,
              color: Skin.color(Co.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskStatusTag extends StatelessWidget {
  const _TaskStatusTag({required this.status, required this.style});

  final String status;
  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    final label = status == 'IN_PROGRESS' ? 'IN PROGRESS' : status;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: _TasksTabDimens.badgePaddingV,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(_TasksTabDimens.badgeRadius),
      ),
      child: Text(
        label,
        style: GoogleFonts.lexend(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 16 / 11,
          letterSpacing: -0.275,
          color: style.textColor,
        ),
      ),
    );
  }
}

class _TaskActionButton extends StatelessWidget {
  const _TaskActionButton({
    required this.config,
    required this.onPressed,
  });

  final _ButtonConfig config;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!config.enabled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Skin.color(Co.loginContactBorder).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
        ),
        child: Center(
          child: Text(
            config.label,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
              color: Skin.color(Co.loginIconMuted).withValues(alpha: 0.8),
            ),
          ),
        ),
      );
    }
    if (config.filled) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: Skin.color(Co.primary).withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Skin.color(Co.primary).withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Center(
                child: Text(
                  config.label,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 20 / 14,
                    color: config.textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Skin.color(Co.primary), width: 1),
            borderRadius: BorderRadius.circular(_TasksTabDimens.buttonRadius),
          ),
          child: Text(
            config.label,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
              color: config.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
