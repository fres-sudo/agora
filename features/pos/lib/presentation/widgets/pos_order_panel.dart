import 'package:bloc_exports/bloc_exports.dart';
import 'package:discounts/models/discount.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/models/order_type.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:database/database.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
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
        context.watch<SettingsCubit>().getString(SettingsKeys.currencySymbol) ??
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
            padding: EdgeInsets.symmetric(horizontal: context.tokens.spaceMd),
            child: PosOrderTypeSelector(
              selected: orderType,
              onChanged: onOrderTypeChanged,
            ),
          ),
          SizedBox(height: context.tokens.spaceXs),
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
                    icon: AgoraIcons.cart,
                    title: 'No Order',
                    description: 'Tap the product to add into order',
                    iconSize: 40,
                  ),
          ),
          // Order summary and process button
          Container(
            padding: EdgeInsets.all(context.tokens.spaceMd),
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
                  SizedBox(height: context.tokens.spaceXs),
                ],
                PosOrderSummary(
                  subtotalCents: currentOrder?.subtotalCents ?? 0,
                  taxCents: currentOrder?.taxCents ?? 0,
                  discountCents: currentOrder?.discountCents ?? 0,
                  grandTotalCents: currentOrder?.grandTotalCents ?? 0,
                  currencySymbol: currencySymbol,
                ),
                SizedBox(height: context.tokens.spaceMd),
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
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceSm,
        vertical: context.tokens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: context.tokens.borderRadiusLg,
      ),
      child: Row(
        children: [
          Icon(AgoraIcons.discount, size: 18, color: colors.primary),
          SizedBox(width: context.tokens.spaceXs),
          Expanded(
            child: AppText.titleMd(
              '${discount.name} ($valueLabel)',
              color: colors.primary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onRemoveDiscount,
            borderRadius: context.tokens.borderRadiusFull,
            child: Padding(
              padding: EdgeInsets.all(context.tokens.spaceXxs),
              child: Icon(
                AgoraIcons.x_mark,
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
            padding: EdgeInsets.symmetric(horizontal: context.tokens.spaceMd),
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
          padding: EdgeInsets.symmetric(
            horizontal: context.tokens.spaceMd,
            vertical: context.tokens.spaceXs,
          ),
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
