part of 'inventory_bloc.dart';

@freezed
class InventoryState with _$InventoryState {
  const InventoryState._();

  /// Initial state.
  const factory InventoryState.initial() = _Initial;

  /// Loading inventory.
  const factory InventoryState.loading() = _Loading;

  /// Loaded with stocks.
  const factory InventoryState.loaded({
    required List<Stock> stocks,
    required int lowStockCount,
    required int threshold,
    @Default(false) bool showLowStockOnly,
  }) = InventoryLoaded;

  /// Error state.
  const factory InventoryState.error({
    required String message,
    InventoryLoaded? previousState,
  }) = _Error;

  /// Returns stocks if loaded.
  List<Stock> get stocks => maybeMap(
        loaded: (s) => s.stocks,
        error: (s) => s.previousState?.stocks ?? [],
        orElse: () => [],
      );

  /// Returns low stock count.
  int get lowStockCount => maybeMap(
        loaded: (s) => s.lowStockCount,
        error: (s) => s.previousState?.lowStockCount ?? 0,
        orElse: () => 0,
      );

  /// Returns true if there are low stock items.
  bool get hasLowStock => lowStockCount > 0;
}
