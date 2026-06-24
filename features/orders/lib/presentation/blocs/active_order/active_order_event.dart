part of 'active_order_bloc.dart';

@freezed
sealed class ActiveOrderEvent with _$ActiveOrderEvent {
  /// Start with an empty cart.
  const factory ActiveOrderEvent.started() = _Started;

  /// Add a product to the cart.
  const factory ActiveOrderEvent.itemAdded({
    required Product product,
    @Default(1) int quantity,
    @Default([]) List<ModifierOption> modifiers,
  }) = _ItemAdded;

  /// Remove an item from the cart.
  const factory ActiveOrderEvent.itemRemoved(int productId) = _ItemRemoved;

  /// Change quantity of an item.
  const factory ActiveOrderEvent.itemQuantityChanged({
    required int productId,
    required int quantity,
  }) = _ItemQuantityChanged;

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
