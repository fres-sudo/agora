import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/payment_method.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:feature_products/domain/models/product.dart';
import 'package:feature_products/domain/repositories/products_repository.dart';
import 'package:feature_reports/domain/models/report_data.dart';
import 'package:feature_reports/domain/models/report_period.dart';
import 'package:feature_reports/domain/repositories/reports_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

/// Aggregates local order + product data into a [ReportData].
///
/// Composes the already-registered [OrdersRepository] and [ProductsRepository]
/// (reports depends on those features; they never depend on reports). All
/// aggregation happens in-memory over the period's orders — no new DAO queries
/// are required.
class ReportsRepositoryImpl extends Repository implements ReportsRepository {
  ReportsRepositoryImpl({
    required OrdersRepository ordersRepository,
    required ProductsRepository productsRepository,
    Talker? logger,
  }) : _ordersRepository = ordersRepository,
       _productsRepository = productsRepository,
       super(logger);

  final OrdersRepository _ordersRepository;
  final ProductsRepository _productsRepository;

  /// Products at or below this stock level (but > 0) count as "low stock".
  static const int _lowStockThreshold = 5;

  /// How many products to include in the "top products" ranking.
  static const int _topProductsLimit = 10;

  /// How many orders to surface in the recent-orders table.
  static const int _recentOrdersLimit = 10;

  @override
  Future<Result<ReportData>> getReport(
    ReportPeriod period, {
    DateTime? now,
  }) => safe('getReport(${period.name})', () async {
    final range = period.range(now: now);

    final orders = await _ordersRepository
        .watchOrdersByDateRange(startDate: range.start, endDate: range.end)
        .first;
    final products = await _productsRepository.watchAllProducts().first;

    final completed = orders
        .where((o) => o.status == OrderStatus.completed)
        .toList();

    return ReportData(
      summary: _buildSummary(completed),
      statusBreakdown: _buildStatusBreakdown(orders),
      stockBreakdown: _buildStockBreakdown(products),
      salesTrend: _buildSalesTrend(completed, period),
      topProducts: _buildTopProducts(completed),
      recentOrders: orders.take(_recentOrdersLimit).toList(),
    );
  });

  // ============================================================
  // Aggregation helpers
  // ============================================================

  ReportSummary _buildSummary(List<Order> completed) {
    if (completed.isEmpty) return const ReportSummary();

    var revenue = 0;
    var discount = 0;
    var items = 0;
    var cash = 0;
    var card = 0;
    final ordersByHour = <int, int>{};

    for (final order in completed) {
      revenue += order.grandTotalCents;
      discount += order.discountCents;
      for (final item in order.items) {
        items += item.quantity;
      }

      switch (PaymentMethod.fromLabel(order.paymentMethod)) {
        case PaymentMethod.cash:
          cash += order.grandTotalCents;
        case PaymentMethod.card:
          card += order.grandTotalCents;
        case null:
          break; // Unknown/unset method: counted in revenue, not in the split.
      }

      final hour = order.createdAt.hour;
      ordersByHour.update(hour, (v) => v + 1, ifAbsent: () => 1);
    }

    int? peakHour;
    var peakCount = 0;
    ordersByHour.forEach((hour, count) {
      if (count > peakCount) {
        peakCount = count;
        peakHour = hour;
      }
    });

    return ReportSummary(
      totalOrders: completed.length,
      totalRevenueCents: revenue,
      totalDiscountCents: discount,
      itemsSold: items,
      averageTicketCents: revenue ~/ completed.length,
      cashRevenueCents: cash,
      cardRevenueCents: card,
      peakHour: peakHour,
    );
  }

  OrderStatusBreakdown _buildStatusBreakdown(List<Order> orders) {
    var completed = 0;
    var pending = 0;
    var voided = 0;
    for (final order in orders) {
      switch (order.status) {
        case OrderStatus.completed:
          completed++;
        case OrderStatus.pending:
          pending++;
        case OrderStatus.voided:
          voided++;
      }
    }
    return OrderStatusBreakdown(
      completed: completed,
      pending: pending,
      voided: voided,
    );
  }

  StockBreakdown _buildStockBreakdown(List<Product> products) {
    var inStock = 0;
    var lowStock = 0;
    var outOfStock = 0;
    for (final product in products) {
      if (!product.trackStock) {
        inStock++;
        continue;
      }
      if (product.stockQuantity <= 0) {
        outOfStock++;
      } else if (product.stockQuantity <= _lowStockThreshold) {
        lowStock++;
      } else {
        inStock++;
      }
    }
    return StockBreakdown(
      inStock: inStock,
      lowStock: lowStock,
      outOfStock: outOfStock,
    );
  }

  List<ReportTopProduct> _buildTopProducts(List<Order> completed) {
    final byName = <String, ReportTopProduct>{};
    for (final order in completed) {
      for (final item in order.items) {
        final existing = byName[item.productName];
        final lineRevenue = _lineTotalCents(item);
        byName[item.productName] = existing == null
            ? ReportTopProduct(
                name: item.productName,
                quantitySold: item.quantity,
                revenueCents: lineRevenue,
              )
            : existing.copyWith(
                quantitySold: existing.quantitySold + item.quantity,
                revenueCents: existing.revenueCents + lineRevenue,
              );
      }
    }

    final ranked = byName.values.toList()
      ..sort((a, b) => b.quantitySold.compareTo(a.quantitySold));
    return ranked.take(_topProductsLimit).toList();
  }

  /// Buckets completed-order revenue over time. Granularity follows the period:
  /// hourly for today, daily for a week/month, monthly for all-time.
  List<SalesPoint> _buildSalesTrend(List<Order> completed, ReportPeriod period) {
    const weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const monthLabels = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    switch (period) {
      case ReportPeriod.today:
        // Hourly buckets across trading hours actually seen (min..max hour).
        return _bucket(
          completed,
          keyOf: (o) => o.createdAt.hour,
          labelOf: (hour) => hour.toString().padLeft(2, '0'),
        );
      case ReportPeriod.week:
        return _bucket(
          completed,
          keyOf: (o) => o.createdAt.weekday, // 1..7
          labelOf: (weekday) => weekdayLabels[weekday - 1],
        );
      case ReportPeriod.month:
        return _bucket(
          completed,
          keyOf: (o) => o.createdAt.day,
          labelOf: (day) => day.toString(),
        );
      case ReportPeriod.all:
        return _bucket(
          completed,
          keyOf: (o) => o.createdAt.year * 100 + o.createdAt.month,
          labelOf: (ym) => monthLabels[(ym % 100) - 1],
        );
    }
  }

  /// Groups [orders] by [keyOf], summing grand totals, and returns ascending
  /// [SalesPoint]s labelled via [labelOf].
  List<SalesPoint> _bucket(
    List<Order> orders, {
    required int Function(Order) keyOf,
    required String Function(int) labelOf,
  }) {
    final byKey = <int, int>{};
    for (final order in orders) {
      byKey.update(
        keyOf(order),
        (v) => v + order.grandTotalCents,
        ifAbsent: () => order.grandTotalCents,
      );
    }
    final keys = byKey.keys.toList()..sort();
    return [
      for (final key in keys)
        SalesPoint(label: labelOf(key), revenueCents: byKey[key]!),
    ];
  }

  int _lineTotalCents(OrderLineItem item) {
    final modifiers = item.selectedModifiers.fold<int>(
      0,
      (sum, m) => sum + m.priceChangeCents,
    );
    return item.quantity * (item.unitPriceCents + modifiers);
  }
}
