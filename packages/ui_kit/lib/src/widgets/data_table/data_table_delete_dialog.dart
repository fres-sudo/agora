import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Delete confirmation dialog for the data table.
///
/// Shows a warning dialog with a red X icon and Cancel/Delete buttons.
class DataTableDeleteDialog extends StatelessWidget {
  const DataTableDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    this.deleteButtonLabel = 'Yes, Delete',
    this.cancelButtonLabel = 'Cancel',
  });

  final String title;
  final String message;
  final String deleteButtonLabel;
  final String cancelButtonLabel;

  /// Shows the delete confirmation dialog and returns true if deletion was confirmed.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String deleteButtonLabel = 'Yes, Delete',
    String cancelButtonLabel = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DataTableDeleteDialog(
        title: title,
        message: message,
        deleteButtonLabel: deleteButtonLabel,
        cancelButtonLabel: cancelButtonLabel,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(color: context.colors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: EdgeInsets.all(context.tokens.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red X icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.colors.destructive.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AgoraIcons.x_mark,
                  color: context.colors.destructive,
                  size: 32,
                ),
              ),
              SizedBox(height: context.tokens.spacing.md),
              // Title
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.tokens.spacing.xs),
              // Message
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.tokens.spacing.lg),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      onPressed: () => Navigator.of(context).pop(false),
                      label: cancelButtonLabel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.foreground,
                        side: BorderSide(color: context.colors.border),
                        padding: EdgeInsets.symmetric(
                          vertical: context.tokens.spacing.sm,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.tokens.spacing.sm),
                  Expanded(
                    child: AppButton.primary(
                      onPressed: () => Navigator.of(context).pop(true),
                      label: deleteButtonLabel,
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colors.destructive,
                        padding: EdgeInsets.symmetric(
                          vertical: context.tokens.spacing.sm,
                        ),
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
