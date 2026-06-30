part of 'checkout_cubit.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const CheckoutState._();

  /// No checkout in progress.
  const factory CheckoutState.initial() = _Initial;

  /// Checkout is open and the operator is selecting payment.
  const factory CheckoutState.selecting({
    required Order order,
    required PaymentMethod method,
    @Default(0) int tenderedCents,
  }) = CheckoutSelecting;

  /// The order is being finalised (persisted, completed, stock decremented).
  const factory CheckoutState.processing({
    required Order order,
    required PaymentMethod method,
    @Default(0) int tenderedCents,
  }) = _Processing;

  /// The sale completed successfully.
  const factory CheckoutState.success({
    required Order order,
    required PaymentMethod method,
    @Default(0) int tenderedCents,
  }) = CheckoutSuccess;

  /// The checkout failed; [order]/[method] preserved so the operator can retry.
  const factory CheckoutState.failure({
    required String message,
    required Order order,
    required PaymentMethod method,
    @Default(0) int tenderedCents,
  }) = _Failure;

  /// The grand total to collect, in cents.
  int get totalCents => maybeMap(
    selecting: (s) => s.order.grandTotalCents,
    processing: (s) => s.order.grandTotalCents,
    success: (s) => s.order.grandTotalCents,
    failure: (s) => s.order.grandTotalCents,
    orElse: () => 0,
  );

  /// The currently selected payment method, if a checkout is active.
  PaymentMethod? get method => maybeMap(
    selecting: (s) => s.method,
    processing: (s) => s.method,
    success: (s) => s.method,
    failure: (s) => s.method,
    orElse: () => null,
  );

  /// The amount tendered for cash payments, in cents.
  int get tenderedCents => maybeMap(
    selecting: (s) => s.tenderedCents,
    processing: (s) => s.tenderedCents,
    success: (s) => s.tenderedCents,
    failure: (s) => s.tenderedCents,
    orElse: () => 0,
  );

  /// Change owed back to the customer for cash payments, in cents.
  /// Never negative.
  int get changeDueCents {
    final change = tenderedCents - totalCents;
    return change > 0 ? change : 0;
  }

  /// Whether the current selection can be confirmed.
  ///
  /// Card payments are always confirmable; cash requires the tendered amount to
  /// cover the total.
  bool get canConfirm => maybeMap(
    selecting: (s) =>
        !s.method.requiresTender || s.tenderedCents >= s.order.grandTotalCents,
    orElse: () => false,
  );

  /// Whether a finalisation is currently running.
  bool get isProcessing =>
      maybeMap(processing: (_) => true, orElse: () => false);
}
