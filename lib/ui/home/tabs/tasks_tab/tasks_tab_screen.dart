import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/models/home/completed_today_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'tasks_tab_variables.dart';
part 'tasks_tab_functions.dart';
part 'widgets/tasks_header.dart';
part 'widgets/tasks_active_section.dart';
part 'widgets/tasks_empty_state.dart';
part 'widgets/tasks_high_priority_card.dart';
part 'widgets/tasks_medium_priority_card.dart';
part 'widgets/tasks_completed_today_section.dart';
part 'widgets/tasks_staggered_card.dart';

/// Tasks tab: header, active tasks list, completed today stats.
class TasksTabScreen extends StatefulWidget {
  const TasksTabScreen({super.key});

  @override
  State<TasksTabScreen> createState() => _TasksTabScreenState();
}

class _TasksTabScreenState extends State<TasksTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
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
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, homeProvider, _) {
                  if (homeProvider.isTasksLoading && homeProvider.activeTasks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final hasTasks = homeProvider.activeTasks.isNotEmpty;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: hasTasks
                        ? SingleChildScrollView(
                            key: const ValueKey<bool>(true),
                            padding: const EdgeInsets.fromLTRB(
                              _TasksTabDimens.contentPaddingH,
                              _TasksTabDimens.contentPaddingTop,
                              _TasksTabDimens.contentPaddingH,
                              _TasksTabDimens.contentPaddingBottom,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _TasksActiveSection(),
                                const SizedBox(height: _TasksTabDimens.contentGap),
                                ...homeProvider.activeTasks
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map<Widget>((e) => _StaggeredTaskCard(
                                          index: e.key,
                                          task: e.value,
                                        )),
                                const SizedBox(height: _TasksTabDimens.contentGap),
                                const _TasksCompletedTodaySection(),
                              ],
                            ),
                          )
                        : CustomScrollView(
                            key: const ValueKey<bool>(false),
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  _TasksTabDimens.contentPaddingH,
                                  _TasksTabDimens.contentPaddingTop,
                                  _TasksTabDimens.contentPaddingH,
                                  0,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const _TasksActiveSection(),
                                      const SizedBox(height: _TasksTabDimens.contentGap),
                                    ],
                                  ),
                                ),
                              ),
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
