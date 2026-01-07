import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

/// A reusable confirmation dialog for destructive actions.
///
/// This dialog displays a centered icon, title, message, and two action buttons.
/// It's commonly used for delete confirmations but can be customized for any
/// confirmation scenario.
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.close_rounded,
    this.iconColor = AppColors.error500,
    this.iconBackgroundColor = AppColors.error100,
    this.confirmButtonLabel = 'Confirm',
    this.cancelButtonLabel = 'Cancel',
    this.confirmButtonColor,
    this.isDestructive = false,
  });

  /// The title text displayed below the icon.
  final String title;

  /// The message text displayed below the title.
  final String message;

  /// The icon to display at the top of the dialog.
  final IconData icon;

  /// The color of the icon.
  final Color iconColor;

  /// The background color of the icon container.
  final Color iconBackgroundColor;

  /// The label for the confirm button.
  final String confirmButtonLabel;

  /// The label for the cancel button.
  final String cancelButtonLabel;

  /// Optional custom color for the confirm button.
  /// If null, uses error color for destructive actions.
  final Color? confirmButtonColor;

  /// Whether this is a destructive action (affects button styling).
  final bool isDestructive;

  /// Shows a generic confirmation dialog.
  ///
  /// Returns `true` if confirmed, `false` if cancelled.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData icon = Icons.help_outline_rounded,
    Color iconColor = AppColors.primary500,
    Color iconBackgroundColor = AppColors.primary100,
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

  /// Shows a delete confirmation dialog with pre-configured destructive styling.
  ///
  /// Returns `true` if deletion was confirmed, `false` if cancelled.
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
      iconColor: AppColors.error500,
      iconBackgroundColor: AppColors.error100,
      confirmButtonLabel: confirmButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfirmColor = confirmButtonColor ??
        (isDestructive ? AppColors.error500 : theme.primaryColor);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: Sizes.lg),

              // Title
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.sm),

              // Message
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.xl),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.neutral700,
                        side: const BorderSide(color: AppColors.neutral300),
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                      ),
                      child: Text(cancelButtonLabel),
                    ),
                  ),
                  const SizedBox(width: Sizes.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: effectiveConfirmColor,
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                      ),
                      child: Text(confirmButtonLabel),
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
