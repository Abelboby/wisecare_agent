import 'package:dio/dio.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/network/dio_helper.dart';
import 'package:wisecare_agent/network/endpoints.dart';

/// Home / tasks API. Uses service-requests endpoints; auth via JwtInterceptor.
class HomeService {
  /// Fetches all assigned service requests (one API call). No status filter.
  /// Caller splits into active vs completed. Response: { "requests": [...], "count": N }.
  static Future<List<AgentTaskModel>> getAllTasks() async {
    final response = await DioHelper.instance.get<Map<String, dynamic>>(
      Endpoints.serviceRequests,
    );
    final data = response.data;
    if (data == null) return [];
    final list = data['requests'];
    if (list is! List) return [];
    final requests = list
        .map<Map<String, dynamic>>(
            (e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
        .toList();
    return requests
        .map<AgentTaskModel>(AgentTaskModel.fromServiceRequest)
        .where((t) => t.id.isNotEmpty)
        .toList();
  }

  /// Completed-today: use GET /service-requests?status=COMPLETED&summary=today.
  /// Response may include todaySummary: { tasksCount, distanceKm }.
  static Future<CompletedTodayModel> getCompletedTodayStats() async {
    try {
      final response = await DioHelper.instance.get<Map<String, dynamic>>(
        Endpoints.serviceRequests,
        queryParameters: <String, dynamic>{
          'status': 'COMPLETED',
          'summary': 'today',
        },
      );
      final data = response.data;
      if (data == null) {
        return const CompletedTodayModel(tasksCount: 0, distanceKm: 0);
      }
      final summary = data['todaySummary'];
      if (summary is Map<String, dynamic>) {
        final count = summary['tasksCount'] is int
            ? summary['tasksCount'] as int
            : (summary['tasksCount'] is num
                ? (summary['tasksCount'] as num).toInt()
                : 0);
        final km = summary['distanceKm'] is num
            ? (summary['distanceKm'] as num).toDouble()
            : 0.0;
        return CompletedTodayModel(tasksCount: count, distanceKm: km);
      }
      final list = data['requests'] as List<dynamic>? ?? [];
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final endOfToday = todayStart.add(const Duration(days: 1));
      int count = 0;
      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;
        final completedAt = item['completedAt'];
        if (completedAt == null) continue;
        try {
          final dt = DateTime.parse(completedAt as String);
          if (!dt.isBefore(todayStart) && dt.isBefore(endOfToday)) count++;
        } catch (_) {
          // ignore invalid date
        }
      }
      return CompletedTodayModel(tasksCount: count, distanceKm: 0);
    } catch (_) {
      return const CompletedTodayModel(tasksCount: 0, distanceKm: 0);
    }
  }

  /// Updates request status. PATCH /service-requests/{requestId}/status.
  /// Body: { status, notes?, distanceKm? } per service-requests-agent-frontend-integration.
  static Future<void> updateRequestStatus(
    String requestId,
    String status, {
    String? notes,
    double? distanceKm,
  }) async {
    final body = <String, dynamic>{'status': status};
    if (notes != null && notes.isNotEmpty) body['notes'] = notes;
    if (distanceKm != null && status == 'COMPLETED') body['distanceKm'] = distanceKm;
    try {
      await DioHelper.instance.patch<dynamic>(
        Endpoints.serviceRequestStatus(requestId),
        data: body,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromStatusUpdateError(e));
    }
  }

  static String _messageFromStatusUpdateError(DioException e) {
    final response = e.response;
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final msg = data['error'] as String? ?? data['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    if (response?.statusCode == 403) {
      return 'This request is not assigned to you.';
    }
    if (response?.statusCode == 401) return 'Session expired. Please sign in again.';
    if (response?.statusCode == 404) return 'Request not found.';
    if (response?.statusCode != null && response!.statusCode! >= 500) {
      return 'Server error. Please try again later.';
    }
    if (response == null || e.type == DioExceptionType.connectionError) {
      return 'Network error. Please check your connection.';
    }
    return e.message ?? 'Something went wrong. Please try again.';
  }
}
