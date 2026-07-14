import '../database_mixin.dart';
import 'products_table.dart';

import 'package:drift/drift.dart';

// See OrdersTable.syncId's doc comment for why this is a separate index
// rather than `.unique()` on the column.
@TableIndex.sql(
  'CREATE UNIQUE INDEX idx_stock_movements_sync_id '
  'ON stock_movements_table (sync_id)',
)
@DataClassName("StockMovementEntity")
class StockMovementsTable extends Table with TableMixin {
  IntColumn get productId => integer().references(ProductsTable, #id)();
  IntColumn get quantityChange => integer()(); // +5 for restock, -1 for sale
  TextColumn get reason => text()(); // "Sale #101", "Delivery", "Damaged"
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  // Cross-station identity for LAN sync (uuid v4, client-generated at
  // create time). Nullable permanently, same reasoning as
  // OrdersTable.syncId — only movements created after this migration are
  // ever synced. Uniqueness enforced by the idx_stock_movements_sync_id
  // index above, not an inline column constraint.
  TextColumn get syncId => text().nullable()();
}
