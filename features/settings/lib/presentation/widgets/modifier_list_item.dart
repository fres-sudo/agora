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
      borderRadius: BorderRadius.circular(context.tokens.radius.sm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.tokens.spacing.md,
          vertical: context.tokens.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(context.tokens.radius.sm),
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
                borderRadius: BorderRadius.circular(context.tokens.radius.xs),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                AgoraIcons.filter,
                color: colors.mutedForeground,
                size: 20,
              ),
            ),
            SizedBox(width: context.tokens.spacing.sm),

            // Name + type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMd(modifierGroup.name),
                  SizedBox(height: context.tokens.spacing.xxs),
                  AppText.bodySm(
                    modifierGroup.isMultiSelect
                        ? 'Multi-select'
                        : 'Single-select',
                    color: colors.mutedForeground,
                  ),
                ],
              ),
            ),
            SizedBox(width: context.tokens.spacing.md),

            // Option count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.bodySm('Options', color: colors.mutedForeground),
                AppText.titleMd('$optionCount'),
              ],
            ),
            SizedBox(width: context.tokens.spacing.md),

            // Delete Button
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: Icon(AgoraIcons.trash, color: colors.mutedForeground),
              tooltip: 'Delete modifier',
            ),
          ],
        ),
      ),
    );
  }
}
