import 'package:agora/core/ui/theme.dart';
import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:flutter/material.dart';

/// A single item row in the order list.
/// Displays product name, quantity, unit price, and total price.
class PosOrderItem extends StatelessWidget {
  /// The order line item to display.
  final OrderLineItem item;

  /// Callback when the remove button is tapped.
  final VoidCallback onRemove;

  /// Currency symbol to display. Defaults to '$'.
  final String currencySymbol;

  const PosOrderItem({
    super.key,
    required this.item,
    required this.onRemove,
    this.currencySymbol = '\$',
  });

  String _formatCents(int cents) {
    return '$currencySymbol ${(cents / 100).toStringAsFixed(2)}';
  }

  int get _itemTotal {
    int total = item.unitPriceCents * item.quantity;
    for (final mod in item.selectedModifiers) {
      total += mod.priceChangeCents * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error400,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info (left)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'X${item.quantity}   ${_formatCents(item.unitPriceCents)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            // Total price (right)
            Text(
              _formatCents(_itemTotal),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.neutral800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
