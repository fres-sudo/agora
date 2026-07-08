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
import 'package:feature_products/domain/models/product.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';

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
  ActiveOrderBloc({
    required OrdersRepository ordersRepository,
    required SettingsCubit settingsCubit,
  }) : _ordersRepository = ordersRepository,
       _settingsCubit = settingsCubit,
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
  final SettingsCubit _settingsCubit;

  // Current order being built
  List<OrderLineItem> _items = [];
  Discount? _appliedDiscount;
  String _note = '';
  OrderType _orderType = OrderType.dineIn;

  // Monotonic cart-local id generator for OrderLineItem.id. Never reset (a
  // fresh cart starts after a submit/clear, so ids simply keep counting up),
  // which keeps every line item unique for the lifetime of the bloc.
  int _nextLineItemId = 1;

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
    // If an identical line (same product + same selected modifiers) is
    // already in the cart, merge into it instead of adding a duplicate row.
    final existingIndex = _items.indexWhere(
      (item) =>
          item.productId == event.product.id &&
          _sameModifiers(item.selectedModifiers, event.modifiers),
    );

    if (existingIndex != -1) {
      final existing = _items[existingIndex];
      final merged = existing.copyWith(
        quantity: existing.quantity + event.quantity,
      );
      _items = [
        ..._items.sublist(0, existingIndex),
        merged,
        ..._items.sublist(existingIndex + 1),
      ];
    } else {
      final lineItem = OrderLineItem(
        id: _nextLineItemId++,
        productId: event.product.id,
        productName: event.product.name,
        unitPriceCents: event.product.priceCents,
        quantity: event.quantity,
        selectedModifiers: event.modifiers,
      );
      _items = [..._items, lineItem];
    }

    // Optimistic update: cart reflects the change immediately.
    _emitBuilding(emit);

    // No async operation needed for local cart state
    // The actual order is created on submit
  }

  Future<void> _onItemRemoved(
    _ItemRemoved event,
    Emitter<ActiveOrderState> emit,
  ) async {
    // Optimistic update: remove immediately
    _items = _items.where((item) => item.id != event.lineItemId).toList();

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
    // Optimistic update: change quantity immediately. A non-positive
    // quantity is treated as a removal (defensive; the cart UI's quantity
    // stepper keeps a minimum of 1 and uses swipe-to-remove instead).
    if (event.quantity <= 0) {
      _items = _items.where((item) => item.id != event.lineItemId).toList();
    } else {
      _items = _items.map((item) {
        if (item.id == event.lineItemId) {
          return item.copyWith(quantity: event.quantity);
        }
        return item;
      }).toList();
    }

    if (_items.isEmpty) {
      emit(const ActiveOrderState.empty());
    } else {
      _emitBuilding(emit);
    }
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

  /// Compares two modifier selections order-independently, so "Large" then
  /// "Extra cheese" is considered the same line as "Extra cheese" then
  /// "Large".
  bool _sameModifiers(List<SelectedModifiers> a, List<SelectedModifiers> b) {
    if (a.length != b.length) return false;

    String key(SelectedModifiers m) =>
        '${m.groupName}::${m.optionName}::${m.priceChangeCents}';

    final sortedA = a.map(key).toList()..sort();
    final sortedB = b.map(key).toList()..sort();

    for (var i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

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

    // Calculate tax from the persisted tax-rate setting (percentage, e.g. 22.0 = 22%).
    final taxRatePct =
        _settingsCubit.getDouble(AppSettingsDao.keyTaxRate) ?? 0.0;
    final taxAmount = taxRatePct > 0
        ? ((subtotal - discountAmount) * taxRatePct / 100).round()
        : 0;

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
