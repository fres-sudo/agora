import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';

import 'package:ui_kit/src/theme/context_extensions.dart';

import 'package:ui_kit/src/theme/agora_icons.dart';

/// Severity/tone of an [AppAlert].
enum AppAlertVariant { info, success, warning, destructive, neutral }

/// An inline callout for contextual feedback (info, success, warning, errors).
///
/// Tints are derived from the semantic token for the [variant] with alpha, so
/// they read correctly on both light and dark backgrounds without bespoke
/// per-theme colors.
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.message,
    this.title,
    this.variant = AppAlertVariant.info,
    this.icon,
    this.action,
  });

  final String message;
  final String? title;
  final AppAlertVariant variant;
  final IconData? icon;
  final Widget? action;

  Color _accent(BuildContext context) {
    final c = context.colors;
    return switch (variant) {
      AppAlertVariant.info => c.info,
      AppAlertVariant.success => c.success,
      AppAlertVariant.warning => c.warning,
      AppAlertVariant.destructive => c.destructive,
      AppAlertVariant.neutral => c.mutedForeground,
    };
  }

  IconData _defaultIcon() => switch (variant) {
    AppAlertVariant.info => AgoraIcons.info,
    AppAlertVariant.success => AgoraIcons.check,
    AppAlertVariant.warning => AgoraIcons.alert,
    AppAlertVariant.destructive => AgoraIcons.alert,
    AppAlertVariant.neutral =>
      AgoraIcons
          .invoice, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.notes_rounded
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final accent = _accent(context);

    return Semantics(
      container: true,
      liveRegion: variant == AppAlertVariant.destructive,
      child: Container(
        padding: EdgeInsets.all(tokens.spaceMd),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.10),
          borderRadius: tokens.borderRadiusMd,
          border: Border.all(
            color: accent.withValues(alpha: 0.35),
            width: tokens.borderHairline,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? _defaultIcon(), color: accent, size: tokens.iconMd),
            SizedBox(width: tokens.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    AppText.titleMd(title!),
                    SizedBox(height: tokens.spaceXxs),
                  ],
                  AppText.bodySm(message, color: colors.foreground),
                  if (action != null) ...[
                    SizedBox(height: tokens.spaceSm),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
