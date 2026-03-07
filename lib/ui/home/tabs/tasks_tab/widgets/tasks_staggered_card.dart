part of '../tasks_tab_screen.dart';

/// Wraps a task card with a short fade-in so new tasks don't pop in.
class _StaggeredTaskCard extends StatefulWidget {
  const _StaggeredTaskCard({required this.index, required this.task});

  final int index;
  final AgentTaskModel task;

  @override
  State<_StaggeredTaskCard> createState() => _StaggeredTaskCardState();
}

class _StaggeredTaskCardState extends State<_StaggeredTaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future<void>.delayed(
      Duration(milliseconds: widget.index * 60),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.task.priority == AgentTaskPriority.high
        ? _TasksHighPriorityCard(task: widget.task)
        : _TasksMediumPriorityCard(task: widget.task);
    return Padding(
      padding: const EdgeInsets.only(bottom: _TasksTabDimens.contentGap),
      child: FadeTransition(
        opacity: _opacity,
        child: card,
      ),
    );
  }
}
