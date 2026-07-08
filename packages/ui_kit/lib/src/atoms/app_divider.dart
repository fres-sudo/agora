import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A hairline separator using `context.colors.border`.
///
/// Works horizontally or vertically; thickness comes from
/// `context.tokens.borderHairline`.
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.indent = 0,
    this.endIndent = 0,
    this.spacing,
  });

  const AppDivider.vertical({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.spacing,
  }) : axis = Axis.vertical;

  final Axis axis;
  final double indent;
  final double endIndent;

  /// Total cross-axis space the divider occupies (defaults to the line width).
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.border;
    final thickness = context.tokens.borderHairline;
    final space = spacing ?? thickness;
    if (axis == Axis.horizontal) {
      return Divider(
        color: color,
        thickness: thickness,
        height: space,
        indent: indent,
        endIndent: endIndent,
      );
    }
    return VerticalDivider(
      color: color,
      thickness: thickness,
      width: space,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
