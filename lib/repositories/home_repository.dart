import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/services/home_service.dart';

/// Home data orchestration. Only this layer talks to HomeService.
class HomeRepository {
  Future<List<AgentTaskModel>> getActiveTasks() async {
    return HomeService.getActiveTasks();
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
