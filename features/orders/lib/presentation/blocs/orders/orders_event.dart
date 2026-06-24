part of 'orders_bloc.dart';

@freezed
sealed class OrdersEvent with _$OrdersEvent {
  /// Start watching orders.
  const factory OrdersEvent.started() = _Started;

  /// Change the filter criteria.
  const factory OrdersEvent.filterChanged({
    OrderStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) = _FilterChanged;

  /// Refresh the orders list.
  const factory OrdersEvent.refresh() = _Refresh;

  /// Delete an order by ID.
  const factory OrdersEvent.deleted(int id) = _Deleted;
}
