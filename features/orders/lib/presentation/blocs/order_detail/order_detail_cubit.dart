import 'dart:async';

import 'package:result/result.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:order_management/models/order.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';

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
  ///
  /// The completed/pending → voided transition happens first and is
  /// atomic + idempotent at the repository layer (a single conditional
  /// UPDATE guarded by "not already voided"). Inventory is only restored
  /// when *this* call is the one that performed the transition
  /// (`!wasAlreadyVoided`). That ordering — claim the transition, then act
  /// on it — is what makes retries safe: if a previous attempt already
  /// voided the order (even if its own inventory restore failed or never
  /// ran), a retry sees `wasAlreadyVoided: true` and skips the restore
  /// loop entirely instead of re-crediting stock that may already have
  /// been credited.
  Future<void> voidOrder() async {
    final currentOrder = state.maybeMap(
      loaded: (s) => s.order,
      orElse: () => null,
    );

    if (currentOrder == null) return;

    emit(OrderDetailState.voiding(order: currentOrder));

    final voidResult = await _ordersRepository.voidOrder(currentOrder.id ?? 0);

    final claimed = voidResult.fold(
      success: (value) => value,
      error: (error) {
        emit(
          OrderDetailState.error(
            message: 'Failed to void order: ${error.toString()}',
            order: currentOrder,
          ),
        );
        return null;
      },
    );

    if (claimed == null) return;

    // Already voided by a previous call (e.g. this is a retry) — nothing
    // left to do; any inventory restore either already ran or is not this
    // call's responsibility.
    if (claimed.wasAlreadyVoided) return;

    // A completed order already decremented stock at checkout, so voiding
    // must give it back. A pending order never touched inventory.
    if (currentOrder.status != OrderStatus.completed) return;

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
                'Order #${currentOrder.id ?? '-'} was voided, but restoring '
                'inventory failed for one or more items. Please reconcile '
                'stock manually.',
            order: currentOrder,
          ),
        );
        return;
      }
    }
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
