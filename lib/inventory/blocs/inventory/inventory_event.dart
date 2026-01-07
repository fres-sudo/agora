part of 'inventory_bloc.dart';

@freezed
sealed class InventoryEvent with _$InventoryEvent {
  /// Start watching inventory.
  const factory InventoryEvent.started() = _Started;

  /// Change the low stock threshold.
  const factory InventoryEvent.thresholdChanged(int threshold) =
      _ThresholdChanged;

  /// Toggle low stock filter.
  const factory InventoryEvent.filterChanged({
    required bool lowStockOnly,
  }) = _FilterChanged;

  /// Refresh inventory data.
  const factory InventoryEvent.refresh() = _Refresh;
}
