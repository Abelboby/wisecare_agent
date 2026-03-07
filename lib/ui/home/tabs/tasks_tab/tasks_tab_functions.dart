part of 'tasks_tab_screen.dart';

extension _TasksTabScreenFunctions on _TasksTabScreenState {
  void _loadInitialData() {
    if (!mounted) return;
    context.read<ProfileProvider>().loadProfile();
    context.read<HomeProvider>().loadTasks();
  }
}
