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

  factory AgentTaskModel.fromJson(Map<String, dynamic> json) {
    final priorityStr = json['priority'] as String? ?? 'medium';
    final typeStr = json['type'] as String?;
    return AgentTaskModel(
      id: json['id'] as String? ?? '',
      priority: priorityStr.toUpperCase() == 'HIGH'
          ? AgentTaskPriority.high
          : AgentTaskPriority.medium,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      location: json['location'] as String?,
      distanceAway: json['distanceAway'] as String?,
      type: _taskTypeFromString(typeStr),
      scheduledAt: json['scheduledAt'] as String?,
      itemCount: json['itemCount'] as int?,
      mapImageUrl: json['mapImageUrl'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
    );
  }

  static AgentTaskType _taskTypeFromString(String? value) {
    if (value == null) return AgentTaskType.other;
    final lower = value.toLowerCase();
    if (lower.contains('sos') || lower.contains('emergency')) {
      return AgentTaskType.sos;
    }
    if (lower.contains('medicine') || lower.contains('delivery')) {
      return AgentTaskType.medicineDelivery;
    }
    return AgentTaskType.other;
  }
}
