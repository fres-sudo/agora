import 'package:bloc_exports/bloc_exports.dart';
import 'package:order_management/models/order.dart';

part 'report_data.freezed.dart';

/// Aggregated headline numbers for a reporting period.
@freezed
abstract class ReportSummary with _$ReportSummary {
  const factory ReportSummary({
    /// Number of completed orders in the period.
    @Default(0) int totalOrders,

    /// Sum of `grandTotalCents` across completed orders.
    @Default(0) int totalRevenueCents,

    /// Sum of `discountCents` across completed orders.
    @Default(0) int totalDiscountCents,

    /// Total quantity of line items sold across completed orders.
    @Default(0) int itemsSold,

    /// Average completed-order value in cents (`revenue / orders`).
    @Default(0) int averageTicketCents,

    /// Revenue taken in cash, in cents.
    @Default(0) int cashRevenueCents,

    /// Revenue taken by card, in cents.
    @Default(0) int cardRevenueCents,

    /// Sum of cash-reconciliation varianceCents across shifts closed within
    /// the period (docs/features/04-volunteer-shift-accountability.md).
    /// Negative means a net shortfall, positive a net overage.
    @Default(0) int cashVarianceCents,

    /// Hour of day (0–23) with the most completed orders, or null if none.
    int? peakHour,
  }) = _ReportSummary;

  const ReportSummary._();
}

/// A single point on the sales-over-time trend line.
@freezed
abstract class SalesPoint with _$SalesPoint {
  const factory SalesPoint({
    /// Axis label for this bucket (e.g. `14` for 2pm, or `Mon`).
    required String label,

    /// Revenue in cents accumulated within the bucket.
    required int revenueCents,
  }) = _SalesPoint;

  const SalesPoint._();
}

/// A product ranked by units sold within the period.
@freezed
abstract class ReportTopProduct with _$ReportTopProduct {
  const factory ReportTopProduct({
    required String name,
    required int quantitySold,
    required int revenueCents,
  }) = _ReportTopProduct;

  const ReportTopProduct._();
}

/// Count of orders in each lifecycle status for the period.
@freezed
abstract class OrderStatusBreakdown with _$OrderStatusBreakdown {
  const factory OrderStatusBreakdown({
    @Default(0) int completed,
    @Default(0) int pending,
    @Default(0) int voided,
  }) = _OrderStatusBreakdown;

  const OrderStatusBreakdown._();

  int get total => completed + pending + voided;
}

/// Snapshot of catalog stock health (derived from products, not period-scoped).
@freezed
abstract class StockBreakdown with _$StockBreakdown {
  const factory StockBreakdown({
    @Default(0) int inStock,
    @Default(0) int lowStock,
    @Default(0) int outOfStock,
  }) = _StockBreakdown;

  const StockBreakdown._();

  int get total => inStock + lowStock + outOfStock;
}

/// Everything the report screen renders for one period.
@freezed
abstract class ReportData with _$ReportData {
  const factory ReportData({
    required ReportSummary summary,
    required OrderStatusBreakdown statusBreakdown,
    required StockBreakdown stockBreakdown,
    @Default([]) List<SalesPoint> salesTrend,
    @Default([]) List<ReportTopProduct> topProducts,
    @Default([]) List<Order> recentOrders,
  }) = _ReportData;

  const ReportData._();

  static const empty = ReportData(
    summary: ReportSummary(),
    statusBreakdown: OrderStatusBreakdown(),
    stockBreakdown: StockBreakdown(),
  );
}
