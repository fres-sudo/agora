import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A centered placeholder for empty lists / no-data screens.
///
/// TODO(design-system): add illustration slot and compact inline variant.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 48, color: colors.mutedForeground),
              SizedBox(height: tokens.spaceMd),
            ],
            AppText.titleLg(title, textAlign: TextAlign.center),
            if (message != null) ...[
              SizedBox(height: tokens.spaceXs),
              AppText.bodySm(
                message!,
                color: colors.mutedForeground,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: tokens.spaceLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
