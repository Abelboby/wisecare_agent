import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/services/home_service.dart';

/// Home data orchestration. Only this layer talks to HomeService.
class HomeRepository {
  /// Fetches all assigned requests in one call. Provider splits into active/completed.
  Future<List<AgentTaskModel>> getAllTasks() async {
    return HomeService.getAllTasks();
  }

  Future<CompletedTodayModel> getCompletedTodayStats() async {
    return HomeService.getCompletedTodayStats();
  }

  Future<void> updateRequestStatus(
    String requestId,
    String status, {
    String? notes,
  }) async {
    await HomeService.updateRequestStatus(requestId, status, notes: notes);
  }
}
