part of 'stock_adjustment_cubit.dart';

@freezed
class StockAdjustmentState with _$StockAdjustmentState {
  const StockAdjustmentState._();

  /// Initial/idle state.
  const factory StockAdjustmentState.initial() = _Initial;

  /// Adjusting stock (optimistic state).
  const factory StockAdjustmentState.adjusting({
    required int productId,
    required int previousQuantity,
    required int newQuantity,
  }) = _Adjusting;

  /// Successfully adjusted.
  const factory StockAdjustmentState.adjusted({
    required int productId,
    required int quantity,
  }) = _Adjusted;

  /// Error with rollback information.
  const factory StockAdjustmentState.error({
    required String message,
    required int productId,
    required int previousQuantity,
  }) = _Error;

  /// Returns true if an operation is in progress.
  bool get isLoading => this is _Adjusting;
}
