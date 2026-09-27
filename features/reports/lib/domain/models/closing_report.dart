import 'package:bloc_exports/bloc_exports.dart';

part 'closing_report.freezed.dart';

/// Aggregated snapshot of a single cash-closure session.
///
/// Built on demand from the live order history; persisted to [ClosingReportsTable]
/// when the operator taps "Salva Chiusura".
@freezed
abstract class ClosingReport with _$ClosingReport {
  const factory ClosingReport({
    /// Set once persisted; null for an unsaved in-progress closure.
    int? id,

    /// Start of the reporting window (inclusive).
    required DateTime periodStart,

    /// End of the reporting window (inclusive).
    required DateTime periodEnd,

    /// Number of completed orders in the period.
    required int totalOrders,

    /// Sum of [grandTotalCents] across completed orders (tax included).
    required int totalRevenueCents,

    /// Sum of [taxCents] across completed orders.
    required int totalTaxCents,

    /// Sum of [discountCents] across completed orders.
    required int totalDiscountCents,

    /// Revenue collected in cash, in cents.
    required int cashRevenueCents,

    /// Revenue collected by card, in cents.
    required int cardRevenueCents,

    /// Number of voided orders in the period.
    required int voidedOrders,

    /// Cash physically counted in the drawer by the operator.
    /// Null if the operator skipped the cash-count step.
    int? cashCountedCents,

    /// Free-text note from the operator (optional).
    String? notes,

    /// Set to [DateTime.now()] at persist time.
    DateTime? createdAt,
  }) = _ClosingReport;

  const ClosingReport._();

  /// Difference between counted and expected cash; positive = overage.
  /// Always 0 when [cashCountedCents] is null.
  int get cashVarianceCents =>
      cashCountedCents != null ? cashCountedCents! - cashRevenueCents : 0;

  bool get isSaved => id != null;
}
