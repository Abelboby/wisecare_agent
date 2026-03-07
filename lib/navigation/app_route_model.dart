import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Single route definition: path, name, builder. Optional slide transition and children.
class AppRoute {
  const AppRoute({
    required this.path,
    required this.name,
    required this.builder,
    this.useSlideTransition = false,
    this.children = const [],
  });

  final String path;
  final String name;
  final Widget Function(BuildContext context, GoRouterState state) builder;
  final bool useSlideTransition;
  final List<AppRoute> children;
}
