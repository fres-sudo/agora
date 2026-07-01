import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/domain/models/modifier_group.dart';

/// A list item widget for displaying and editing a modifier group.
class ModifierListItem extends StatelessWidget {
  const ModifierListItem({
    super.key,
    required this.modifierGroup,
    required this.onTap,
    required this.onDelete,
  });

  final ModifierGroup modifierGroup;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final optionCount = modifierGroup.options.length;

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
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.xs),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: const Icon(
                Icons.tune_outlined,
                color: AppColors.neutral600,
                size: 20,
              ),
            ),
            const SizedBox(width: Sizes.md),

            // Name + type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modifierGroup.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    modifierGroup.isMultiSelect
                        ? 'Multi-select'
                        : 'Single-select',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Sizes.lg),

            // Option count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Options',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
                Text(
                  '$optionCount',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: Sizes.lg),

            // Delete Button
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.neutral500,
              ),
              tooltip: 'Delete modifier',
            ),
          ],
        ),
      ),
    );
  }
}
