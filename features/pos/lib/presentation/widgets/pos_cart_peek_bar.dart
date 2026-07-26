import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

/// The collapsed state of the phone POS cart sheet: how many items are in the
/// order, what they come to, and a way into checkout.
///
/// Deliberately thin — it is pinned over the product list for the whole
/// ordering session, so every extra pixel is one the operator can't tap.
class PosCartPeekBar extends StatelessWidget {
  const PosCartPeekBar({
    super.key,
    required this.itemCount,
    required this.totalCents,
    required this.currencySymbol,
    required this.onExpand,
  });

  final int itemCount;
  final int totalCents;
  final String currencySymbol;

  /// Raises the sheet to full height so the order can be reviewed and paid.
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = context.colors;

    return GestureDetector(
      onTap: onExpand,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.spacing.lg,
          0,
          tokens.spacing.md,
          tokens.spacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.caption(
                    itemCount == 1 ? '1 item' : '$itemCount items',
                    color: colors.mutedForeground,
                  ),
                  AppText.titleLg(
                    formatCents(totalCents, symbol: currencySymbol),
                  ),
                ],
              ),
            ),
            SizedBox(width: tokens.spacing.sm),
            AppButton.primary(
              onPressed: onExpand,
              label: 'Checkout',
              trailingIcon: const Icon(AgoraIcons.chevron_up, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
