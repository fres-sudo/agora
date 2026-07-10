import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';

import 'package:discounts/models/discount.dart';
import 'package:discounts/repositories/discounts_repository.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';
import 'package:order_management/mappers/order_receipt_mapper.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/payment_method.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:logger/logger.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';

part 'checkout_cubit.freezed.dart';
part 'checkout_state.dart';

/// Orchestrates the checkout / payment finalisation of a built cart.
///
/// Responsibilities:
/// 1. Capture the payment method and (for cash) the tendered amount.
/// 2. Persist the order as **completed** with its payment method
///    (complete-on-payment model — see P1-2/P1-3).
/// 3. Decrement stock for tracked products and record stock movements (P1-4).
/// 4. Build the receipt and print it on demand (P2-3).
///
/// The cart itself is owned by `ActiveOrderBloc`; this cubit receives the
/// already-built [Order] via [start] and drives it to a finished sale. On
/// success the caller (the checkout sheet) is responsible for clearing the cart.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required OrdersRepository ordersRepository,
    required InventoryRepository inventoryRepository,
    required ProductsRepository productsRepository,
    required DiscountsRepository discountsRepository,
    required PrinterService printerService,
    Talker? logger,
  }) : _ordersRepository = ordersRepository,
       _inventoryRepository = inventoryRepository,
       _productsRepository = productsRepository,
       _discountsRepository = discountsRepository,
       _printerService = printerService,
       _logger = logger,
       super(const CheckoutState.initial());

  final OrdersRepository _ordersRepository;
  final InventoryRepository _inventoryRepository;
  final ProductsRepository _productsRepository;
  final DiscountsRepository _discountsRepository;
  final PrinterService _printerService;
  final Talker? _logger;

  static const ReceiptRenderer _renderer = ReceiptRenderer();

  ReceiptConfig _receiptConfig = const ReceiptConfig();

  /// The discount applied to the cart being checked out, if any. Used to bump
  /// its usage count once the sale completes.
  Discount? _appliedDiscount;

  /// Begin checkout for [order]. Defaults to cash with no tender entered.
  /// [receiptConfig] (store/receipt settings) is used to build the receipt once
  /// the sale completes. [appliedDiscount] is the cart's active discount, if any.
  void start(
    Order order, {
    PaymentMethod method = PaymentMethod.cash,
    ReceiptConfig receiptConfig = const ReceiptConfig(),
    Discount? appliedDiscount,
  }) {
    _receiptConfig = receiptConfig;
    _appliedDiscount = appliedDiscount;
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
  void cancel() {
    _appliedDiscount = null;
    emit(const CheckoutState.initial());
  }

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

        // 2b. Count the discount usage (best-effort; never fail the sale).
        await _recordDiscountUsage();

        // 3. Build the receipt for the preview/print stage.
        final changeDue = current.changeDueCents;
        final receipt = value.toReceipt(
          _receiptConfig,
          tenderedCents: method.requiresTender ? tenderedCents : null,
          changeCents: method.requiresTender ? changeDue : null,
        );

        emit(
          CheckoutState.success(
            order: value,
            method: method,
            tenderedCents: tenderedCents,
            receipt: receipt,
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

  /// Renders the success receipt and sends it to the connected printer.
  ///
  /// Updates the success state's [PrintStatus] so the UI can reflect progress.
  /// Printing failures never undo the sale — the order is already recorded.
  Future<void> printReceipt() async {
    final current = state;
    if (current is! CheckoutSuccess) return;
    final receipt = current.receipt;
    if (receipt == null) return;

    emit(current.copyWith(printStatus: PrintStatus.printing));

    try {
      final bytes = await _renderer.toEscPos(receipt);
      final result = await _printerService.printBytes(bytes);
      // Only mutate if still on the same success state.
      if (state is! CheckoutSuccess) return;
      emit(
        (state as CheckoutSuccess).copyWith(
          printStatus: result.isSuccess
              ? PrintStatus.printed
              : PrintStatus.failed,
        ),
      );
    } catch (error, stack) {
      _logger?.handle(error, stack, '[Checkout] printReceipt failed');
      if (state is CheckoutSuccess) {
        emit(
          (state as CheckoutSuccess).copyWith(printStatus: PrintStatus.failed),
        );
      }
    }
  }

  /// Increments the applied discount's usage count once a sale completes.
  /// Best-effort: a failure here must not undo the recorded sale (P6-2).
  Future<void> _recordDiscountUsage() async {
    final discount = _appliedDiscount;
    if (discount == null || discount.id == 0) return;

    final result = await _discountsRepository.incrementUsage(discount.id);
    if (result.isError) {
      _logger?.error('Failed to record usage for discount #${discount.id}');
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
