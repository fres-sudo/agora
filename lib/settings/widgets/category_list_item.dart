import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/products/models/category/category.dart';

/// A list item widget for displaying and editing a category.
class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.category,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    // Deprecated/Unused but kept for signature compatibility if needed,
    // though ideally should be removed from parent first.
    // I will remove it from constructor as I updated parent already to not use name change.
    // Wait, I updated parent to pass `onNameChanged: (name) => {}` and `onTap`.
    // So I should Clean up the signature.
  });

  final Category category;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using InkWell for tap effect
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.lg,
          vertical: Sizes.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutral50,
          borderRadius: BorderRadius.circular(Sizes.sm),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            // Toggle Switch
            Switch(
              value: category.isEnabled,
              onChanged: onToggle,
              activeTrackColor: AppColors.primary500.withValues(alpha: 0.5),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary500;
                }
                return null;
              }),
            ),
            const SizedBox(width: Sizes.md),

            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: category.color ?? Colors.white,
                borderRadius: BorderRadius.circular(Sizes.xs),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Icon(
                category.icon ?? Icons.category,
                color: _getIconColor(category.color),
                size: 20,
              ),
            ),
            const SizedBox(width: Sizes.md),

            // Category Name
            Expanded(
              child: Text(
                category.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: Sizes.lg),

            // Product Count (Placeholder for now as in original)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Product',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
                Text(
                  '0',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: Sizes.lg),

            // Delete Button
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.neutral500,
              ),
              tooltip: 'Delete category',
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(Color? backgroundColor) {
    if (backgroundColor == null) return AppColors.neutral600;
    // Simple check for darkness to decide icon color (white or black/grey)
    // This is a basic approximation.
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppColors.neutral800 : Colors.white;
  }
}

