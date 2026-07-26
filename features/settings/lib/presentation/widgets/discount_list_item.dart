import 'package:discounts/models/discount.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// A list item for displaying, toggling and editing a [Discount]
/// (Settings → Discount & Voucher, P6-3).
class DiscountListItem extends StatelessWidget {
  const DiscountListItem({
    super.key,
    required this.discount,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final Discount discount;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final valueLabel = discount.isPercentage
        ? '${discount.value}%'
        : context.formatCurrency(discount.value);

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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(context.tokens.radius.xs),
                border: Border.all(color: colors.border),
              ),
              child: Icon(AgoraIcons.discount, color: colors.primary, size: 20),
            ),
            SizedBox(width: context.tokens.spacing.sm),

            // Name + subtitle (code / expiry)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMd(discount.name),
                  SizedBox(height: context.tokens.spacing.xxs),
                  AppText.bodySm(_subtitle(), color: colors.mutedForeground),
                ],
              ),
            ),
            SizedBox(width: context.tokens.spacing.sm),

            // Value
            AppText.titleMd('-$valueLabel', color: colors.primary),
            SizedBox(width: context.tokens.spacing.xs),

            // Active toggle
            Switch(value: discount.isActive, onChanged: onToggle),

            // Delete
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: Icon(AgoraIcons.trash, color: colors.mutedForeground),
              tooltip: 'Delete discount',
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];
    if (discount.code != null && discount.code!.isNotEmpty) {
      parts.add('Code: ${discount.code}');
    }
    if (discount.validUntil != null) {
      final d = discount.validUntil!;
      parts.add(
        'Until ${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}',
      );
    }
    if (discount.usageLimit != null) {
      parts.add('Used ${discount.usageCount}/${discount.usageLimit}');
    }
    return parts.isEmpty ? 'No code · No expiry' : parts.join(' · ');
  }
}
