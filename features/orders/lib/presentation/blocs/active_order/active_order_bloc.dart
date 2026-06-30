import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:result/result.dart';
import 'package:feature_discounts/domain/models/discount.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/order_type.dart';
import 'package:feature_orders/domain/models/selected_modifiers.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:feature_products/domain/models/modifier_option.dart';
import 'package:feature_products/domain/models/product.dart';

part 'active_order_bloc.freezed.dart';
part 'active_order_event.dart';
part 'active_order_state.dart';

sealed class ActiveOrderEffect {
  const ActiveOrderEffect();
}

final class ActiveOrderSubmitted extends ActiveOrderEffect {
  const ActiveOrderSubmitted(this.order);
  final Order order;
}

final class ActiveOrderShowError extends ActiveOrderEffect {
  const ActiveOrderShowError(this.message);
  final String message;
}

/// BLoC for managing the current cart/order being built.
///
/// Uses optimistic updates for immediate UI feedback:
/// - Cart state updates immediately on item add/remove
/// - If the async operation fails, an effect is emitted for UI notification
/// - On success, orderSubmitted effect triggers navigation
class ActiveOrderBloc
    extends EffectBloc<ActiveOrderEvent, ActiveOrderState, ActiveOrderEffect> {
  ActiveOrderBloc({required OrdersRepository ordersRepository})
    : _ordersRepository = ordersRepository,
      super(const ActiveOrderState.empty()) {
    on<_Started>(_onStarted);
    on<_ItemAdded>(_onItemAdded);
    on<_ItemRemoved>(_onItemRemoved);
    on<_ItemQuantityChanged>(_onItemQuantityChanged);
    on<_OrderTypeChanged>(_onOrderTypeChanged);
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
  OrderType _orderType = OrderType.dineIn;

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
    _orderType = OrderType.dineIn;
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

  Future<void> _onOrderTypeChanged(
    _OrderTypeChanged event,
    Emitter<ActiveOrderState> emit,
  ) async {
    _orderType = event.orderType;
    // Reflect the change in the building state without forcing a non-empty cart.
    if (_items.isEmpty) {
      emit(const ActiveOrderState.empty());
    } else {
      _emitBuilding(emit);
    }
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
      emitEffect(const ActiveOrderShowError('Cannot submit an empty order'));
      return;
    }

    final currentOrder = _buildOrder();
    emit(ActiveOrderState.submitting(order: currentOrder));

    final result = await _ordersRepository.createOrder(currentOrder);

    result.when(
      success: (submittedOrder) {
        emitEffect(ActiveOrderSubmitted(submittedOrder));
        _items = [];
        _appliedDiscount = null;
        _note = '';
        emit(const ActiveOrderState.empty());
      },
      error: (error) {
        emitEffect(
          ActiveOrderShowError('Failed to submit order: ${error.toString()}'),
        );
        emit(
          ActiveOrderState.building(
            order: currentOrder,
            appliedDiscount: _appliedDiscount,
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
      orderType: _orderType,
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
