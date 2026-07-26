import 'package:catalog/models/catalog_template.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

const _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// A list item widget for a saved catalog template
/// (docs/features/06-season-to-season-catalog-reuse.md).
class CatalogTemplateListItem extends StatelessWidget {
  const CatalogTemplateListItem({
    super.key,
    required this.template,
    required this.onRestore,
    required this.onDelete,
  });

  final CatalogTemplate template;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  String get _itemCountLabel {
    final snapshot = template.snapshot;
    final counts = <String>[
      if (snapshot.categories.isNotEmpty)
        '${snapshot.categories.length} categor${snapshot.categories.length == 1 ? 'y' : 'ies'}',
      if (snapshot.products.isNotEmpty)
        '${snapshot.products.length} product${snapshot.products.length == 1 ? '' : 's'}',
      if (snapshot.combos.isNotEmpty)
        '${snapshot.combos.length} combo${snapshot.combos.length == 1 ? '' : 's'}',
    ];
    return counts.isEmpty ? 'Empty catalog' : counts.join(' · ');
  }

  String get _savedAtLabel {
    final date = template.savedAt;
    return '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(context.tokens.radius.xs),
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              AgoraIcons.archive,
              color: colors.mutedForeground,
              size: 20,
            ),
          ),
          SizedBox(width: context.tokens.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleMd(template.name),
                SizedBox(height: context.tokens.spacing.xxs),
                AppText.bodySm(
                  'Saved $_savedAtLabel · $_itemCountLabel',
                  color: colors.mutedForeground,
                ),
              ],
            ),
          ),
          SizedBox(width: context.tokens.spacing.md),
          AppButton.outline(
            onPressed: onRestore,
            label: 'Restore',
            leadingIcon: const Icon(AgoraIcons.rotate_left, size: 18),
          ),
          SizedBox(width: context.tokens.spacing.xs),
          AppIconButton.ghost(
            onPressed: onDelete,
            icon: Icon(AgoraIcons.trash, color: colors.mutedForeground),
            tooltip: 'Delete template',
          ),
        ],
      ),
    );
  }
}
