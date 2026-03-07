import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/enums/app_enums.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/ui/home/tabs/map_tab/map_tab_screen.dart';
import 'package:wisecare_agent/ui/home/tabs/profile_tab/profile_tab_screen.dart';
import 'package:wisecare_agent/ui/home/tabs/tasks_tab/tasks_tab_screen.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'home_functions.dart';
part 'home_variables.dart';
part 'widgets/home_bottom_nav.dart';

/// Home screen: Tasks, Map, Profile tabs. Follows NEW_SCREEN_DEV structure.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          switch (provider.currentTab) {
            case AppTab.tasks:
              return const TasksTabScreen();
            case AppTab.map:
              return const MapTabScreen();
            case AppTab.profile:
              return const ProfileTabScreen();
          }
        },
      ),
      bottomNavigationBar: const _HomeBottomNav(),
    );
  }
}
