part of 'active_order_bloc.dart';

@freezed
class ActiveOrderState with _$ActiveOrderState {
  const ActiveOrderState._();

  /// Empty cart state.
  const factory ActiveOrderState.empty() = _Empty;

  /// Building an order (cart has items).
  const factory ActiveOrderState.building({
    required Order order,
    @Default(null) Discount? appliedDiscount,
  }) = ActiveOrderBuilding;

  /// Submitting the order.
  const factory ActiveOrderState.submitting({
    required Order order,
  }) = _Submitting;

  /// Order successfully submitted.
  const factory ActiveOrderState.submitted({
    required Order order,
  }) = OrderSubmitted;

  /// Error state with optional order for recovery.
  const factory ActiveOrderState.error({
    required String message,
    Order? order,
  }) = _Error;

  /// Returns true if cart has items.
  bool get hasItems => maybeMap(
        building: (s) => s.order.items.isNotEmpty,
        submitting: (s) => s.order.items.isNotEmpty,
        error: (s) => s.order?.items.isNotEmpty ?? false,
        orElse: () => false,
      );

  /// Returns the item count.
  int get itemCount => maybeMap(
        building: (s) => s.order.items.length,
        submitting: (s) => s.order.items.length,
        error: (s) => s.order?.items.length ?? 0,
        orElse: () => 0,
      );

  /// Returns the current order if available.
  Order? get currentOrder => maybeMap(
        building: (s) => s.order,
        submitting: (s) => s.order,
        submitted: (s) => s.order,
        error: (s) => s.order,
        orElse: () => null,
      );

  /// Returns the grand total in cents.
  int get grandTotalCents => currentOrder?.grandTotalCents ?? 0;
}
