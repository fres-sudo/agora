import 'package:drift/drift.dart';
import '../database_mixin.dart';
import 'clock_records_table.dart';

// One reconciliation per shift: recorded when a volunteer counts the drawer
// at clock-out (docs/features/04-volunteer-shift-accountability.md). Absence
// of a row for a given clockRecordId means the count was skipped, not that it
// balanced — the count step never blocks clocking out.
@DataClassName("CashReconciliationEntity")
class CashReconciliationsTable extends Table with TableMixin {
  IntColumn get clockRecordId =>
      integer().references(ClockRecordsTable, #id).unique()();
  IntColumn get expectedCents => integer()();
  IntColumn get countedCents => integer()();
  // countedCents - expectedCents, stored rather than derived so a later
  // report doesn't need to recompute historical math.
  IntColumn get varianceCents => integer()();
  TextColumn get note => text().nullable()();
}
