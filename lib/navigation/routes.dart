import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:wisecare_agent/navigation/app_route_model.dart';
import 'package:wisecare_agent/ui/splash/splash_screen.dart';
import 'package:wisecare_agent/ui/login/login_screen.dart';
import 'package:wisecare_agent/ui/home/home_screen.dart';

/// All app routes. Register here and add to [all].
abstract class AppRoutes {
  AppRoutes._();

  static final AppRoute splash = AppRoute(
    path: '/',
    name: 'Splash',
    builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
  );

  static final AppRoute home = AppRoute(
    path: '/home',
    name: 'Home',
    builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
  );

  static final AppRoute login = AppRoute(
    path: '/login',
    name: 'Login',
    builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
  );

  static List<AppRoute> get all => [splash, home, login];
}
