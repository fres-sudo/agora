import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/category.dart';

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
    final colors = context.colors;

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
          color: colors.card,
          borderRadius: BorderRadius.circular(Sizes.sm),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            // Toggle Switch
            Switch(
              value: category.isEnabled,
              onChanged: onToggle,
              activeTrackColor: colors.primary.withValues(alpha: 0.5),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colors.primary;
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
                color: category.color ?? colors.muted,
                borderRadius: BorderRadius.circular(Sizes.xs),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                category.icon ?? AgoraIcons.categories,
                color: _getIconColor(colors, category.color),
                size: 20,
              ),
            ),
            const SizedBox(width: Sizes.md),

            // Category Name
            Expanded(child: AppText.titleMd(category.name)),
            const SizedBox(width: Sizes.lg),

            // Product Count (Placeholder for now as in original)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.bodySm('Total Product', color: colors.mutedForeground),
                const AppText.titleMd('0'),
              ],
            ),
            const SizedBox(width: Sizes.lg),

            // Delete Button
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: Icon(AgoraIcons.trash, color: colors.mutedForeground),
              tooltip: 'Delete category',
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(AppColors colors, Color? backgroundColor) {
    if (backgroundColor == null) return colors.mutedForeground;
    // Contrast the icon against the category's (data) color, not the theme.
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppPalette.neutral800 : AppPalette.white;
  }
}
