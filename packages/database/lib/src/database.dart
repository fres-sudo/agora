import 'dart:ui';

import 'package:drift/drift.dart';

import 'color_converter.dart';
import 'tables/categories_table.dart';
import 'tables/clock_records_table.dart';
import 'tables/discounts_table.dart';
import 'tables/employees_table.dart';
import 'tables/modifiers_table.dart';
import 'tables/order_items_table.dart';
import 'tables/orders_table.dart';
import 'tables/outbox_table.dart';
import 'tables/products_table.dart';
import 'tables/settings_table.dart';
import 'tables/stock_movements_table.dart';
import 'tables/stocks_table.dart';

part 'database.g.dart';

// Tables are registered here; DAOs live in their respective feature packages
// and are instantiated by passing the AgoraDatabase instance to them.
@DriftDatabase(
  tables: [
    CategoriesTable,
    ProductsTable,
    ModifiersTable,
    ModifierOptionsTable,
    ProductModifierLinksTable,
    StocksTable,
    StockMovementsTable,
    OrdersTable,
    OrderItemsTable,
    OrderItemModifiers,
    DiscountsTable,
    AppSettingsTable,
    OutboxTable,
    EmployeesTable,
    ClockRecordsTable,
  ],
)
class AgoraDatabase extends _$AgoraDatabase {
  AgoraDatabase(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      // Incremental, additive migrations only. The local Drift database is
      // often the only copy of unsynced orders/inventory/workforce data
      // until it reaches the backend, so schema bumps must never drop
      // tables or otherwise destroy existing rows.
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // v1 -> v2: add `orderType` to orders (0 = Dine In, 1 = Take Away).
          await m.addColumn(ordersTable, ordersTable.orderType);
        }
        if (from < 3) {
          // v2 -> v3: add unique (productId, modifierId) constraint to
          // ProductModifierLinksTable. De-duplicate any pre-existing links
          // before the schema change so no constraint violation occurs.
          await customStatement(
            'DELETE FROM product_modifier_links_table '
            'WHERE id NOT IN ('
            'SELECT MIN(id) FROM product_modifier_links_table '
            'GROUP BY product_id, modifier_id'
            ')',
          );
        }
        if (from < 4) {
          // v3 -> v4: add a partial unique index on clock_records_table so
          // an employee can only have one open shift at a time.
          await customStatement(
            'CREATE UNIQUE INDEX IF NOT EXISTS idx_clock_records_one_open_shift '
            'ON clock_records_table (employee_id) '
            'WHERE clocked_out_at IS NULL AND deleted_at IS NULL',
          );
        }
      },
    );
  }

  /// Wipes every row from every table (a hard factory reset), keeping the
  /// schema intact. Used by the "Reset app & data" flow so the operator can
  /// re-run onboarding from a clean slate. Foreign-key enforcement is off by
  /// default here, so table order does not matter.
  Future<void> resetAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
