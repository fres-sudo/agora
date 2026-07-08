import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_surface.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A content container built on [AppSurface] with an optional titled header.
///
/// ```dart
/// AppCard(
///   title: 'Revenue',
///   trailing: AppBadge('+12%', variant: AppBadgeVariant.success),
///   child: Text('...'),
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.footer,
    this.padding,
    this.onTap,
    this.elevation = AppElevation.sm,
  });

  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? footer;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final AppElevation elevation;

  bool get _hasHeader => title != null || subtitle != null || trailing != null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppSurface(
      onTap: onTap,
      elevation: elevation,
      padding: padding ?? EdgeInsets.all(tokens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasHeader) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) AppText.titleLg(title!),
                      if (subtitle != null) ...[
                        SizedBox(height: tokens.spaceXxs),
                        AppText.bodySm(
                          subtitle!,
                          color: context.colors.mutedForeground,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: tokens.spaceSm),
                  trailing!,
                ],
              ],
            ),
            if (child != null) SizedBox(height: tokens.spaceMd),
          ],
          if (child != null) child!,
          if (footer != null) ...[SizedBox(height: tokens.spaceMd), footer!],
        ],
      ),
    );
  }
}
