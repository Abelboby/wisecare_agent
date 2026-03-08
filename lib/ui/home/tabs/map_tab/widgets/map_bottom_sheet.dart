part of '../map_tab_screen.dart';

/// Bottom sheet that sizes to its content. Uses Column with mainAxisSize.min
/// and crossAxisAlignment.stretch so the sheet extends only up to the content.
class _MapBottomSheet extends StatelessWidget {
  const _MapBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Skin.color(Co.cardSurface),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(_MapTabDimens.sheetBorderRadius),
          ),
          border: Border(
            top: BorderSide(
              color: Skin.color(Co.mapHeaderBorder),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Skin.color(Co.mapSheetShadow),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    color: Skin.color(Co.mapPullHandle),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _MapTabDimens.sheetPaddingH,
                0,
                _MapTabDimens.sheetPaddingH,
                _MapTabDimens.sheetPaddingBottom,
              ),
              child: Consumer<HomeProvider>(
                builder: (context, homeProvider, _) {
                  final tasks = homeProvider.activeTasks;
                  final task = tasks.isNotEmpty ? tasks.first : null;
                  if (task == null) {
                    return const _MapEmptyStateSection();
                  }
                  return _MapTaskDetailContent(task: task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state when there are no active tasks.
class _MapEmptyStateSection extends StatelessWidget {
  const _MapEmptyStateSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
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
}

/// Status pill, title, subtitle, and avatar row.
class _MapStatusAndHeaderSection extends StatelessWidget {
  const _MapStatusAndHeaderSection({
    required this.task,
    required this.statusLabel,
    required this.subtitle,
  });

  final AgentTaskModel task;
  final String statusLabel;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Skin.color(Co.mapSheetNearBadgeBg),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.lexend(
                    fontSize: _MapTabDimens.sheetStatusPillFontSize,
                    fontWeight: FontWeight.w700,
                    height: 16 / 12,
                    letterSpacing: 0.6,
                    color: Skin.color(Co.primary),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                style: GoogleFonts.lexend(
                  fontSize: _MapTabDimens.sheetDetailTitleFontSize,
                  fontWeight: FontWeight.w900,
                  height: _MapTabDimens.sheetDetailTitleHeight / _MapTabDimens.sheetDetailTitleFontSize,
                  color: Skin.color(Co.mapAgentViewTitle),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.lexend(
                  fontSize: _MapTabDimens.sheetDetailSubtitleFontSize,
                  fontWeight: FontWeight.w500,
                  height: _MapTabDimens.sheetDetailSubtitleHeight / _MapTabDimens.sheetDetailSubtitleFontSize,
                  color: Skin.color(Co.loginSubtitle),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: _MapTabDimens.sheetAvatarSize,
          height: _MapTabDimens.sheetAvatarSize,
          decoration: BoxDecoration(
            color: Skin.color(Co.mapHeaderBorder),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Skin.color(Co.mapSheetShadow),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            Icons.person_rounded,
            size: 28,
            color: Skin.color(Co.loginSubtitle),
          ),
        ),
      ],
    );
  }
}

/// Location card with address and copy button.
class _MapLocationCardSection extends StatelessWidget {
  const _MapLocationCardSection({
    required this.addressLine1,
    required this.addressLine2,
    required this.onCopy,
  });

  final String addressLine1;
  final String addressLine2;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_MapTabDimens.sheetLocationCardPadding),
      decoration: BoxDecoration(
        color: Skin.color(Co.mapTaskCardBg),
        borderRadius: BorderRadius.circular(_MapTabDimens.sheetLocationCardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: _MapTabDimens.sheetLocationIconSize,
            height: _MapTabDimens.sheetLocationIconSize,
            decoration: BoxDecoration(
              color: Skin.color(Co.mapAgentViewTitle),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  addressLine1,
                  style: GoogleFonts.lexend(
                    fontSize: _MapTabDimens.sheetAddressLine1FontSize,
                    fontWeight: FontWeight.w400,
                    height: _MapTabDimens.sheetAddressLine1Height / _MapTabDimens.sheetAddressLine1FontSize,
                    color: Skin.color(Co.mapAgentViewTitle),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (addressLine2.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    addressLine2,
                    style: GoogleFonts.lexend(
                      fontSize: _MapTabDimens.sheetAddressLine2FontSize,
                      fontWeight: FontWeight.w500,
                      height: _MapTabDimens.sheetAddressLine2Height / _MapTabDimens.sheetAddressLine2FontSize,
                      color: Skin.color(Co.loginSubtitle),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: Skin.color(Co.mapAgentViewTitle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Start Navigation and Call action buttons.
class _MapActionButtonsSection extends StatelessWidget {
  const _MapActionButtonsSection({
    required this.onStartNavigation,
    required this.onCall,
  });

  final VoidCallback onStartNavigation;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onStartNavigation,
              borderRadius: BorderRadius.circular(_MapTabDimens.sheetCtaRadius),
              child: Container(
                height: _MapTabDimens.sheetCtaHeight,
                decoration: BoxDecoration(
                  color: Skin.color(Co.primary),
                  borderRadius: BorderRadius.circular(_MapTabDimens.sheetCtaRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Skin.color(Co.loginButtonShadow),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                      spreadRadius: -3,
                    ),
                    BoxShadow(
                      color: Skin.color(Co.loginButtonShadow),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.navigation_rounded,
                      size: 20,
                      color: Skin.color(Co.onPrimary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Start Navigation',
                      style: GoogleFonts.lexend(
                        fontSize: _MapTabDimens.sheetCtaFontSize,
                        fontWeight: FontWeight.w900,
                        height: _MapTabDimens.sheetCtaFontHeight / _MapTabDimens.sheetCtaFontSize,
                        color: Skin.color(Co.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCall,
            borderRadius: BorderRadius.circular(_MapTabDimens.sheetCtaRadius),
            child: Container(
              height: _MapTabDimens.sheetCtaHeight,
              width: 64,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Skin.color(Co.loginInputBorder),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(_MapTabDimens.sheetCtaRadius),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.call_rounded,
                size: 20,
                color: Skin.color(Co.mapAgentViewTitle),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Single-task detail: status pill, title, subtitle, avatar, location card, actions.
class _MapTaskDetailContent extends StatelessWidget {
  const _MapTaskDetailContent({required this.task});

  final AgentTaskModel task;

  @override
  Widget build(BuildContext context) {
    final statusLabel = _statusDisplayLabel(task.status);
    final subtitle = _buildSubtitle();
    final addressLine1 = task.elderlyAddress ?? task.location ?? '—';
    final addressLine2 = task.elderlyCity != null && task.elderlyCity!.isNotEmpty ? task.elderlyCity! : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: _MapTabDimens.sheetContentGap),
        _MapStatusAndHeaderSection(
          task: task,
          statusLabel: statusLabel,
          subtitle: subtitle,
        ),
        const SizedBox(height: _MapTabDimens.sheetContentGap),
        _MapLocationCardSection(
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          onCopy: () => _copyAddress(context, addressLine1, addressLine2),
        ),
        const SizedBox(height: _MapTabDimens.sheetContentGap),
        _MapActionButtonsSection(
          onStartNavigation: () => _startNavigation(context),
          onCall: () => _callCustomer(context),
        ),
      ],
    );
  }

  String _statusDisplayLabel(String? status) {
    if (status == null || status.isEmpty) return 'IN PROGRESS';
    final upper = status.toUpperCase();
    if (upper == 'IN_PROGRESS') return 'IN PROGRESS';
    if (upper == 'ASSIGNED' || upper == 'ACCEPTED') return 'IN PROGRESS';
    return upper.replaceAll('_', ' ');
  }

  String _buildSubtitle() {
    final parts = <String>[];
    final name = task.customerName;
    if (name != null && name.isNotEmpty) parts.add(name);
    if (task.distanceAway != null && task.distanceAway!.isNotEmpty) {
      parts.add(task.distanceAway!);
    }
    return parts.isEmpty ? '—' : parts.join(' • ');
  }

  void _copyAddress(
    BuildContext context,
    String line1,
    String line2,
  ) {
    final text = line2.isEmpty ? line1 : '$line1, $line2';
    try {
      Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Address copied',
              style: GoogleFonts.lexend(fontSize: 14),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not copy address')),
        );
      }
    }
  }

  Future<void> _startNavigation(BuildContext context) async {
    final lat = task.elderlyLatitude;
    final lng = task.elderlyLongitude;
    if (lat == null || lng == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No location available for this task',
            style: GoogleFonts.lexend(fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final launched = await MapLauncherService.openInGoogleMaps(lat, lng);
    if (!context.mounted) return;
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open Google Maps',
            style: GoogleFonts.lexend(fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _callCustomer(BuildContext context) async {
    final phone = task.elderlyPhone;
    if (phone == null || phone.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No phone number available',
            style: GoogleFonts.lexend(fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone.trim());
    try {
      final launched = await launchUrl(uri);
      if (!context.mounted) return;
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not place call')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not place call')),
        );
      }
    }
  }
}
