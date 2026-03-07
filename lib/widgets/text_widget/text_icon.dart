import 'package:flutter/material.dart';

import 'package:wisecare_agent/widgets/common/svg_image.dart';

/// Tappable icon button using an SVG asset. Use for toolbar/menu icons.
class TextIcon extends StatelessWidget {
  const TextIcon({
    super.key,
    required this.icon,
    this.onTap,
    this.width = 24,
    this.height = 24,
    this.iconColor,
  });

  final String icon;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final child = SvgImage(
      icon,
      width: width,
      height: height,
      color: iconColor,
    );
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
