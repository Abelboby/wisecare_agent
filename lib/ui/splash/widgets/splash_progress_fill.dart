import 'package:flutter/material.dart';

/// Constrains its child to a fraction of the parent's width.
/// Used only on the splash screen for the progress bar fill.
class SplashProgressFill extends StatelessWidget {
  const SplashProgressFill({
    super.key,
    required this.widthFactor,
    required this.child,
  });

  final double widthFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth * widthFactor.clamp(0.0, 1.0);
        return SizedBox(width: width, child: child);
      },
    );
  }
}
