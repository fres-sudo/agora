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
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red X icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppPalette.error100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppPalette.error500,
                  size: 32,
                ),
              ),
              const SizedBox(height: Sizes.lg),
              // Title
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.sm),
              // Message
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppPalette.neutral500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.xl),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      onPressed: () => Navigator.of(context).pop(false),
                      label: cancelButtonLabel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.neutral700,
                        side: const BorderSide(color: AppPalette.neutral300),
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.md),
                  Expanded(
                    child: AppButton.primary(
                      onPressed: () => Navigator.of(context).pop(true),
                      label: deleteButtonLabel,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppPalette.error500,
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
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
