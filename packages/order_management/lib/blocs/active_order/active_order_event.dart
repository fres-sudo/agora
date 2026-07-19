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

  /// Add a combo to the cart as one line (fixed contents, no modifier
  /// picker — v1 combos don't support modifiers on top).
  ///
  /// [components] must already be resolved by the caller (POS UI) against
  /// the live product catalog, mirroring how [itemAdded] snapshots a live
  /// [Product]'s price/prepStation rather than storing them on the combo
  /// definition. If a combo with the same [combo] id is already in the
  /// cart, its quantity is incremented instead of creating a duplicate line.
  const factory ActiveOrderEvent.comboAdded({
    required Combo combo,
    required List<ComboLineComponent> components,
    @Default(1) int quantity,
  }) = _ComboAdded;

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
