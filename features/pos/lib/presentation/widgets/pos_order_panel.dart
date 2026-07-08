import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_discounts/domain/models/discount.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/order_type.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

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

  /// The discount currently applied to the cart, if any. Used to show the
  /// applied-discount row with a remove action.
  final Discount? appliedDiscount;

  /// Callback when the "Add Discount" action is tapped.
  final VoidCallback? onDiscountTap;

  /// Callback when the applied discount's remove (✕) action is tapped.
  final VoidCallback? onRemoveDiscount;

  const PosOrderPanel({
    super.key,
    this.currentOrder,
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.onClearOrder,
    required this.onProcessTransaction,
    required this.onItemRemoved,
    required this.onItemQuantityChanged,
    this.appliedDiscount,
    this.onDiscountTap,
    this.onRemoveDiscount,
  });

  bool get _hasItems => currentOrder?.items.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currencySymbol =
        context.watch<SettingsCubit>().getString(
          AppSettingsDao.keyCurrencySymbol,
        ) ??
        '€';

    return Container(
      color: colors.card,
      child: Column(
        children: [
          Divider(height: 1, color: colors.border),
          // Order Details header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppText.titleMd('Order Details'),
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
                    currencySymbol: currencySymbol,
                  )
                : PosEmptyState(
                    icon: AgoraIcons.bag,
                    title: 'No Order',
                    description: 'Tap the product to add into order',
                    iconSize: 40,
                  ),
          ),
          // Order summary and process button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Column(
              children: [
                // Discount entry / applied-discount row.
                if (_hasItems) ...[
                  _DiscountRow(
                    appliedDiscount: appliedDiscount,
                    onDiscountTap: onDiscountTap,
                    onRemoveDiscount: onRemoveDiscount,
                    currencySymbol: currencySymbol,
                  ),
                  const SizedBox(height: 8),
                ],
                PosOrderSummary(
                  subtotalCents: currentOrder?.subtotalCents ?? 0,
                  taxCents: currentOrder?.taxCents ?? 0,
                  discountCents: currentOrder?.discountCents ?? 0,
                  grandTotalCents: currentOrder?.grandTotalCents ?? 0,
                  currencySymbol: currencySymbol,
                ),
                const SizedBox(height: 16),
                AppButton.primary(
                  onPressed: _hasItems ? onProcessTransaction : null,
                  label: 'Process Transaction',
                  fullWidth: true,
                  size: AppButtonSize.lg,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows either an "Add Discount" action, or — when a discount is applied —
/// its name/value with a remove (✕) action (P6-1).
class _DiscountRow extends StatelessWidget {
  const _DiscountRow({
    required this.appliedDiscount,
    required this.onDiscountTap,
    required this.onRemoveDiscount,
    required this.currencySymbol,
  });

  final Discount? appliedDiscount;
  final VoidCallback? onDiscountTap;
  final VoidCallback? onRemoveDiscount;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final discount = appliedDiscount;

    if (discount == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: AppButton.ghost(
          onPressed: onDiscountTap,
          label: 'Add Discount',
          leadingIcon: const Icon(AgoraIcons.discount, size: 18),
        ),
      );
    }

    final valueLabel = discount.isPercentage
        ? '${discount.value}%'
        : formatCents(discount.value, symbol: currencySymbol);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(AgoraIcons.discount, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.titleMd(
              '${discount.name} ($valueLabel)',
              color: colors.primary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onRemoveDiscount,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                AgoraIcons.x,
                size: 18,
                color: colors.mutedForeground,
              ),
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
  final String currencySymbol;

  const _OrderItemsList({
    required this.items,
    required this.onItemRemoved,
    required this.onItemQuantityChanged,
    required this.onClearAll,
    required this.currencySymbol,
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
                currencySymbol: currencySymbol,
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
            ),
          ),
        ),
      ],
    );
  }
}
