import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ui_kit/src/data/product_icon_catalog.dart';

/// Renders a curated product icon without losing opacity-bearing treatments.
///
/// Bulk and two-tone icons use their original SVG because an [IconData] glyph
/// cannot encode per-path opacity. Outline and solid icons stay on the icon
/// font so existing sizing, theming, and persistence remain unchanged.
class AppProductIcon extends StatelessWidget {
  const AppProductIcon({
    required this.icon,
    required this.type,
    this.size,
    this.color,
    super.key,
  });

  final ProductIcon icon;
  final ProductIconType type;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return buildProductIconVisual(
      icon: icon,
      type: type,
      size: size,
      color: color,
      iconTheme: IconTheme.of(context),
    );
  }
}

/// Builds the concrete font or SVG visual for an [AppProductIcon].
///
/// Kept separate from the widget's context lookup so renderer selection can be
/// regression-tested without asking `flutter_svg` to rasterize in a widget test.
Widget buildProductIconVisual({
  required ProductIcon icon,
  required ProductIconType type,
  required IconThemeData iconTheme,
  double? size,
  Color? color,
}) {
  final assetPath = icon.assetPathFor(type);
  if (assetPath == null) {
    return Icon(icon.iconFor(type), size: size, color: color);
  }

  final resolvedSize = size ?? iconTheme.size ?? 24;
  final resolvedColor = color ?? iconTheme.color;

  return SvgPicture.asset(
    assetPath,
    package: 'ui_kit',
    width: resolvedSize,
    height: resolvedSize,
    fit: BoxFit.contain,
    colorFilter: resolvedColor == null
        ? null
        : ColorFilter.mode(resolvedColor, BlendMode.srcIn),
  );
}
