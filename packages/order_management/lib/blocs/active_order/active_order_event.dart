part of 'active_order_bloc.dart';

@freezed
sealed class ActiveOrderEvent with _$ActiveOrderEvent {
  /// Start with an empty cart.
  const factory ActiveOrderEvent.started() = _Started;

  /// Add a product to the cart.
  ///
  /// If a line with the same product and the same selected modifiers
  /// already exists, its quantity is incremented instead of creating a
  /// duplicate line.
  const factory ActiveOrderEvent.itemAdded({
    required Product product,
    @Default(1) int quantity,
    @Default([]) List<SelectedModifiers> modifiers,
  }) = _ItemAdded;

  /// Remove a specific line item from the cart, by its cart-local
  /// [OrderLineItem.id].
  const factory ActiveOrderEvent.itemRemoved(int lineItemId) = _ItemRemoved;

  /// Change the quantity of a specific line item, by its cart-local
  /// [OrderLineItem.id]. A [quantity] of 0 or less removes the line.
  const factory ActiveOrderEvent.itemQuantityChanged({
    required int lineItemId,
    required int quantity,
  }) = _ItemQuantityChanged;

  /// Change the order type (dine in / take away).
  const factory ActiveOrderEvent.orderTypeChanged(OrderType orderType) =
      _OrderTypeChanged;

  /// Apply a discount to the order.
  const factory ActiveOrderEvent.discountApplied(Discount discount) =
      _DiscountApplied;

  /// Remove the applied discount.
  const factory ActiveOrderEvent.discountRemoved() = _DiscountRemoved;

  /// Update the order note.
  const factory ActiveOrderEvent.noteUpdated(String note) = _NoteUpdated;

  /// Submit the order to the database.
  const factory ActiveOrderEvent.submitted() = _Submitted;

  /// Clear the cart.
  const factory ActiveOrderEvent.cleared() = _Cleared;
}
