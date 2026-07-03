import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_button.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A reusable confirmation dialog for destructive or important actions.
///
/// Displays a centered icon, title, message, and cancel/confirm buttons. Colors
/// default to semantic tokens resolved from context (so it is theme-correct);
/// pass [iconColor]/[iconBackgroundColor]/[confirmButtonColor] to override.
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.close_rounded,
    this.iconColor,
    this.iconBackgroundColor,
    this.confirmButtonLabel = 'Confirm',
    this.cancelButtonLabel = 'Cancel',
    this.confirmButtonColor,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String confirmButtonLabel;
  final String cancelButtonLabel;
  final Color? confirmButtonColor;
  final bool isDestructive;

  /// Shows a generic confirmation dialog. Returns `true` if confirmed.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData icon = Icons.help_outline_rounded,
    Color? iconColor,
    Color? iconBackgroundColor,
    String confirmButtonLabel = 'Confirm',
    String cancelButtonLabel = 'Cancel',
    Color? confirmButtonColor,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        iconBackgroundColor: iconBackgroundColor,
        confirmButtonLabel: confirmButtonLabel,
        cancelButtonLabel: cancelButtonLabel,
        confirmButtonColor: confirmButtonColor,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  /// Shows a delete confirmation with destructive styling. Returns `true` if confirmed.
  static Future<bool> showDelete({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonLabel = 'Yes, Delete',
    String cancelButtonLabel = 'Cancel',
  }) async {
    return show(
      context: context,
      title: title,
      message: message,
      icon: Icons.close_rounded,
      confirmButtonLabel: confirmButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final accent = iconColor ??
        (isDestructive ? colors.destructive : colors.primary);
    final accentBg = iconBackgroundColor ?? accent.withValues(alpha: 0.12);

    return Dialog(
      backgroundColor: colors.popover,
      shape: RoundedRectangleBorder(borderRadius: tokens.borderRadiusLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 32),
              ),
              SizedBox(height: tokens.spaceLg),
              AppText.titleLg(title, textAlign: TextAlign.center),
              SizedBox(height: tokens.spaceSm),
              AppText.bodySm(
                message,
                color: colors.mutedForeground,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.spaceXl),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      onPressed: () => Navigator.of(context).pop(false),
                      label: cancelButtonLabel,
                      fullWidth: true,
                    ),
                  ),
                  SizedBox(width: tokens.spaceMd),
                  Expanded(
                    child: isDestructive
                        ? AppButton.destructive(
                            onPressed: () => Navigator.of(context).pop(true),
                            label: confirmButtonLabel,
                            fullWidth: true,
                          )
                        : AppButton.primary(
                            onPressed: () => Navigator.of(context).pop(true),
                            label: confirmButtonLabel,
                            fullWidth: true,
                            style: confirmButtonColor == null
                                ? null
                                : FilledButton.styleFrom(
                                    backgroundColor: confirmButtonColor,
                                  ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
