import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/gen/assets.gen.dart';
import 'package:wisecare_agent/navigation/redirection_service.dart';
import 'package:wisecare_agent/provider/splash_provider.dart';
import 'package:wisecare_agent/ui/splash/widgets/splash_progress_fill.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'splash_functions.dart';
part 'widgets/splash_sections.dart';

/// Splash screen with logo, title, and animated 0–100% loading indicator.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _progressController;
  bool _hasRedirected = false;

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _progressController.addListener(_refresh);
    _progressController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SplashProvider>().loadInitialData();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.gradientTop),
      body: Consumer<SplashProvider>(
        builder: (context, provider, _) {
          _checkRedirect(provider); // from splash_functions.dart
          return Stack(
            children: [
              const _DecorativeBlurs(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LogoSection(),
                    const SizedBox(height: 32),
                    const _SplashTitle(),
                    const SizedBox(height: 8),
                    const _SplashSubtitle(),
                  ],
                ),
              ),
              Positioned(
                left: 32,
                right: 32,
                bottom: 64,
                child: _SplashFooter(progress: _progressController.value),
              ),
            ],
          );
        },
      ),
    );
  }
}
