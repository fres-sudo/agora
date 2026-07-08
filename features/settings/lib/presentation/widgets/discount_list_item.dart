import 'package:feature_discounts/domain/models/discount.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

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
        : formatCents(discount.value);

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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(Sizes.xs),
                border: Border.all(color: colors.border),
              ),
              child: Icon(AgoraIcons.discount, color: colors.primary, size: 20),
            ),
            const SizedBox(width: Sizes.md),

            // Name + subtitle (code / expiry)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMd(discount.name),
                  const SizedBox(height: 2),
                  AppText.bodySm(_subtitle(), color: colors.mutedForeground),
                ],
              ),
            ),
            const SizedBox(width: Sizes.md),

            // Value
            AppText.titleMd('-$valueLabel', color: colors.primary),
            const SizedBox(width: Sizes.sm),

            // Active toggle
            Switch(value: discount.isActive, onChanged: onToggle),

            // Delete
            AppIconButton.ghost(
              onPressed: onDelete,
              icon: const Icon(AgoraIcons.trash, color: AppPalette.neutral500),
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
