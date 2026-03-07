import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

/// Placeholder for Map tab. Replace with map implementation.
class MapTabScreen extends StatelessWidget {
  const MapTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map_outlined,
                size: 64,
                color: Skin.color(Co.loginSubtitle),
              ),
              const SizedBox(height: 16),
              Text(
                'Map',
                style: GoogleFonts.lexend(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Skin.color(Co.loginHeading),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Map view coming soon',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: Skin.color(Co.loginSubtitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
