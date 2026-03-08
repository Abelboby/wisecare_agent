import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'task_details_variables.dart';
part 'task_details_functions.dart';
part 'widgets/task_detail_header.dart';
part 'widgets/request_section.dart';
part 'widgets/elderly_section.dart';
part 'widgets/status_button.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final AgentTaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  String get _assignedSubtitle {
    final time = widget.task.scheduledAt;
    if (time != null && time.isNotEmpty) {
      return 'ASSIGNED: TODAY, $time';
    }
    return 'ASSIGNED: TODAY';
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.task.status?.toUpperCase() ?? 'ASSIGNED';
    final buttonLabel = _TaskDetailsFunctions.buttonLabel(status);

    return Scaffold(
      backgroundColor: Skin.color(Co.background),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TaskDetailHeader(
              taskId: widget.task.id,
              assignedSubtitle: _assignedSubtitle,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: _TaskDetailsDimens.scrollViewBottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RequestSection(task: widget.task),
                    _ElderlySection(
                      task: widget.task,
                      onCall: () => _callElderly(context),
                      onOpenMap: () => _openMap(context),
                    ),
                  ],
                ),
              ),
            ),
            if (buttonLabel != null)
              _TaskActionButton(
                label: buttonLabel,
                onPressed: () => _submitUpdateStatus(context),
              ),
          ],
        ),
      ),
    );
  }
}
