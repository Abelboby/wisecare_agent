import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:wisecare_agent/provider/login_provider.dart';
import 'package:wisecare_agent/provider/splash_provider.dart';

/// Centralized provider registration.
/// Theme is NOT managed via Provider — see Skin (theme/theme_manager.dart).
class ProviderRegister {
  ProviderRegister._();

  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider<SplashProvider>(
        create: (_) => SplashProvider(),
      ),
      ChangeNotifierProvider<LoginProvider>(
        create: (_) => LoginProvider(),
      ),
    ];
  }

  static void clearProviders(BuildContext context) {
    context.read<LoginProvider>().clearError();
  }
}
