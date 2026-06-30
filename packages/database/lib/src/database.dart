import 'dart:ui';

import 'package:drift/drift.dart';

import 'color_converter.dart';
import 'tables/categories_table.dart';
import 'tables/discounts_table.dart';
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
      onUpgrade: (m, from, to) async {
        // v1 -> v2: add `orderType` to orders (0 = Dine In, 1 = Take Away).
        if (from < 2) {
          await m.addColumn(ordersTable, ordersTable.orderType);
        }
      },
    );
  }
}
