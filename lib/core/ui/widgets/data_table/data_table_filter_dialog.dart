import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

/// Generic filter dialog shell for the data table.
///
/// Provides a consistent dialog structure with title, scrollable content,
/// and Cancel/Apply buttons. The actual filter fields are provided via [child].
class DataTableFilterDialog extends StatelessWidget {
  const DataTableFilterDialog({
    super.key,
    required this.child,
    this.title = 'Filters',
    this.onCancel,
    this.onApply,
  });

  final Widget child;
  final String title;
  final VoidCallback? onCancel;
  final VoidCallback? onApply;

  /// Shows the filter dialog and returns true if filters were applied.
  static Future<bool?> show({
    required BuildContext context,
    required Widget child,
    String title = 'Filters',
    VoidCallback? onApply,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DataTableFilterDialog(
        title: title,
        onCancel: () => Navigator.of(context).pop(false),
        onApply: () {
          onApply?.call();
          Navigator.of(context).pop(true);
        },
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.lg),
              // Filter content
              Flexible(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
              const SizedBox(height: Sizes.lg),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.neutral700,
                        side: const BorderSide(color: AppColors.neutral300),
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: Sizes.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: onApply,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                      ),
                      child: const Text('Apply'),
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
