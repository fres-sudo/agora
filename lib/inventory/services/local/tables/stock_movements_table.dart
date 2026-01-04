import 'package:agora/core/mixins/database_mixin.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:drift/drift.dart';

@DataClassName("StockMovementEntity")
class StockMovementsTable extends Table with TableMixin {
  IntColumn get productId => integer().references(ProductsTable, #id)();
  IntColumn get quantityChange => integer()(); // +5 for restock, -1 for sale
  TextColumn get reason => text()(); // "Sale #101", "Delivery", "Damaged"
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
