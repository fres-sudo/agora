part of 'orders_bloc.dart';

@freezed
class OrdersState with _$OrdersState {
  const OrdersState._();

  /// Initial state.
  const factory OrdersState.initial() = _Initial;

  /// Loading orders.
  const factory OrdersState.loading() = _Loading;

  /// Loaded with orders and current filter.
  const factory OrdersState.loaded({
    required List<Order> orders,
    @Default(null) OrderStatus? statusFilter,
    @Default(null) DateTime? startDate,
    @Default(null) DateTime? endDate,
  }) = OrdersLoaded;

  /// Error state.
  const factory OrdersState.error({
    required String message,
    OrdersLoaded? previousState,
  }) = _Error;

  /// Returns the orders list if loaded.
  List<Order> get orders => maybeMap(
        loaded: (s) => s.orders,
        error: (s) => s.previousState?.orders ?? [],
        orElse: () => [],
      );

  /// Returns true if a filter is active.
  bool get hasFilter => maybeMap(
        loaded: (s) =>
            s.statusFilter != null || s.startDate != null || s.endDate != null,
        orElse: () => false,
      );
}
