import 'package:database/database.dart';
import 'package:drift/drift.dart';
import 'package:feature_reports/data/sources/local/daos/closing_reports_dao.dart';
import 'package:feature_reports/domain/models/closing_report.dart';
import 'package:feature_reports/domain/repositories/closing_report_repository.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/payment_method.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

class ClosingReportRepositoryImpl extends Repository
    implements ClosingReportRepository {
  ClosingReportRepositoryImpl({
    required OrdersRepository ordersRepository,
    required ClosingReportsDao dao,
    Talker? logger,
  }) : _ordersRepository = ordersRepository,
       _dao = dao,
       super(logger);

  final OrdersRepository _ordersRepository;
  final ClosingReportsDao _dao;

  @override
  Future<Result<ClosingReport>> buildForPeriod(
    DateTime start,
    DateTime end,
  ) => safe('buildForPeriod', () async {
    final orders = await _ordersRepository
        .watchOrdersByDateRange(startDate: start, endDate: end)
        .first;

    var revenue = 0;
    var taxTotal = 0;
    var discountTotal = 0;
    var cash = 0;
    var card = 0;
    var completed = 0;
    var voided = 0;

    for (final order in orders) {
      switch (order.status) {
        case OrderStatus.completed:
          completed++;
          revenue += order.grandTotalCents;
          taxTotal += order.taxCents;
          discountTotal += order.discountCents;
          switch (PaymentMethod.fromLabel(order.paymentMethod)) {
            case PaymentMethod.cash:
              cash += order.grandTotalCents;
            case PaymentMethod.card:
              card += order.grandTotalCents;
            case null:
              break;
          }
        case OrderStatus.voided:
          voided++;
        case OrderStatus.pending:
        case OrderStatus.paymentPending:
          break;
      }
    }

    return ClosingReport(
      periodStart: start,
      periodEnd: end,
      totalOrders: completed,
      totalRevenueCents: revenue,
      totalTaxCents: taxTotal,
      totalDiscountCents: discountTotal,
      cashRevenueCents: cash,
      cardRevenueCents: card,
      voidedOrders: voided,
    );
  });

  @override
  Stream<List<ClosingReport>> watchAll() => _dao
      .watchAll()
      .map((entities) => entities.map(_toModel).toList())
      .safeCode(logger);

  @override
  Future<Result<ClosingReport>> save(ClosingReport report) =>
      safe('save', () async {
        final now = DateTime.now();
        final companion = ClosingReportsTableCompanion.insert(
          periodStart: report.periodStart,
          periodEnd: report.periodEnd,
          totalOrders: report.totalOrders,
          totalRevenueCents: report.totalRevenueCents,
          totalTaxCents: report.totalTaxCents,
          totalDiscountCents: report.totalDiscountCents,
          cashRevenueCents: report.cashRevenueCents,
          cardRevenueCents: report.cardRevenueCents,
          voidedOrders: report.voidedOrders,
          cashCountedCents: Value(report.cashCountedCents),
          notes: Value(report.notes),
        );
        final id = await _dao.insertRecord(companion);
        return report.copyWith(id: id, createdAt: now);
      });

  ClosingReport _toModel(ClosingReportEntity e) => ClosingReport(
    id: e.id,
    periodStart: e.periodStart,
    periodEnd: e.periodEnd,
    totalOrders: e.totalOrders,
    totalRevenueCents: e.totalRevenueCents,
    totalTaxCents: e.totalTaxCents,
    totalDiscountCents: e.totalDiscountCents,
    cashRevenueCents: e.cashRevenueCents,
    cardRevenueCents: e.cardRevenueCents,
    voidedOrders: e.voidedOrders,
    cashCountedCents: e.cashCountedCents,
    notes: e.notes,
    createdAt: e.createdAt,
  );
}
