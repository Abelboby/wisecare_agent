/// Priority for agent task cards.
enum AgentTaskPriority {
  high,
  medium,
}

/// Type of task for display (e.g. SOS vs medicine delivery).
enum AgentTaskType {
  sos,
  medicineDelivery,
  other,
}

/// Single task item for the home screen task list.
class AgentTaskModel {
  const AgentTaskModel({
    required this.id,
    required this.priority,
    required this.title,
    this.subtitle,
    this.location,
    this.distanceAway,
    this.type = AgentTaskType.other,
    this.scheduledAt,
    this.itemCount,
    this.mapImageUrl,
    this.productImageUrl,
    this.status,
    this.customerName,
    this.description,
    this.elderlyPhone,
    this.elderlyCity,
    this.elderlyAddress,
    this.elderlyUserId,
    this.elderlyLatitude,
    this.elderlyLongitude,
    this.requestType,
    this.rawMessage,
    this.assignedAgentId,
    this.assignedAgentName,
    this.assignedAt,
    this.agentNotes,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.sessionId,
  });

  final String id;
  final AgentTaskPriority priority;
  final String title;
  final String? subtitle;
  final String? location;
  final String? distanceAway;
  final AgentTaskType type;
  final String? scheduledAt;
  final int? itemCount;
  final String? mapImageUrl;
  final String? productImageUrl;
  /// API status: ASSIGNED, ACCEPTED, IN_PROGRESS, COMPLETED, REJECTED.
  final String? status;
  /// Elderly/customer name from API (elderlyName).
  final String? customerName;
  /// Request details from API (description).
  final String? description;
  /// Elderly contact number from API (elderlyPhone).
  final String? elderlyPhone;
  /// Elderly city from API (elderlyCity).
  final String? elderlyCity;
  /// Full address from API (elderlyAddress).
  final String? elderlyAddress;
  /// Elderly user id from API (elderlyUserId).
  final String? elderlyUserId;
  /// Elderly location latitude from API (elderlyLatitude).
  final double? elderlyLatitude;
  /// Elderly location longitude from API (elderlyLongitude).
  final double? elderlyLongitude;
  /// Request type from API (e.g. DELIVERY) (requestType).
  final String? requestType;
  /// Raw message from elderly (rawMessage).
  final String? rawMessage;
  /// Assigned agent id from API (assignedAgentId).
  final String? assignedAgentId;
  /// Assigned agent name from API (assignedAgentName).
  final String? assignedAgentName;
  /// Assigned at ISO timestamp from API (assignedAt).
  final String? assignedAt;
  /// Agent notes from API (agentNotes).
  final String? agentNotes;
  /// Created at ISO timestamp from API (createdAt).
  final String? createdAt;
  /// Updated at ISO timestamp from API (updatedAt).
  final String? updatedAt;
  /// Completed at ISO timestamp from API (completedAt).
  final String? completedAt;
  /// Session id from API (sessionId).
  final String? sessionId;

