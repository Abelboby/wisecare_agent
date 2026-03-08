import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

/// Task/request detail screen. Header, request info, elderly details, update status, notes.
class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final AgentTaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String get _statusLabel {
    final s = widget.task.status?.toUpperCase() ?? 'ASSIGNED';
    if (s == 'IN_PROGRESS') return 'IN PROGRESS';
    return s;
  }

  String get _scheduledSubtitle {
    if (widget.task.scheduledAt != null && widget.task.scheduledAt!.isNotEmpty) {
      return 'Scheduled for Today, ${widget.task.scheduledAt}';
    }
    return 'Scheduled for Today';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRequestSection(),
                    _buildElderlySection(context),
                    _buildUpdateStatusSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Skin.color(Co.homeHeaderBg),
        border: Border(
          bottom: BorderSide(
            color: Skin.color(Co.loginContactBorder),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(9999),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Skin.color(Co.loginLabel),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Request #${widget.task.id}',
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 22 / 18,
                        color: Skin.color(Co.loginHeading),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _scheduledSubtitle,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                        color: Skin.color(Co.loginSubtitle),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: Skin.color(Co.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              _statusLabel,
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 16 / 12,
                letterSpacing: 0.6,
                color: Skin.color(Co.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.task.title,
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 28 / 20,
              color: Skin.color(Co.loginHeading),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.task.description ?? widget.task.subtitle ?? '—',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 23 / 14,
              color: Skin.color(Co.loginInstruction),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElderlySection(BuildContext context) {
    final city = widget.task.elderlyCity ?? widget.task.location ?? '—';
    final address = widget.task.elderlyAddress ?? widget.task.location ?? widget.task.elderlyCity ?? '—';
    final addressLine2 = ''; // API may not have separate line; use if we add later

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ELDERLY DETAILS',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
              letterSpacing: 1.4,
              color: Skin.color(Co.loginIconMuted),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Skin.color(Co.loginLogoIconBg),
                  border: Border.all(
                    color: Skin.color(Co.primary).withValues(alpha: 0.2),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 28,
                  color: Skin.color(Co.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.customerName ?? 'Customer',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 24 / 16,
                        color: Skin.color(Co.loginHeading),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      city,
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _callElderly(context),
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Skin.color(Co.primary).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone_rounded,
                      size: 20,
                      color: Skin.color(Co.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 20,
                  color: Skin.color(Co.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address,
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          color: Skin.color(Co.loginHeading),
                        ),
                      ),
                      if (addressLine2.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          addressLine2,
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            color: Skin.color(Co.loginSubtitle),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _openMap(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Skin.color(Co.primary),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MAP',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 16 / 12,
                          color: Skin.color(Co.primary),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Skin.color(Co.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateStatusSection(BuildContext context) {
    final status = widget.task.status?.toUpperCase() ?? 'ASSIGNED';
    final canAccept = status == 'ASSIGNED';
    final canReject = status == 'ASSIGNED';
    final canStart = status == 'ACCEPTED';
    final canComplete = status == 'IN_PROGRESS';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'UPDATE STATUS',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
              letterSpacing: 1.4,
              color: Skin.color(Co.loginIconMuted),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatusButton(
                  label: 'Accept',
                  icon: Icons.check_rounded,
                  filled: true,
                  enabled: canAccept,
                  onPressed: canAccept ? () => _updateStatus(context, 'ACCEPTED') : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusButton(
                  label: 'Reject',
                  icon: Icons.close_rounded,
                  filled: false,
                  enabled: canReject,
                  onPressed: canReject ? () => _updateStatus(context, 'REJECTED') : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatusButton(
                  label: 'Start',
                  icon: Icons.play_arrow_rounded,
                  filled: false,
                  enabled: canStart,
                  onPressed: canStart ? () => _updateStatus(context, 'IN_PROGRESS') : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusButton(
                  label: 'Complete',
                  icon: Icons.check_circle_rounded,
                  filled: false,
                  enabled: canComplete,
                  onPressed: canComplete ? () => _updateStatus(context, 'COMPLETED') : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Internal Notes (Optional)',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: Skin.color(Co.loginLabel),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add details for the dispatch team...',
              hintStyle: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                color: Skin.color(Co.loginPlaceholder),
              ),
              filled: true,
              fillColor: Skin.color(Co.cardSurface),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Skin.color(Co.loginHeading),
            ),
          ),
          const SizedBox(height: 24),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _submitUpdateStatus(context),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Skin.color(Co.primary),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Skin.color(Co.primary).withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Skin.color(Co.primary).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  'Update Request Status',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 28 / 18,
                    color: Skin.color(Co.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    final error = await context.read<HomeProvider>().updateRequestStatus(
          widget.task.id,
          newStatus,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
    if (!context.mounted) return;
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _submitUpdateStatus(BuildContext context) async {
    final status = widget.task.status?.toUpperCase() ?? 'ASSIGNED';
    String? nextStatus;
    if (status == 'ASSIGNED') nextStatus = 'ACCEPTED';
    if (status == 'ACCEPTED') nextStatus = 'IN_PROGRESS';
    if (status == 'IN_PROGRESS') nextStatus = 'COMPLETED';
    if (nextStatus != null) {
      await _updateStatus(context, nextStatus);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No status change available')),
      );
    }
  }

  Future<void> _callElderly(BuildContext context) async {
    final phone = widget.task.elderlyPhone;
    if (phone == null || phone.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number not available')),
        );
      }
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot place call')),
      );
    }
  }

  Future<void> _openMap(BuildContext context) async {
    final address = widget.task.location ?? widget.task.elderlyCity ?? '';
    if (address.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address not available')),
        );
      }
      return;
    }
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open map')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open map')),
        );
      }
    }
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.enabled,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool useFilledStyle = filled && enabled;
    final Color textColor = useFilledStyle
        ? Skin.color(Co.onPrimary)
        : (enabled ? Skin.color(Co.loginInstruction) : Skin.color(Co.loginIconMuted));
    final Color? bgColor =
        useFilledStyle ? Skin.color(Co.primary) : (enabled ? null : const Color(0xFFF1F5F9).withValues(alpha: 0.5));
    final Border? border = !useFilledStyle ? Border.all(color: const Color(0xFFE2E8F0), width: 2) : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            border: border,
            borderRadius: BorderRadius.circular(16),
            boxShadow: useFilledStyle
                ? [
                    BoxShadow(
                      color: Skin.color(Co.primary).withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Skin.color(Co.primary).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 24 / 16,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
