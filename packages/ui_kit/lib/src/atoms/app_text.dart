import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_typography.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Which named style from [AppTypography] an [AppText] renders with.
enum AppTextVariant {
  displayLg,
  displayMd,
  headingLg,
  headingMd,
  headingSm,
  titleLg,
  titleMd,
  body,
  bodySm,
  label,
  caption,
  mono,
}

/// Text primitive bound to the design-system type scale.
///
/// Colors default to `context.colors.foreground`; pass [color] for semantic
/// emphasis (e.g. `context.colors.mutedForeground`). Never hard-code a hex —
/// the whole point is that the same [AppText] reads correctly in light & dark.
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  });

  // Convenience constructors for the common variants.
  const AppText.displayLg(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.displayLg;
  const AppText.displayMd(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.displayMd;
  const AppText.headingLg(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.headingLg;
  const AppText.headingMd(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.headingMd;
  const AppText.headingSm(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.headingSm;
  const AppText.titleLg(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.titleLg;
  const AppText.titleMd(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.titleMd;
  const AppText.body(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.body;
  const AppText.bodySm(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.bodySm;
  const AppText.label(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.label;
  const AppText.caption(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.caption;
  const AppText.mono(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.semanticsLabel,
  }) : variant = AppTextVariant.mono;

  final String data;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Extra style merged on top of the resolved variant style.
  final TextStyle? style;
  final String? semanticsLabel;

  TextStyle _base(AppTypography t) => switch (variant) {
    AppTextVariant.displayLg => t.displayLg,
    AppTextVariant.displayMd => t.displayMd,
    AppTextVariant.headingLg => t.headingLg,
    AppTextVariant.headingMd => t.headingMd,
    AppTextVariant.headingSm => t.headingSm,
    AppTextVariant.titleLg => t.titleLg,
    AppTextVariant.titleMd => t.titleMd,
    AppTextVariant.body => t.body,
    AppTextVariant.bodySm => t.bodySm,
    AppTextVariant.label => t.label,
    AppTextVariant.caption => t.caption,
    AppTextVariant.mono => t.mono,
  };

  @override
  Widget build(BuildContext context) {
    final resolved = _base(
      context.typography,
    ).copyWith(color: color ?? context.colors.foreground).merge(style);
    return Text(
      data,
      style: resolved,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
    );
  }
}
