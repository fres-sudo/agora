import 'dart:ui';

import 'package:agora/discounts/services/local/daos/discounts_dao.dart';
import 'package:agora/discounts/services/local/tables/discounts_table.dart';
import 'package:agora/inventory/services/local/daos/stock_movements_dao.dart';
import 'package:agora/inventory/services/local/daos/stocks_dao.dart';
import 'package:agora/inventory/services/local/tables/stock_movements_table.dart';
import 'package:agora/inventory/services/local/tables/stocks_table.dart';
import 'package:agora/orders/local/daos/order_items_dao.dart';
import 'package:agora/orders/local/daos/orders_dao.dart';
import 'package:agora/orders/local/tables/oder_items_table.dart';
import 'package:agora/orders/local/tables/oders_table.dart';
import 'package:agora/products/services/local/daos/categories_dao.dart';
import 'package:agora/products/services/local/daos/modifiers_dao.dart';
import 'package:agora/products/services/local/daos/products_dao.dart';
import 'package:agora/products/services/local/tables/categories_table.dart';
import 'package:agora/products/services/local/tables/modifiers_table.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:agora/settings/services/local/daos/app_settings_dao.dart';
import 'package:agora/settings/services/local/tables/settings_table.dart';
import 'package:agora/core/database/color_converter.dart';
import 'package:drift/drift.dart';

part 'database.g.dart';

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
  ],
  daos: [
    CategoriesDao,
    ProductsDao,
    ModifiersDao,
    StocksDao,
    StockMovementsDao,
    OrdersDao,
    OrderItemsDao,
    DiscountsDao,
    AppSettingsDao,
  ],
)
class AgoraDatabase extends _$AgoraDatabase {
  AgoraDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
    );
  }
}
