import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

/// A reusable empty state widget for the POS system.
/// Displays an icon, title, optional description, and optional action button.
class PosEmptyState extends StatelessWidget {
  /// The icon to display in the center.
  final IconData icon;

  /// The main title text.
  final String title;

  /// Optional description text below the title.
  final String? description;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional callback when action button is tapped.
  final VoidCallback? onAction;

  /// The size of the icon. Defaults to 48.
  final double iconSize;

  const PosEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.tokens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with circular background
            Container(
              width: iconSize * 2,
              height: iconSize * 2,
              decoration: BoxDecoration(
                color: colors.muted,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: iconSize, color: colors.mutedForeground),
                  // Question mark badge
                  Positioned(
                    right: iconSize * 0.15,
                    bottom: iconSize * 0.15,
                    child: Container(
                      width: iconSize * 0.5,
                      height: iconSize * 0.5,
                      decoration: BoxDecoration(
                        color: colors.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border, width: 2),
                      ),
                      child: Icon(
                        AgoraIcons.help_circle,
                        size: iconSize * 0.3,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.tokens.spaceMd),
            // Title
            AppText.titleMd(title, textAlign: TextAlign.center),
            // Description
            if (description != null) ...[
              SizedBox(height: context.tokens.spaceXs),
              AppText.body(
                description!,
                color: colors.mutedForeground,
                textAlign: TextAlign.center,
              ),
            ],
            // Action button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: context.tokens.spaceMd),
              AppButton.primary(
                onPressed: onAction,
                label: actionLabel!,
                leadingIcon: const Icon(AgoraIcons.plus),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
