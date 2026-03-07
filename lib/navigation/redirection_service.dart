import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:wisecare_agent/navigation/routes.dart';
import 'package:wisecare_agent/services/auth_storage_service.dart';

/// Redirect logic after splash initialization.
class RedirectionService {
  RedirectionService._();

  /// Checks for a stored auth token. Navigates to home if authenticated,
  /// otherwise navigates to login.
  static Future<void> redirectAfterSplash(BuildContext context) async {
    final hasToken = await AuthStorageService.hasStoredAuthToken();
    if (!context.mounted) return;
    if (hasToken) {
      context.go(AppRoutes.home.path);
    } else {
      context.go(AppRoutes.login.path);
    }
  }
}
