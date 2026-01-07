part of 'order_detail_cubit.dart';

@freezed
class OrderDetailState with _$OrderDetailState {
  const OrderDetailState._();

  /// Initial state.
  const factory OrderDetailState.initial() = _Initial;

  /// Loading the order.
  const factory OrderDetailState.loading() = _Loading;

  /// Loaded with order.
  const factory OrderDetailState.loaded({required Order order}) =
      OrderDetailLoaded;

  /// Completing the order.
  const factory OrderDetailState.completing({required Order order}) =
      _Completing;

  /// Voiding the order.
  const factory OrderDetailState.voiding({required Order order}) = _Voiding;

  /// Error state.
  const factory OrderDetailState.error({
    required String message,
    Order? order,
  }) = _Error;

  /// Returns true if the state has an order.
  bool get hasOrder => maybeMap(
        loaded: (_) => true,
        completing: (_) => true,
        voiding: (_) => true,
        error: (s) => s.order != null,
        orElse: () => false,
      );
}
