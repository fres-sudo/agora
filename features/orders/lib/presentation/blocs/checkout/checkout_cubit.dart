import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';

import 'package:feature_inventory/domain/repositories/inventory_repository.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/payment_method.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:feature_products/domain/repositories/products_repository.dart';
import 'package:logger/logger.dart';
import 'package:result/result.dart';

part 'checkout_cubit.freezed.dart';
part 'checkout_state.dart';

/// Orchestrates the checkout / payment finalisation of a built cart.
///
/// Responsibilities (the Phase 1 critical path):
/// 1. Capture the payment method and (for cash) the tendered amount.
/// 2. Persist the order as **completed** with its payment method
///    (complete-on-payment model — see P1-2/P1-3).
/// 3. Decrement stock for tracked products and record stock movements (P1-4).
///
/// The cart itself is owned by `ActiveOrderBloc`; this cubit receives the
/// already-built [Order] via [start] and drives it to a finished sale. On
/// success the caller (the checkout sheet) is responsible for clearing the cart.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required OrdersRepository ordersRepository,
    required InventoryRepository inventoryRepository,
    required ProductsRepository productsRepository,
    Talker? logger,
  }) : _ordersRepository = ordersRepository,
       _inventoryRepository = inventoryRepository,
       _productsRepository = productsRepository,
       _logger = logger,
       super(const CheckoutState.initial());

  final OrdersRepository _ordersRepository;
  final InventoryRepository _inventoryRepository;
  final ProductsRepository _productsRepository;
  final Talker? _logger;

  /// Begin checkout for [order]. Defaults to cash with no tender entered.
  void start(Order order, {PaymentMethod method = PaymentMethod.cash}) {
    emit(CheckoutState.selecting(order: order, method: method));
  }

  /// Switch the selected payment method, resetting any tendered amount.
  void selectMethod(PaymentMethod method) {
    final order = state.maybeMap(
      selecting: (s) => s.order,
      failure: (s) => s.order,
      orElse: () => null,
    );
    if (order == null) return;
    emit(CheckoutState.selecting(order: order, method: method));
  }

  /// Set the cash amount tendered by the customer, in cents.
  void setTendered(int tenderedCents) {
    state.mapOrNull(
      selecting: (s) => emit(s.copyWith(tenderedCents: tenderedCents)),
    );
  }

  /// Reset the cubit, abandoning any in-progress checkout.
  void cancel() => emit(const CheckoutState.initial());

  /// Finalise the sale: persist as completed, then decrement stock.
  Future<void> confirm() async {
    final current = state;
    if (current is! CheckoutSelecting) return;
    if (!current.canConfirm) return;

    final method = current.method;
    final tenderedCents = current.tenderedCents;

    // Build the finished order: completed, with payment method captured.
    final finalOrder = current.order.copyWith(
      status: OrderStatus.completed,
      paymentMethod: method.label,
    );

    emit(
      CheckoutState.processing(
        order: finalOrder,
        method: method,
        tenderedCents: tenderedCents,
      ),
    );

    // 1. Persist the order (already completed — complete-on-payment).
    final createResult = await _ordersRepository.createOrder(finalOrder);

    switch (createResult) {
      case Ok<Order>(:final value):
        // 2. Decrement stock for tracked products (best-effort; a stock
        //    failure must not lose the recorded sale).
        await _decrementStock(value);
        emit(
          CheckoutState.success(
            order: value,
            method: method,
            tenderedCents: tenderedCents,
          ),
        );
      case Error<Order>(:final error):
        _logger?.error('Checkout failed to persist order', error);
        emit(
          CheckoutState.failure(
            message: 'Failed to complete the sale. Please try again.',
            order: current.order,
            method: method,
            tenderedCents: tenderedCents,
          ),
        );
    }
  }

  /// Decrements stock for each tracked line item in [order] and records a
  /// `Sale #<id>` movement. Untracked products are skipped (P1-4).
  Future<void> _decrementStock(Order order) async {
    final orderId = order.id;
    if (orderId == null) return;

    // Aggregate quantities per product so a product appearing on multiple
    // lines is decremented once.
    final quantities = <int, int>{};
    for (final item in order.items) {
      final productId = item.productId;
      if (productId == null) continue;
      quantities.update(
        productId,
        (value) => value + item.quantity,
        ifAbsent: () => item.quantity,
      );
    }

    for (final entry in quantities.entries) {
      final productId = entry.key;

      // Respect Product.trackStock — never decrement untracked items.
      final productResult = await _productsRepository.getProductById(productId);
      final tracks = switch (productResult) {
        Ok(:final value) => value?.trackStock ?? false,
        Error() => false,
      };
      if (!tracks) continue;

      final result = await _inventoryRepository.decrementForOrder(
        productId: productId,
        quantity: entry.value,
        orderId: orderId,
      );

      if (result.isError) {
        // Log but do not fail the sale — the money has been taken and the
        // order is recorded. Stock can be reconciled in inventory.
        _logger?.error(
          'Failed to decrement stock for product $productId on order #$orderId',
        );
      }
    }
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension CheckoutCubitExtension on BuildContext {
  CheckoutCubit get checkoutCubit => read<CheckoutCubit>();
  CheckoutCubit get watchCheckoutCubit => watch<CheckoutCubit>();
}
