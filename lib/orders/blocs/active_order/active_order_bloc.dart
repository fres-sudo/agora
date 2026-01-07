import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/core/misc/result.dart';
import 'package:agora/discounts/models/discount/discount.dart';
import 'package:agora/orders/models/order/order.dart';
import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:agora/orders/models/selected_modifiers/selected_modifiers.dart';
import 'package:agora/orders/repositories/orders_repository.dart';
import 'package:agora/products/models/modifier_option/modifier_option.dart';
import 'package:agora/products/models/product/product.dart';

part 'active_order_bloc.freezed.dart';
part 'active_order_event.dart';
part 'active_order_state.dart';

/// BLoC for managing the current cart/order being built.
///
/// Uses optimistic updates for immediate UI feedback:
/// - Cart state updates immediately on item add/remove
/// - If the async DB operation fails, error state includes the previous cart
/// - On success, the UI is already in the correct state
class ActiveOrderBloc extends Bloc<ActiveOrderEvent, ActiveOrderState> {
  ActiveOrderBloc({required OrdersRepository ordersRepository})
    : _ordersRepository = ordersRepository,
      super(const ActiveOrderState.empty()) {
    on<_Started>(_onStarted);
    on<_ItemAdded>(_onItemAdded);
    on<_ItemRemoved>(_onItemRemoved);
    on<_ItemQuantityChanged>(_onItemQuantityChanged);
    on<_DiscountApplied>(_onDiscountApplied);
    on<_DiscountRemoved>(_onDiscountRemoved);
    on<_NoteUpdated>(_onNoteUpdated);
    on<_Submitted>(_onSubmitted);
    on<_Cleared>(_onCleared);
  }

  final OrdersRepository _ordersRepository;

  // Current order being built
  List<OrderLineItem> _items = [];
  Discount? _appliedDiscount;
  String _note = '';

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(
    _Started event,
    Emitter<ActiveOrderState> emit,
  ) async {
    _items = [];
    _appliedDiscount = null;
    _note = '';
    emit(const ActiveOrderState.empty());
  }

  Future<void> _onItemAdded(
    _ItemAdded event,
    Emitter<ActiveOrderState> emit,
  ) async {
    // Convert product and modifiers to OrderLineItem
    final selectedModifiers = event.modifiers
        .map(
          (m) => SelectedModifiers(
            groupName: '', // Would need modifier group name from context
            optionName: m.name,
            priceChangeCents: m.priceChangeCents,
          ),
        )
        .toList();

    final lineItem = OrderLineItem(
      productId: event.product.id,
      productName: event.product.name,
      unitPriceCents: event.product.priceCents,
      quantity: event.quantity,
      selectedModifiers: selectedModifiers,
    );

    // Optimistic update: add item immediately
    _items = [..._items, lineItem];
    _emitBuilding(emit);

    // No async operation needed for local cart state
    // The actual order is created on submit
  }

  Future<void> _onItemRemoved(
    _ItemRemoved event,
    Emitter<ActiveOrderState> emit,
  ) async {
    // Optimistic update: remove immediately
    _items = _items.where((item) => item.productId != event.productId).toList();

    if (_items.isEmpty) {
      emit(const ActiveOrderState.empty());
    } else {
      _emitBuilding(emit);
    }
  }

  Future<void> _onItemQuantityChanged(
    _ItemQuantityChanged event,
    Emitter<ActiveOrderState> emit,
  ) async {
    // Optimistic update: change quantity immediately
    _items = _items.map((item) {
      if (item.productId != null && item.productId == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    _emitBuilding(emit);
  }

  Future<void> _onDiscountApplied(
    _DiscountApplied event,
    Emitter<ActiveOrderState> emit,
  ) async {
    _appliedDiscount = event.discount;
    _emitBuilding(emit);
  }

  Future<void> _onDiscountRemoved(
    _DiscountRemoved event,
    Emitter<ActiveOrderState> emit,
  ) async {
    _appliedDiscount = null;
    _emitBuilding(emit);
  }

  Future<void> _onNoteUpdated(
    _NoteUpdated event,
    Emitter<ActiveOrderState> emit,
  ) async {
    _note = event.note;
    _emitBuilding(emit);
  }

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<ActiveOrderState> emit,
  ) async {
    if (_items.isEmpty) {
      emit(
        const ActiveOrderState.error(message: 'Cannot submit an empty order'),
      );
      return;
    }

    final currentOrder = _buildOrder();
    emit(ActiveOrderState.submitting(order: currentOrder));

    final result = await _ordersRepository.createOrder(currentOrder);

    result.when(
      success: (submittedOrder) {
        emit(ActiveOrderState.submitted(order: submittedOrder));
        // Clear the cart
        _items = [];
        _appliedDiscount = null;
        _note = '';
      },
      error: (error) {
        emit(
          ActiveOrderState.error(
            message: 'Failed to submit order: ${error.toString()}',
            order: currentOrder,
          ),
        );
      },
    );
  }

  Future<void> _onCleared(
    _Cleared event,
    Emitter<ActiveOrderState> emit,
  ) async {
    _items = [];
    _appliedDiscount = null;
    _note = '';
    emit(const ActiveOrderState.empty());
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _emitBuilding(Emitter<ActiveOrderState> emit) {
    emit(
      ActiveOrderState.building(
        order: _buildOrder(),
        appliedDiscount: _appliedDiscount,
      ),
    );
  }

  Order _buildOrder() {
    // Calculate totals
    int subtotal = 0;
    for (final item in _items) {
      int itemTotal = item.unitPriceCents * item.quantity;
      for (final mod in item.selectedModifiers) {
        itemTotal += mod.priceChangeCents * item.quantity;
      }
      subtotal += itemTotal;
    }

    // Calculate discount
    int discountAmount = 0;
    if (_appliedDiscount != null) {
      if (_appliedDiscount!.isPercentage) {
        discountAmount = (subtotal * _appliedDiscount!.value ~/ 100);
      } else {
        discountAmount = _appliedDiscount!.value;
      }
    }

    // Calculate tax (assuming 0 for now - would come from settings)
    const taxAmount = 0;

    final grandTotal = subtotal - discountAmount + taxAmount;

    return Order(
      id: 0, // Will be assigned by DB
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      items: _items,
      note: _note.isEmpty ? null : _note,
      subtotalCents: subtotal,
      taxCents: taxAmount,
      discountCents: discountAmount,
      grandTotalCents: grandTotal,
    );
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension ActiveOrderBlocExtension on BuildContext {
  ActiveOrderBloc get activeOrderBloc => read<ActiveOrderBloc>();
  ActiveOrderBloc get watchActiveOrderBloc => watch<ActiveOrderBloc>();
}
