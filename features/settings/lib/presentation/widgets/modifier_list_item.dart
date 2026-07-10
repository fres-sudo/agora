import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/modifier_group.dart';

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
    final colors = context.colors;
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
          color: colors.card,
          borderRadius: BorderRadius.circular(Sizes.sm),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(Sizes.xs),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                AgoraIcons.filter,
                color: colors.mutedForeground,
                size: 20,
              ),
            ),
            const SizedBox(width: Sizes.md),

            // Name + type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMd(modifierGroup.name),
                  const SizedBox(height: 2),
                  AppText.bodySm(
                    modifierGroup.isMultiSelect
                        ? 'Multi-select'
                        : 'Single-select',
                    color: colors.mutedForeground,
                  ),
                ],
              ),
            ),
            const SizedBox(width: Sizes.lg),

            // Option count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.bodySm('Options', color: colors.mutedForeground),
                AppText.titleMd('$optionCount'),
              ],
            ),
            const SizedBox(width: Sizes.lg),

            // Delete Button
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: const Icon(AgoraIcons.trash, color: AppPalette.neutral500),
              tooltip: 'Delete modifier',
            ),
          ],
        ),
      ),
    );
  }
}
