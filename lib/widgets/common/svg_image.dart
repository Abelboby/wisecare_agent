import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays an SVG asset with optional tint, size, and fit.
class SvgImage extends StatelessWidget {
  const SvgImage(
    this.assetPath, {
    super.key,
    this.color,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
