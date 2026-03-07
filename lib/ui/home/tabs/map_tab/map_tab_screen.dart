import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'map_tab_variables.dart';
part 'widgets/map_placeholder.dart';

/// Placeholder for Map tab. Replace with map implementation.
class MapTabScreen extends StatelessWidget {
  const MapTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: SafeArea(
        child: Center(
          child: const _MapPlaceholder(),
        ),
      ),
    );
  }
}
