import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/inventory/repositories/inventory_repository.dart';
import 'package:agora/core/misc/result.dart';

part 'stock_adjustment_cubit.freezed.dart';
part 'stock_adjustment_state.dart';

/// Cubit for quick stock adjustments with optimistic updates.
///
/// Uses optimistic updates for immediate UI feedback:
/// - Stock quantity updates immediately on adjust/set
/// - If the async DB operation fails, error state includes the previous quantity
/// - On success, the UI is already in the correct state
class StockAdjustmentCubit extends Cubit<StockAdjustmentState> {
  StockAdjustmentCubit({
    required InventoryRepository inventoryRepository,
  })  : _inventoryRepository = inventoryRepository,
        super(const StockAdjustmentState.initial());

  final InventoryRepository _inventoryRepository;

  // ============================================================
  // PUBLIC METHODS
  // ============================================================

  /// Adjust stock by a delta (can be positive or negative).
  Future<void> adjust({
    required int productId,
    required int delta,
    String? reason,
  }) async {
    // Get current stock for optimistic update
    final currentResult = await _inventoryRepository.getStockByProductId(productId);
    final currentQty = currentResult.fold(
      success: (stock) => stock?.quantity ?? 0,
      error: (_) => 0,
    );

    final newQty = currentQty + delta;

    // Optimistic update
    emit(StockAdjustmentState.adjusting(
      productId: productId,
      previousQuantity: currentQty,
      newQuantity: newQty,
    ));

    final result = await _inventoryRepository.adjustStock(
      productId: productId,
      delta: delta,
      reason: reason ?? 'Manual Adjustment',
    );

    result.when(
      success: (stock) {
        emit(StockAdjustmentState.adjusted(
          productId: productId,
          quantity: stock.quantity,
        ));
      },
      error: (error) {
        emit(StockAdjustmentState.error(
          message: 'Failed to adjust stock: ${error.toString()}',
          productId: productId,
          previousQuantity: currentQty,
        ));
      },
    );
  }

  /// Set stock to an absolute quantity.
  Future<void> setQuantity({
    required int productId,
    required int quantity,
    String? reason,
  }) async {
    // Get current stock for rollback on failure
    final currentResult = await _inventoryRepository.getStockByProductId(productId);
    final currentQty = currentResult.fold(
      success: (stock) => stock?.quantity ?? 0,
      error: (_) => 0,
    );

    // Optimistic update
    emit(StockAdjustmentState.adjusting(
      productId: productId,
      previousQuantity: currentQty,
      newQuantity: quantity,
    ));

    final result = await _inventoryRepository.setStock(
      productId: productId,
      quantity: quantity,
      reason: reason ?? 'Manual Set',
    );

    result.when(
      success: (stock) {
        emit(StockAdjustmentState.adjusted(
          productId: productId,
          quantity: stock.quantity,
        ));
      },
      error: (error) {
        emit(StockAdjustmentState.error(
          message: 'Failed to set stock: ${error.toString()}',
          productId: productId,
          previousQuantity: currentQty,
        ));
      },
    );
  }

  /// Reset the cubit to initial state.
  void reset() {
    emit(const StockAdjustmentState.initial());
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension StockAdjustmentCubitExtension on BuildContext {
  StockAdjustmentCubit get stockAdjustmentCubit => read<StockAdjustmentCubit>();
  StockAdjustmentCubit get watchStockAdjustmentCubit =>
      watch<StockAdjustmentCubit>();
}
