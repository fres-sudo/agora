import 'package:ui_kit/ui_kit.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

/// A single item row in the order list.
/// Displays product name, selected modifiers, quantity stepper, and totals.
class PosOrderItem extends StatelessWidget {
  /// The order line item to display.
  final OrderLineItem item;

  /// Callback when the row is swiped away to remove it entirely.
  final VoidCallback onRemove;

  /// Callback when the quantity stepper changes the quantity. The cart
  /// keeps a minimum of 1 here — full removal stays a deliberate
  /// swipe-to-delete gesture via [onRemove].
  final ValueChanged<int> onQuantityChanged;

  /// Currency symbol to display.
  final String currencySymbol;

  const PosOrderItem({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.currencySymbol,
  });

  String _formatCents(int cents) => formatCents(cents, symbol: currencySymbol);

  int get _itemTotal {
    int total = item.unitPriceCents * item.quantity;
    for (final mod in item.selectedModifiers) {
      total += mod.priceChangeCents * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: context.tokens.spaceMd),
        color: colors.destructive,
        child: Icon(AgoraIcons.trash, color: colors.destructiveForeground),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.tokens.spaceXs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info (left)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMd(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.selectedModifiers.isNotEmpty) ...[
                    SizedBox(height: context.tokens.spaceXxs),
                    AppText.bodySm(
                      item.selectedModifiers
                          .map((m) => m.optionName)
                          .join(', '),
                      color: colors.mutedForeground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: context.tokens.spaceXxs),
                  AppText.bodySm(
                    '${_formatCents(item.unitPriceCents)} each',
                    color: colors.mutedForeground,
                  ),
                ],
              ),
            ),
            SizedBox(width: context.tokens.spaceXs),
            // Quantity stepper + total (right)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.titleMd(_formatCents(_itemTotal)),
                SizedBox(height: context.tokens.spaceXxs),
                QuantityButton(
                  quantity: item.quantity,
                  min: 1,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
