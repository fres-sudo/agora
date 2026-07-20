import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Generic filter surface for the data table.
///
/// Presents [child] with a title and Cancel/Apply actions, as a dialog on
/// tablet/desktop and a draggable sheet on a phone — filters are a small form,
/// and a phone-width dialog with a keyboard open is unworkable.
class DataTableFilterDialog extends StatelessWidget {
  const DataTableFilterDialog({
    super.key,
    required this.child,
    this.title = 'Filters',
    this.onCancel,
    this.onApply,
    this.scrollController,
  });

  final Widget child;
  final String title;
  final VoidCallback? onCancel;
  final VoidCallback? onApply;
  final ScrollController? scrollController;

  /// Shows the filter surface and returns true if filters were applied.
  static Future<bool?> show({
    required BuildContext context,
    required Widget child,
    String title = 'Filters',
    VoidCallback? onApply,
  }) {
    return AdaptiveModal.show<bool>(
      context: context,
      maxWidth: 400,
      builder: (context, scrollController) => DataTableFilterDialog(
        title: title,
        scrollController: scrollController,
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
    return AppSheetScaffold(
      title: title,
      scrollController: scrollController,
      body: child,
      actions: [
        AppButton.outline(
          onPressed: onCancel,
          label: 'Cancel',
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colors.foreground,
            side: BorderSide(color: context.colors.border),
            padding: const EdgeInsets.symmetric(vertical: Sizes.md),
          ),
        ),
        AppButton.primary(
          onPressed: onApply,
          label: 'Apply',
          style: FilledButton.styleFrom(
            backgroundColor: context.colors.primary,
            padding: const EdgeInsets.symmetric(vertical: Sizes.md),
          ),
        ),
      ],
    );
  }
}
