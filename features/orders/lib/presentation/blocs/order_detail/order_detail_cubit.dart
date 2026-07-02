import 'dart:async';

import 'package:result/result.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:feature_inventory/domain/repositories/inventory_repository.dart';

part 'order_detail_cubit.freezed.dart';
part 'order_detail_state.dart';

/// Cubit for managing a single order's detail view and operations.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({
    required OrdersRepository ordersRepository,
    required InventoryRepository inventoryRepository,
  }) : _ordersRepository = ordersRepository,
       _inventoryRepository = inventoryRepository,
       super(const OrderDetailState.initial());

  final OrdersRepository _ordersRepository;
  final InventoryRepository _inventoryRepository;
  StreamSubscription<Order?>? _subscription;

  // ============================================================
  // PUBLIC METHODS
  // ============================================================

  /// Load an order by ID.
  Future<void> load(int orderId) async {
    emit(const OrderDetailState.loading());

    await _subscription?.cancel();

    _subscription = _ordersRepository
        .watchOrderById(orderId)
        .listen(
          (order) {
            if (order != null) {
              if (!isClosed) {
                emit(OrderDetailState.loaded(order: order));
              }
            } else {
              if (!isClosed) {
                emit(const OrderDetailState.error(message: 'Order not found'));
              }
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(OrderDetailState.error(message: error.toString()));
            }
          },
        );
  }

  /// Complete the order.
  Future<void> complete() async {
    final currentOrder = state.maybeMap(
      loaded: (s) => s.order,
      orElse: () => null,
    );

    if (currentOrder == null) return;

    emit(OrderDetailState.completing(order: currentOrder));

    final result = await _ordersRepository.completeOrder(currentOrder.id ?? 0);

    result.when(
      success: (completedOrder) {
        // Stream will automatically update the state
      },
      error: (error) {
        emit(
          OrderDetailState.error(
            message: 'Failed to complete order: ${error.toString()}',
            order: currentOrder,
          ),
        );
      },
    );
  }

  /// Void the order.
  Future<void> voidOrder() async {
    final currentOrder = state.maybeMap(
      loaded: (s) => s.order,
      orElse: () => null,
    );

    if (currentOrder == null) return;

    emit(OrderDetailState.voiding(order: currentOrder));

    // Restore inventory before voiding — a completed order already decremented
    // stock at checkout, so voiding must give it back. (The repository's
    // voidOrder only flips status; it does not touch inventory.)
    if (currentOrder.status == OrderStatus.completed) {
      final restoredQuantities = <int, int>{};
      for (final item in currentOrder.items) {
        final productId = item.productId;
        if (productId == null) continue;
        restoredQuantities.update(
          productId,
          (value) => value + item.quantity,
          ifAbsent: () => item.quantity,
        );
      }

      for (final entry in restoredQuantities.entries) {
        final restoreResult = await _inventoryRepository.restoreForVoidedOrder(
          productId: entry.key,
          quantity: entry.value,
          orderId: currentOrder.id ?? 0,
        );
        if (restoreResult.isError) {
          emit(
            OrderDetailState.error(
              message:
                  'Failed to restore inventory for order #${currentOrder.id ?? '-'}',
              order: currentOrder,
            ),
          );
          return;
        }
      }
    }

    final result = await _ordersRepository.voidOrder(currentOrder.id ?? 0);

    result.when(
      success: (voidedOrder) {
        // Stream will automatically update the state
      },
      error: (error) {
        emit(
          OrderDetailState.error(
            message: 'Failed to void order: ${error.toString()}',
            order: currentOrder,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension OrderDetailCubitExtension on BuildContext {
  OrderDetailCubit get orderDetailCubit => read<OrderDetailCubit>();
  OrderDetailCubit get watchOrderDetailCubit => watch<OrderDetailCubit>();
}
