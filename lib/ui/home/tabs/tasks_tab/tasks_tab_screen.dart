import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/ui/home/tabs/tasks_tab/task_details_view/task_details_screen.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'tasks_tab_variables.dart';
part 'tasks_tab_functions.dart';
part 'widgets/tasks_header.dart';
part 'widgets/tasks_tab_bar.dart';
part 'widgets/tasks_search_filter.dart';
part 'widgets/tasks_request_card.dart';
part 'widgets/tasks_empty_state.dart';
part 'widgets/tasks_completed_today_section.dart';

/// Tasks tab: header, active tasks list, completed today stats.
class TasksTabScreen extends StatefulWidget {
  const TasksTabScreen({super.key});

  @override
  State<TasksTabScreen> createState() => _TasksTabScreenState();
}

class _TasksTabScreenState extends State<TasksTabScreen> {
  Timer? _pollTimer;
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  String _statusFilter = 'All Active';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
    _pollTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (!mounted) return;
      context.read<HomeProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  List<AgentTaskModel> _filterTasks(List<AgentTaskModel> tasks) {
    if (_selectedTabIndex != 0) return tasks;
    var list = tasks;
    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((t) {
        final name = (t.customerName ?? '').toLowerCase();
        final id = t.id.toLowerCase();
        return name.contains(query) || id.contains(query);
      }).toList();
    }
    if (_statusFilter == 'All Active') return list;
    final statusMap = <String, String>{
      'Assigned': 'ASSIGNED',
      'Accepted': 'ACCEPTED',
      'In Progress': 'IN_PROGRESS',
    };
    final status = statusMap[_statusFilter];
    if (status == null) return list;
    return list.where((t) => t.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TasksHeader(),
            _TasksTabBar(
              selectedIndex: _selectedTabIndex,
              onTap: (index) => setState(() => _selectedTabIndex = index),
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, _) {
                if (homeProvider.tasksError != null && homeProvider.tasksError!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _TasksTabDimens.contentPaddingH,
                      vertical: 8,
                    ),
                    child: Material(
                      color: Skin.color(Co.error).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 20,
                              color: Skin.color(Co.error),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                homeProvider.tasksError!,
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  color: Skin.color(Co.error),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.read<HomeProvider>().loadTasks(),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.lexend(
                                  fontWeight: FontWeight.w600,
                                  color: Skin.color(Co.error),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            if (_selectedTabIndex == 0)
              _TasksSearchFilter(
                searchQuery: _searchQuery,
                onSearchChanged: (v) => setState(() => _searchQuery = v),
                selectedFilter: _statusFilter,
                onFilterChanged: (v) => setState(() => _statusFilter = v),
              ),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, homeProvider, _) {
                  if (homeProvider.isTasksLoading &&
                      homeProvider.activeTasks.isEmpty &&
                      homeProvider.completedTasks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_selectedTabIndex == 1) {
                    final completed = homeProvider.completedTasks;
                    if (completed.isEmpty) {
                      return Center(
                        child: Text(
                          'No history yet',
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            color: Skin.color(Co.loginSubtitle),
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        _TasksTabDimens.contentPaddingH,
                        12,
                        _TasksTabDimens.contentPaddingH,
                        _TasksTabDimens.contentPaddingBottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: completed
                            .asMap()
                            .entries
                            .map<Widget>(
                              (e) => Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  bottom: _TasksTabDimens.contentGap,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => TaskDetailsScreen(task: e.value),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(_TasksTabDimens.cardRadius),
                                  child: _TasksRequestCard(
                                    task: e.value,
                                    index: e.key,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }
                  final filtered = _filterTasks(homeProvider.activeTasks);
                  final hasTasks = filtered.isNotEmpty;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: hasTasks
                        ? SingleChildScrollView(
                            key: const ValueKey<bool>(true),
                            padding: const EdgeInsets.fromLTRB(
                              _TasksTabDimens.contentPaddingH,
                              4,
                              _TasksTabDimens.contentPaddingH,
                              _TasksTabDimens.contentPaddingBottom,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...filtered.asMap().entries.map<Widget>(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          bottom: _TasksTabDimens.contentGap,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder: (_) => TaskDetailsScreen(task: e.value),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(_TasksTabDimens.cardRadius),
                                          child: _TasksRequestCard(
                                            task: e.value,
                                            index: e.key,
                                          ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: _TasksTabDimens.contentGap),
                                const _TasksCompletedTodaySection(),
                              ],
                            ),
                          )
                        : CustomScrollView(
                            key: const ValueKey<bool>(false),
                            slivers: [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: _TasksTabDimens.contentPaddingH),
                                  child: Column(
                                    children: [
                                      const Expanded(child: _TasksEmptyState()),
                                      const SizedBox(height: _TasksTabDimens.contentGap),
                                      const _TasksCompletedTodaySection(),
                                      const SizedBox(height: _TasksTabDimens.contentPaddingBottom),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
