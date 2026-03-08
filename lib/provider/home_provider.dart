import 'package:flutter/foundation.dart';

import 'package:wisecare_agent/enums/app_enums.dart';
import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/repositories/home_repository.dart';

/// Home screen state: tab, online status, tasks, completed stats.
/// Uses repository only. One API call loads all requests; split into active vs completed.
class HomeProvider extends ChangeNotifier {
  HomeProvider({HomeRepository? repository})
      : _repository = repository ?? HomeRepository();

  final HomeRepository _repository;

  AppTab _currentTab = AppTab.tasks;
  AppTab get currentTab => _currentTab;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  List<AgentTaskModel> _activeTasks = [];
  List<AgentTaskModel> get activeTasks => List.unmodifiable(_activeTasks);

  List<AgentTaskModel> _completedTasks = [];
  List<AgentTaskModel> get completedTasks => List.unmodifiable(_completedTasks);

  CompletedTodayModel? _completedToday;
  CompletedTodayModel? get completedToday => _completedToday;

  bool _isTasksLoading = false;
  bool get isTasksLoading => _isTasksLoading;

  String? _tasksError;
  String? get tasksError => _tasksError;

  void switchTab(AppTab tab) {
    if (_currentTab == tab) return;
    _currentTab = tab;
    notifyListeners();
  }

  void setOffline() {
    if (!_isOnline) return;
    _isOnline = false;
    notifyListeners();
  }

  void setOnline() {
    if (_isOnline) return;
    _isOnline = true;
    notifyListeners();
  }

  /// Number of "new" tasks (e.g. unread or high priority). Used for badge.
  int get newTasksCount {
    final high = _activeTasks.where((t) => t.priority == AgentTaskPriority.high).length;
    return high > 0 ? _activeTasks.length : 0;
  }

  static const List<String> _activeStatuses = [
    'ASSIGNED',
    'ACCEPTED',
    'IN_PROGRESS',
  ];

  static void _sortActiveTasks(List<AgentTaskModel> tasks) {
    tasks.sort((a, b) {
      final urgentA = a.priority == AgentTaskPriority.high ? 0 : 1;
      final urgentB = b.priority == AgentTaskPriority.high ? 0 : 1;
      if (urgentA != urgentB) return urgentA.compareTo(urgentB);
      return (a.scheduledAt ?? '').compareTo(b.scheduledAt ?? '');
    });
  }

  static void _sortCompletedTasks(List<AgentTaskModel> tasks) {
    tasks.sort((a, b) => b.id.compareTo(a.id));
  }

  Future<void> loadTasks() async {
    if (_isTasksLoading) return;
    _isTasksLoading = true;
    _tasksError = null;
    notifyListeners();
    try {
      final all = await _repository.getAllTasks();
      _activeTasks = all
          .where((t) =>
              t.status != null &&
              _activeStatuses.contains(t.status!.toUpperCase()))
          .toList();
      _sortActiveTasks(_activeTasks);
      _completedTasks = all
          .where((t) =>
              t.status != null &&
              t.status!.toUpperCase() == 'COMPLETED')
          .toList();
      _sortCompletedTasks(_completedTasks);
      _completedToday = await _repository.getCompletedTodayStats();
      _tasksError = null;
    } catch (e) {
      _tasksError = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    } finally {
      _isTasksLoading = false;
      notifyListeners();
    }
  }

  /// Updates status for a request (e.g. ACCEPTED, IN_PROGRESS, COMPLETED).
  /// On success refreshes tasks. Returns error message or null.
  Future<String?> updateRequestStatus(
    String requestId,
    String status, {
    String? notes,
  }) async {
    try {
      await _repository.updateRequestStatus(requestId, status, notes: notes);
      await loadTasks();
      return null;
    } catch (e) {
      return e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    }
  }
}
