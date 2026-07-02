import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A general-purpose, token-driven modal dialog.
///
/// Provides a titled popover surface with a content area and an actions row.
/// For the common confirm/cancel case use `ConfirmationDialog`; for bespoke
/// content compose [AppDialog] directly and show it via [AppDialog.show].
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    this.subtitle,
    required this.content,
    this.actions = const [],
    this.maxWidth = 460,
  });

  final String? title;
  final String? subtitle;
  final Widget content;
  final List<Widget> actions;
  final double maxWidth;

  /// Shows this dialog and returns the value passed to `Navigator.pop`.
  static Future<T?> show<T>({
    required BuildContext context,
    required AppDialog dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;

    return Dialog(
      backgroundColor: colors.popover,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: tokens.borderRadiusLg),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                AppText.headingSm(title!),
                if (subtitle != null) ...[
                  SizedBox(height: tokens.spaceXxs),
                  AppText.bodySm(subtitle!, color: colors.mutedForeground),
                ],
                SizedBox(height: tokens.spaceLg),
              ],
              content,
              if (actions.isNotEmpty) ...[
                SizedBox(height: tokens.spaceXl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) SizedBox(width: tokens.spaceSm),
                      actions[i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
