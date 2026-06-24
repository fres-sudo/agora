import '../database_mixin.dart';
import 'products_table.dart';
// Tracks current inventory level.

import 'package:drift/drift.dart';

@DataClassName("StockEntity")
class StocksTable extends Table with TableMixin {
  IntColumn get productId =>
      integer().references(ProductsTable, #id).unique()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
}
