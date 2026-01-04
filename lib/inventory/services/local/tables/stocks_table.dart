// Tracks current inventory level.
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:drift/drift.dart';

@DataClassName("StockEntity")
class StocksTable extends Table with TableMixin {
  IntColumn get productId =>
      integer().references(ProductsTable, #id).unique()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
}
