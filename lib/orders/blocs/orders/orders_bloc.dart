import 'dart:async';

import 'package:agora/core/misc/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/orders/models/order/order.dart';
import 'package:agora/orders/repositories/orders_repository.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

/// BLoC for managing the orders list with filtering and real-time updates.
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required OrdersRepository ordersRepository})
    : _ordersRepository = ordersRepository,
      super(const OrdersState.initial()) {
    on<_Started>(_onStarted);
    on<_FilterChanged>(_onFilterChanged);
    on<_Refresh>(_onRefresh);
    on<_Deleted>(_onDeleted);
  }

  final OrdersRepository _ordersRepository;
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
    _subscribeToOrders();
  }

  Future<void> _onFilterChanged(
    _FilterChanged event,
    Emitter<OrdersState> emit,
  ) async {
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
    final result = await _ordersRepository.deleteOrder(event.id);

    result.when(
      success: (_) {
        // Stream will automatically update the list
      },
      error: (error) {
        emit(
          OrdersState.error(
            message: 'Failed to delete order: ${error.toString()}',
            previousState: state is OrdersLoaded ? state as OrdersLoaded : null,
          ),
        );
      },
    );
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
      stream = _ordersRepository.watchOrdersByDateRange(
        startDate: _startDate,
        endDate: _endDate,
      );
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
              previousState: state is OrdersLoaded
                  ? state as OrdersLoaded
                  : null,
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
