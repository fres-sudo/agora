/// Whether an order is consumed on-site or taken away.
///
/// Lives in the `orders` domain so both the POS and order features can share it
/// without a cross-feature dependency (`pos` already depends on `orders`).
/// The [value] is the integer persisted in `OrdersTable.orderType`.
enum OrderType {
  dineIn(0),
  takeAway(1);

  final int value;

  const OrderType(this.value);

  /// Maps a persisted integer back to an [OrderType], defaulting to [dineIn].
  static OrderType fromValue(int value) => OrderType.values.firstWhere(
    (t) => t.value == value,
    orElse: () => dineIn,
  );
}
