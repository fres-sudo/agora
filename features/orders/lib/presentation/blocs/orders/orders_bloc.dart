import 'dart:async';

import 'package:result/result.dart';
import 'package:feature_inventory/domain/repositories/inventory_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

sealed class OrdersEffect {
  const OrdersEffect();
}

final class OrdersShowError extends OrdersEffect {
  const OrdersShowError(this.message);
  final String message;
}

/// BLoC for managing the orders list with filtering and real-time updates.
class OrdersBloc extends EffectBloc<OrdersEvent, OrdersState, OrdersEffect> {
  OrdersBloc({
    required OrdersRepository ordersRepository,
    required InventoryRepository inventoryRepository,
  }) : _ordersRepository = ordersRepository,
       _inventoryRepository = inventoryRepository,
       super(const OrdersState.initial()) {
    on<_Started>(_onStarted);
    on<_FilterChanged>(_onFilterChanged);
    on<_Refresh>(_onRefresh);
    on<_Deleted>(_onDeleted);
  }

  final OrdersRepository _ordersRepository;
  final InventoryRepository _inventoryRepository;
  StreamSubscription<List<Order>>? _subscription;

  // Current filter state
  OrderStatus? _statusFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<OrdersState> emit) async {
    emit(const OrdersState.loading());
    await _subscription?.cancel();
    _subscribeToOrders();
  }

  Future<void> _onFilterChanged(_FilterChanged event, Emitter<OrdersState> emit) async {
    _statusFilter = event.status;
    _startDate = event.startDate;
    _endDate = event.endDate;

    emit(const OrdersState.loading());
    await _subscription?.cancel();
    _subscribeToOrders();
  }

  Future<void> _onRefresh(_Refresh event, Emitter<OrdersState> emit) async {
    await _subscription?.cancel();
    _subscribeToOrders();
  }

  Future<void> _onDeleted(_Deleted event, Emitter<OrdersState> emit) async {
    final orderResult = await _ordersRepository.getOrderById(event.id);

    switch (orderResult) {
      case Ok<Order?>(:final value):
        final order = value;
        if (order == null) {
          emitEffect(const OrdersShowError('Order not found'));
          return;
        }

        if (order.status == OrderStatus.completed) {
          final restoredQuantities = <int, int>{};
          for (final item in order.items) {
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
              orderId: order.id ?? event.id,
            );

            if (restoreResult.isError) {
              emitEffect(OrdersShowError('Failed to restore inventory for order #${order.id ?? event.id}'));
              return;
            }
          }
        }

        final deleteResult = await _ordersRepository.deleteOrder(event.id);

        deleteResult.when(
          success: (_) {
            // Stream will automatically update the list.
          },
          error: (error) {
            emitEffect(OrdersShowError('Failed to delete order: ${error.toString()}'));
          },
        );
      case Error<Order?>(:final error):
        emitEffect(OrdersShowError('Failed to load order: ${error.toString()}'));
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _subscribeToOrders() {
    // Select appropriate stream based on filter
    Stream<List<Order>> stream;

    if (_statusFilter != null) {
      stream = _ordersRepository.watchOrdersByStatus(_statusFilter!);
    } else if (_startDate != null || _endDate != null) {
      stream = _ordersRepository.watchOrdersByDateRange(startDate: _startDate, endDate: _endDate);
    } else {
      stream = _ordersRepository.watchAllOrders();
    }

    _subscription = stream.listen(
      (orders) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(
            OrdersState.loaded(
              orders: orders,
              statusFilter: _statusFilter,
              startDate: _startDate,
              endDate: _endDate,
            ),
          );
        }
      },
      onError: (error) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(
            OrdersState.error(
              message: error.toString(),
              previousState: state is OrdersLoaded ? state as OrdersLoaded : null,
            ),
          );
        }
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

extension OrdersBlocExtension on BuildContext {
  OrdersBloc get ordersBloc => read<OrdersBloc>();
  OrdersBloc get watchOrdersBloc => watch<OrdersBloc>();
}