  factory AgentTaskModel.fromJson(Map<String, dynamic> json) {
    final priorityStr = json['priority'] as String? ?? 'medium';
    final typeStr = json['type'] as String? ?? json['category'] as String?;
    final id = json['id'] as String? ?? json['requestId'] as String? ?? '';
    return AgentTaskModel(
      id: id,
      priority: priorityStr.toUpperCase() == 'HIGH'
          ? AgentTaskPriority.high
          : AgentTaskPriority.medium,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      location: json['location'] as String? ?? json['elderlyAddress'] as String?,
      distanceAway: json['distanceAway'] as String?,
      type: _taskTypeFromString(typeStr),
      scheduledAt: json['scheduledAt'] as String?,
      itemCount: json['itemCount'] as int?,
      mapImageUrl: json['mapImageUrl'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
      status: json['status'] as String?,
      customerName: json['customerName'] as String? ?? json['elderlyName'] as String?,
      description: json['description'] as String?,
      elderlyPhone: json['elderlyPhone'] as String?,
      elderlyCity: json['elderlyCity'] as String?,
      elderlyAddress: json['elderlyAddress'] as String?,
      elderlyUserId: json['elderlyUserId'] as String?,
      elderlyLatitude: (json['elderlyLatitude'] as num?)?.toDouble(),
      elderlyLongitude: (json['elderlyLongitude'] as num?)?.toDouble(),
      requestType: json['requestType'] as String?,
      rawMessage: json['rawMessage'] as String?,
      assignedAgentId: json['assignedAgentId'] as String?,
      assignedAgentName: json['assignedAgentName'] as String?,
      assignedAt: json['assignedAt'] as String?,
      agentNotes: json['agentNotes'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      sessionId: json['sessionId'] as String?,
    );
  }

  /// Maps backend service-request object to [AgentTaskModel].
  /// See service-requests-api-integration.md for API shape.
  factory AgentTaskModel.fromServiceRequest(Map<String, dynamic> json) {
    final category = json['category'] as String?;
    final priorityStr = json['priority'] as String? ?? 'NORMAL';
    final statusStr = json['status'] as String? ?? '';
    final title = json['title'] as String? ?? json['description'] as String? ?? '';
    final location = json['elderlyAddress'] as String? ?? json['elderlyCity'] as String?;
    final assignedAtRaw = json['assignedAt'] as String?;
    final subtitle = _subtitleFromCategoryAndStatus(category, statusStr);
    final scheduledAtRaw = json['scheduledAt'] as String?;
    return AgentTaskModel(
      id: json['requestId'] as String? ?? '',
      priority: _priorityFromApi(priorityStr, category),
      title: title.isNotEmpty ? title : (json['rawMessage'] as String? ?? 'Task'),
      subtitle: subtitle,
      location: location,
      distanceAway: json['distanceAway'] as String?,
      type: _taskTypeFromString(category),
      scheduledAt: _formatAssignedAt(scheduledAtRaw ?? assignedAtRaw),
      itemCount: json['itemCount'] as int?,
      mapImageUrl: json['mapImageUrl'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
      status: statusStr.isNotEmpty ? statusStr.toUpperCase() : null,
      customerName: json['elderlyName'] as String?,
      description: json['description'] as String?,
      elderlyPhone: json['elderlyPhone'] as String?,
      elderlyCity: json['elderlyCity'] as String?,
      elderlyAddress: json['elderlyAddress'] as String?,
      elderlyUserId: json['elderlyUserId'] as String?,
      elderlyLatitude: (json['elderlyLatitude'] as num?)?.toDouble(),
      elderlyLongitude: (json['elderlyLongitude'] as num?)?.toDouble(),
      requestType: json['requestType'] as String?,
      rawMessage: json['rawMessage'] as String?,
      assignedAgentId: json['assignedAgentId'] as String?,
      assignedAgentName: json['assignedAgentName'] as String?,
      assignedAt: assignedAtRaw,
      agentNotes: json['agentNotes'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      sessionId: json['sessionId'] as String?,
    );
  }

  static String _subtitleFromCategoryAndStatus(String? category, String status) {
    final statusLabel = _statusLabel(status);
    if (category != null && category.isNotEmpty) {
      return '$category • $statusLabel';
    }
    return statusLabel;
  }

  static String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Waiting for agent';
      case 'ASSIGNED':
        return 'Assigned to you';
      case 'ACCEPTED':
        return 'Accepted';
      case 'IN_PROGRESS':
        return 'In progress';
      case 'COMPLETED':
        return 'Completed';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }

  static AgentTaskPriority _priorityFromApi(String priority, String? category) {
    if (category != null && category.toUpperCase() == 'SOS') {
      return AgentTaskPriority.high;
    }
    final p = priority.toUpperCase();
    return (p == 'URGENT' || p == 'HIGH')
        ? AgentTaskPriority.high
        : AgentTaskPriority.medium;
  }

  static String? _formatAssignedAt(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      final dt = DateTime.parse(iso);
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${dt.minute.toString().padLeft(2, '0')} $ampm';
    } catch (_) {
      return null;
    }
  }

  static AgentTaskType _taskTypeFromString(String? value) {
    if (value == null) return AgentTaskType.other;
    final lower = value.toLowerCase();
    if (lower.contains('sos') || lower.contains('emergency')) {
      return AgentTaskType.sos;
    }
    if (lower.contains('medicine') || lower.contains('grocery')) {
      return AgentTaskType.medicineDelivery;
    }
    return AgentTaskType.other;
  }
}
