import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Elevation level mapped to token shadows.
enum AppElevation { none, sm, md, lg }

/// The base "surface" primitive: a rounded, optionally-bordered, optionally
/// elevated container filled with a semantic color.
///
/// Every card/sheet/popover in the system is built on [AppSurface] so radius,
/// border and shadow stay consistent and theme-correct. Defaults to
/// `context.colors.card`.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    this.child,
    this.color,
    this.padding,
    this.borderRadius,
    this.bordered = true,
    this.elevation = AppElevation.none,
    this.width,
    this.height,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool bordered;
  final AppElevation elevation;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  List<BoxShadow>? _shadow(BuildContext context) => switch (elevation) {
    AppElevation.none => null,
    AppElevation.sm => context.tokens.shadowSm,
    AppElevation.md => context.tokens.shadowMd,
    AppElevation.lg => context.tokens.shadowLg,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = borderRadius ?? context.tokens.borderRadiusLg;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? colors.card,
        borderRadius: radius,
        border: bordered
            ? Border.all(
                color: colors.border,
                width: context.tokens.borderHairline,
              )
            : null,
        boxShadow: _shadow(context),
      ),
      clipBehavior: clipBehavior,
      child: child,
    );

    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: content,
        ),
      );
    }
    return content;
  }
}
