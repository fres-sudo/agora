import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

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
                  color: AppColors.error100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.error500,
                  size: 32,
                ),
              ),
              const SizedBox(height: Sizes.lg),
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.sm),
              // Message
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        backgroundColor: AppColors.error500,
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                      ),
                      child: Text(deleteButtonLabel),
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
