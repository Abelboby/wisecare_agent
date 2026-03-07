import 'package:dio/dio.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/network/dio_helper.dart';
import 'package:wisecare_agent/network/endpoints.dart';

/// Home / tasks API. Auth token is injected by JwtInterceptor.
class HomeService {
  /// Fetches active service requests for the agent.
  /// API may return list of requests; we map to [AgentTaskModel].
  static Future<List<AgentTaskModel>> getActiveTasks() async {
    try {
      final response = await DioHelper.instance.get<dynamic>(
        Endpoints.serviceRequests,
      );
      final data = response.data;
      if (data == null) return _defaultTasks();
      if (data is! List) return _defaultTasks();
      return data
          .map<AgentTaskModel>((e) => AgentTaskModel.fromJson(
              e is Map<String, dynamic> ? e : <String, dynamic>{}))
          .where((t) => t.id.isNotEmpty)
          .toList();
    } on DioException catch (_) {
      return _defaultTasks();
    }
  }

  /// Default tasks for UI when API is empty or fails.
  static List<AgentTaskModel> _defaultTasks() {
    return [
      const AgentTaskModel(
        id: 'sos-1',
        priority: AgentTaskPriority.high,
        title: 'SOS ALERT - Raghav Kumar',
        subtitle: 'HIGH PRIORITY',
        location: 'Chennai (2.4km away)',
        distanceAway: '2.4km',
        type: AgentTaskType.sos,
      ),
      const AgentTaskModel(
        id: 'med-1',
        priority: AgentTaskPriority.medium,
        title: 'Medicine Delivery',
        subtitle: 'MEDIUM PRIORITY',
        scheduledAt: '2:00 PM',
        itemCount: 3,
        type: AgentTaskType.medicineDelivery,
      ),
    ];
  }

  /// Fetches completed-today stats (tasks count, distance).
  /// Uses admin/stats or a dedicated endpoint if available.
  static Future<CompletedTodayModel> getCompletedTodayStats() async {
    try {
      final response = await DioHelper.instance.get<Map<String, dynamic>>(
        Endpoints.adminStats,
      );
      final data = response.data;
      if (data == null) return _defaultCompletedToday();
      return CompletedTodayModel.fromJson(
        (data['today'] as Map<String, dynamic>?) ?? {},
      );
    } on DioException catch (_) {
      return _defaultCompletedToday();
    }
  }

  static CompletedTodayModel _defaultCompletedToday() {
    return const CompletedTodayModel(tasksCount: 5, distanceKm: 12);
  }
}
