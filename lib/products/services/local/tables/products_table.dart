import 'package:agora/core/database/database.dart';
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:drift/drift.dart';

@DataClassName("ProductEntity")
class ProductsTable extends Table with TableMixin {
  TextColumn get name => text()();
  TextColumn get description => text()();

  BoolColumn get trackStock => boolean().withDefault(const Constant(true))();
  TextColumn get sku => text().unique().nullable()(); // Barcode/SKU

  IntColumn get categoryId =>
      integer().nullable().references(CategoryEntity, #id)();
  IntColumn get price =>
      integer().withDefault(const Constant(0))(); // Selling price in cents
  IntColumn get cost => integer().withDefault(
    const Constant(0),
  )(); // Cost price for profit reporting
}
