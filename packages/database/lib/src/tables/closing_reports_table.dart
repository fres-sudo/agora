import 'package:drift/drift.dart';
import '../database_mixin.dart';

/// Persisted record of each end-of-day / end-of-shift cash closure.
/// One row per closure action taken by the operator.
@DataClassName('ClosingReportEntity')
class ClosingReportsTable extends Table with TableMixin {
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  IntColumn get totalOrders => integer()();
  IntColumn get totalRevenueCents => integer()();
  IntColumn get totalTaxCents => integer()();
  IntColumn get totalDiscountCents => integer()();
  IntColumn get cashRevenueCents => integer()();
  IntColumn get cardRevenueCents => integer()();
  IntColumn get voidedOrders => integer()();

  /// Cash physically counted in the drawer by the operator; null if skipped.
  IntColumn get cashCountedCents => integer().nullable()();
  TextColumn get notes => text().nullable()();
}
