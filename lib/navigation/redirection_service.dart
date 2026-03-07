import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:wisecare_agent/navigation/routes.dart';

/// Redirect logic. After splash init, redirect to home.
class RedirectionService {
  RedirectionService._();

  static void redirectAfterSplash(BuildContext context) {
    context.go(AppRoutes.home.path);
  }
}
