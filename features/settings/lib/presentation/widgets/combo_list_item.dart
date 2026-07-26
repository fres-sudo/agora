import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/combo.dart';

/// A list item widget for displaying and editing a combo.
class ComboListItem extends StatelessWidget {
  const ComboListItem({
    super.key,
    required this.combo,
    required this.onTap,
    required this.onDelete,
  });

  final Combo combo;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final itemCount = combo.items.length;

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
                AgoraIcons.gift,
                color: colors.mutedForeground,
                size: 20,
              ),
            ),
            const SizedBox(width: Sizes.md),

            // Name + status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMd(combo.name),
                  SizedBox(height: context.tokens.spaceXxs),
                  AppText.bodySm(
                    combo.isEnabled ? 'Enabled' : 'Disabled',
                    color: colors.mutedForeground,
                  ),
                ],
              ),
            ),
            const SizedBox(width: Sizes.lg),

            // Price + item count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.titleMd(context.formatCurrency(combo.priceCents)),
                AppText.bodySm(
                  '$itemCount item${itemCount == 1 ? '' : 's'}',
                  color: colors.mutedForeground,
                ),
              ],
            ),
            const SizedBox(width: Sizes.lg),

            // Delete Button
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: Icon(AgoraIcons.trash, color: colors.mutedForeground),
              tooltip: 'Delete combo',
            ),
          ],
        ),
      ),
    );
  }
}
