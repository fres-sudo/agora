
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:agora/products/services/local/tables/categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName("ProductEntity")
class ProductsTable extends Table with TableMixin {
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get imageUrl => text().nullable()();

  BoolColumn get trackStock => boolean().withDefault(const Constant(true))();
  TextColumn get sku => text().unique().nullable()(); // Barcode/SKU

  IntColumn get categoryId =>
      integer().nullable().references(CategoriesTable, #id)();
  IntColumn get price =>
      integer().withDefault(const Constant(0))(); // Selling price in cents
  IntColumn get cost => integer().withDefault(
    const Constant(0),
  )(); // Cost price for profit reporting
  IntColumn get taxPercent =>
      integer().withDefault(const Constant(0))(); // Tax percentage
  TextColumn get status => text().withDefault(const Constant('draft'))();
}
