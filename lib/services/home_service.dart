import 'package:dio/dio.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/network/dio_helper.dart';
import 'package:wisecare_agent/network/endpoints.dart';

/// Home / tasks API. Uses service-requests endpoints; auth via JwtInterceptor.
class HomeService {
  static const List<String> _activeStatuses = [
    'ASSIGNED',
    'ACCEPTED',
    'IN_PROGRESS',
  ];

  /// Fetches service requests and returns only active (ASSIGNED, ACCEPTED, IN_PROGRESS).
  /// Sorted: URGENT first, then by assignedAt ascending. Response: { "requests": [...], "count": N }.
  static Future<List<AgentTaskModel>> getActiveTasks() async {
    final response = await DioHelper.instance.get<Map<String, dynamic>>(
      Endpoints.serviceRequests,
      queryParameters: <String, dynamic>{'limit': 50},
    );
    final data = response.data;
    if (data == null) return [];
    final list = data['requests'];
    if (list is! List) return [];
    final requests = list
        .map<Map<String, dynamic>>(
            (e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
        .where((m) {
      final s = m['status'] as String?;
      return s != null && _activeStatuses.contains(s.toUpperCase());
    })
        .toList();
    _sortActiveRequests(requests);
    return requests
        .map<AgentTaskModel>(AgentTaskModel.fromServiceRequest)
        .where((t) => t.id.isNotEmpty)
        .toList();
  }

  /// Sort active list: URGENT first, then by assignedAt ascending (per API doc).
  static void _sortActiveRequests(List<Map<String, dynamic>> requests) {
    requests.sort((a, b) {
      final priorityA = (a['priority'] as String? ?? 'NORMAL').toUpperCase();
      final priorityB = (b['priority'] as String? ?? 'NORMAL').toUpperCase();
      final urgentA = priorityA == 'URGENT' ? 0 : 1;
      final urgentB = priorityB == 'URGENT' ? 0 : 1;
      if (urgentA != urgentB) return urgentA.compareTo(urgentB);
      final atA = a['assignedAt'] as String? ?? '';
      final atB = b['assignedAt'] as String? ?? '';
      return atA.compareTo(atB);
    });
  }

  /// Completed-today: count COMPLETED requests with completedAt today.
  /// Distance is not provided by API; see docs/tasks-api-gaps.md.
  static Future<CompletedTodayModel> getCompletedTodayStats() async {
    final response = await DioHelper.instance.get<Map<String, dynamic>>(
      Endpoints.serviceRequests,
      queryParameters: <String, dynamic>{
        'status': 'COMPLETED',
        'limit': 100,
      },
    );
    final data = response.data;
    if (data == null) {
      return const CompletedTodayModel(tasksCount: 0, distanceKm: 0);
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
  }

  /// Updates request status (e.g. ACCEPTED, IN_PROGRESS, COMPLETED).
  /// Body: { "status": string, "notes"?: string }. On 403 shows doc message.
  static Future<void> updateRequestStatus(
    String requestId,
    String status, {
    String? notes,
  }) async {
    final body = <String, dynamic>{'status': status};
    if (notes != null && notes.isNotEmpty) body['notes'] = notes;
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
