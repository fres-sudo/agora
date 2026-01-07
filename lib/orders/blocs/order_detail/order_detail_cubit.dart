import 'dart:async';

import 'package:agora/core/misc/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/orders/models/order/order.dart';
import 'package:agora/orders/repositories/orders_repository.dart';

part 'order_detail_cubit.freezed.dart';
part 'order_detail_state.dart';

/// Cubit for managing a single order's detail view and operations.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({required OrdersRepository ordersRepository})
    : _ordersRepository = ordersRepository,
      super(const OrderDetailState.initial());

  final OrdersRepository _ordersRepository;
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
