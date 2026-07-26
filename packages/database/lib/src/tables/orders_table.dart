import '../database_mixin.dart';
import 'employees_table.dart';

import 'package:drift/drift.dart';

// SQLite's `ALTER TABLE ADD COLUMN` cannot add a column with an inline
// UNIQUE constraint, so the uniqueness on syncId is declared as a separate
// index here rather than via `.unique()` on the column — this lets the
// same index get created by `m.createAll()` on fresh installs and by an
// explicit `customStatement` in `onUpgrade` for existing installs (see
// AgoraDatabase.migration). SQLite treats each NULL as distinct under a
// UNIQUE index, so pre-migration/unsynced rows never collide.
@TableIndex.sql(
  'CREATE UNIQUE INDEX idx_orders_sync_id ON orders_table (sync_id)',
)
@DataClassName("OrderEntity")
class OrdersTable extends Table with TableMixin {
  // Status: 0=Pending, 1=Completed, 2=Voided/Refunded
  IntColumn get status => integer().withDefault(const Constant(0))();

  // Order type: 0=Dine In, 1=Take Away
  IntColumn get orderType => integer().withDefault(const Constant(0))();

  // Monetary totals are stored in minor units, independent of the display
  // currency. The store setting supplies the symbol at presentation time.
  IntColumn get subtotal => integer()(); // Cents before tax and discounts.
  IntColumn get discountTotal =>
      integer().withDefault(const Constant(0))(); // Cents.
  IntColumn get taxTotal =>
      integer().withDefault(const Constant(0))(); // Cents.
  IntColumn get grandTotal => integer()(); // Cents after tax and discounts.

  TextColumn get paymentMethod => text().nullable()(); // "Cash", "Card", etc.
  TextColumn get note => text().nullable()();

  // Cross-station identity for LAN sync (uuid v4, client-generated at
  // create time). Nullable permanently — pre-migration orders never had
  // one and are never synced retroactively. Uniqueness enforced by the
  // idx_orders_sync_id index above, not an inline column constraint.
  TextColumn get syncId => text().nullable()();

  // Volunteer who took the order, for shift cash reconciliation
  // (docs/features/04-volunteer-shift-accountability.md). Nullable
  // defensively — checkout shouldn't crash if session state is ever
  // momentarily absent — and never populated on orders applied from a peer
  // station via LAN sync, since employee records aren't synced cross-station
  // and a raw local id would be meaningless (or wrong) on another machine.
  IntColumn get employeeId =>
      integer().nullable().references(EmployeesTable, #id)();
}
