/// Whether the configured card terminal can accept a checkout.
enum CardPaymentReadiness {
  unsupported,
  notConfigured,
  loggedOut,
  ready,
}

/// Current provider and reader state shown to the operator.
final class CardPaymentStatus {
  const CardPaymentStatus({
    required this.readiness,
    this.merchantCode,
    this.currencyCode,
    this.readerModel,
    this.readerConnected = false,
    this.message,
  });

  final CardPaymentReadiness readiness;
  final String? merchantCode;
  final String? currencyCode;
  final String? readerModel;
  final bool readerConnected;
  final String? message;

  bool get canCharge => readiness == CardPaymentReadiness.ready;
}

/// Immutable request passed to a payment terminal.
final class CardChargeRequest {
  const CardChargeRequest({
    required this.amountCents,
    required this.currencyCode,
    required this.title,
    required this.foreignTransactionId,
  });

  final int amountCents;
  final String currencyCode;
  final String title;

  /// Stable, globally unique idempotency key for this payment attempt.
  final String foreignTransactionId;
}

/// Terminal checkout outcome. Only [CardChargeApproved] authorizes fulfillment.
sealed class CardChargeResult {
  const CardChargeResult();
}

final class CardChargeApproved extends CardChargeResult {
  const CardChargeApproved({required this.transactionCode});

  final String transactionCode;
}

final class CardChargeDeclined extends CardChargeResult {
  const CardChargeDeclined({this.message});

  final String? message;
}

final class CardChargeCancelled extends CardChargeResult {
  const CardChargeCancelled();
}

/// The SDK cannot prove whether money moved. The attempt must be reconciled
/// before another charge is initiated with a new idempotency key.
final class CardChargeUnknown extends CardChargeResult {
  const CardChargeUnknown({this.message});

  final String? message;
}

final class CardChargeFailed extends CardChargeResult {
  const CardChargeFailed({required this.message});

  final String message;
}

/// Provider-neutral card-reader boundary owned by the app shell.
abstract interface class CardPaymentService {
  Future<CardPaymentStatus> getStatus();

  Future<CardPaymentStatus> login();

  Future<CardPaymentStatus> openReaderSettings();

  Future<CardPaymentStatus> logout();

  Future<CardChargeResult> charge(CardChargeRequest request);
}
