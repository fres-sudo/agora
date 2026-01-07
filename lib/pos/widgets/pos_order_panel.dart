import 'package:agora/core/ui/theme.dart';
import 'package:agora/orders/models/order/order.dart';
import 'package:agora/pos/widgets/pos_action_buttons.dart';
import 'package:agora/pos/widgets/pos_empty_state.dart';
import 'package:agora/pos/widgets/pos_order_item.dart';
import 'package:agora/pos/widgets/pos_order_summary.dart';
import 'package:agora/pos/widgets/pos_order_type_selector.dart';
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

  /// Callback when an item is removed from order.
  final ValueChanged<int> onItemRemoved;

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: PosActionButtons(
              onCustomerTap: onCustomerTap,
              onTablesTap: onTablesTap,
              onDiscountTap: onDiscountTap,
              onSaveBillTap: onSaveBillTap,
            ),
          ),
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
              border: Border(
                top: BorderSide(color: AppColors.neutral200),
              ),
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
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _hasItems ? onProcessTransaction : null,
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
                    child: Text(
                      'Process Transaction',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
  final List<dynamic> items;
  final ValueChanged<int> onItemRemoved;
  final VoidCallback onClearAll;

  const _OrderItemsList({
    required this.items,
    required this.onItemRemoved,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                onRemove: () {
                  if (item.productId != null) {
                    onItemRemoved(item.productId!);
                  }
                },
              );
            },
          ),
        ),
        // Clear All Order button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onClearAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.neutral600,
                side: BorderSide(color: AppColors.neutral300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Clear All Order',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
