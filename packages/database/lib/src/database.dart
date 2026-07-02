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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      // Not in production: on any schema bump, drop everything and recreate.
      // Replace with real migrations before shipping.
      onUpgrade: (m, from, to) async {
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
      },
    );
  }
}
