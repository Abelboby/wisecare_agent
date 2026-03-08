part of 'task_details_screen.dart';

extension _TaskDetailsScreenFunctions on _TaskDetailsScreenState {
  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    final error = await context.read<HomeProvider>().updateRequestStatus(
          widget.task.id,
          newStatus,
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
    final nextStatus = _TaskDetailsFunctions.nextStatus(status);
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
    final lat = widget.task.elderlyLatitude;
    final lng = widget.task.elderlyLongitude;
    final address = widget.task.location ?? widget.task.elderlyAddress ?? widget.task.elderlyCity ?? '';
    Uri? uri;
    if (lat != null && lng != null) {
      uri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    } else if (address.isNotEmpty) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
    }
    if (uri == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address not available')),
        );
      }
      return;
    }
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

/// Static helpers for task status transitions.
class _TaskDetailsFunctions {
  _TaskDetailsFunctions._();

  static String? nextStatus(String currentStatus) {
    if (currentStatus == 'ASSIGNED') return 'ACCEPTED';
    if (currentStatus == 'ACCEPTED') return 'IN_PROGRESS';
    if (currentStatus == 'IN_PROGRESS') return 'COMPLETED';
    return null;
  }

  static String? buttonLabel(String currentStatus) {
    if (currentStatus == 'ASSIGNED') return 'Accept Task';
    if (currentStatus == 'ACCEPTED') return 'Start Task';
    if (currentStatus == 'IN_PROGRESS') return 'Complete Task';
    return null;
  }
}
