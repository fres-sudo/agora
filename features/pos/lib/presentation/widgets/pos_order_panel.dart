import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/order_type.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:flutter/material.dart';

/// The right panel of the POS view displaying order details.
/// Contains action buttons, order type selector, order items, and summary.
class PosOrderPanel extends StatelessWidget {
  /// The current order being built. Null if cart is empty.
  final Order? currentOrder;

  /// Current order type (Dine In / Take Away).
  final OrderType orderType;

  /// Callback when order type changes.
  final ValueChanged<OrderType> onOrderTypeChanged;

  /// Callback when clear order is tapped.
  final VoidCallback onClearOrder;

  /// Callback when process transaction is tapped.
  final VoidCallback onProcessTransaction;

  /// Callback when an item is removed from order. Called with the line
  /// item's cart-local id ([OrderLineItem.id]).
  final ValueChanged<int> onItemRemoved;

  /// Callback when a line item's quantity is changed via the quantity
  /// stepper. Called with the line item's cart-local id and the new
  /// quantity.
  final void Function(int lineItemId, int quantity) onItemQuantityChanged;

  /// Callback when Customer button is tapped.
  final VoidCallback? onCustomerTap;

  /// Callback when Tables button is tapped.
  final VoidCallback? onTablesTap;

  /// Callback when Discount button is tapped.
  final VoidCallback? onDiscountTap;

  /// Callback when Save Bill button is tapped.
  final VoidCallback? onSaveBillTap;

  const PosOrderPanel({
    super.key,
    this.currentOrder,
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.onClearOrder,
    required this.onProcessTransaction,
    required this.onItemRemoved,
    required this.onItemQuantityChanged,
    this.onCustomerTap,
    this.onTablesTap,
    this.onDiscountTap,
    this.onSaveBillTap,
  });

  bool get _hasItems => currentOrder?.items.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Action buttons section
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: PosActionButtons(
          //     onCustomerTap: onCustomerTap,
          //     onTablesTap: onTablesTap,
          //     onDiscountTap: onDiscountTap,
          //     onSaveBillTap: onSaveBillTap,
          //   ),
          // ),
          const Divider(height: 1, color: AppColors.neutral200),
          // Order Details header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral800,
                ),
              ),
            ),
          ),
          // Order type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PosOrderTypeSelector(
              selected: orderType,
              onChanged: onOrderTypeChanged,
            ),
          ),
          const SizedBox(height: 8),
          // Order items list or empty state
          Expanded(
            child: _hasItems
                ? _OrderItemsList(
                    items: currentOrder!.items,
                    onItemRemoved: onItemRemoved,
                    onItemQuantityChanged: onItemQuantityChanged,
                    onClearAll: onClearOrder,
                  )
                : PosEmptyState(
                    icon: Icons.shopping_bag_outlined,
                    title: 'No Order',
                    description: 'Tap the product to add into order',
                    iconSize: 40,
                  ),
          ),
          // Order summary and process button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.neutral200)),
            ),
            child: Column(
              children: [
                PosOrderSummary(
                  subtotalCents: currentOrder?.subtotalCents ?? 0,
                  taxCents: currentOrder?.taxCents ?? 0,
                  discountCents: currentOrder?.discountCents ?? 0,
                  grandTotalCents: currentOrder?.grandTotalCents ?? 0,
                ),
                const SizedBox(height: 16),
                AppButton.primary(
                  onPressed: _hasItems ? onProcessTransaction : null,
                  label: 'Process Transaction',
                  fullWidth: true,
                  style: FilledButton.styleFrom(
                    backgroundColor: _hasItems
                        ? AppColors.primary500
                        : AppColors.neutral300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  final List<OrderLineItem> items;
  final ValueChanged<int> onItemRemoved;
  final void Function(int lineItemId, int quantity) onItemQuantityChanged;
  final VoidCallback onClearAll;

  const _OrderItemsList({
    required this.items,
    required this.onItemRemoved,
    required this.onItemQuantityChanged,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return PosOrderItem(
                item: item,
                onRemove: () => onItemRemoved(item.id),
                onQuantityChanged: (quantity) =>
                    onItemQuantityChanged(item.id, quantity),
              );
            },
          ),
        ),
        // Clear All Order button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            child: AppButton.outline(
              onPressed: onClearAll,
              label: 'Clear All Order',
              fullWidth: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.neutral600,
                side: const BorderSide(color: AppColors.neutral300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
