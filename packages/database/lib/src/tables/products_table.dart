import '../database_mixin.dart';
import 'categories_table.dart';

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
  // Monetary amounts are stored in minor units, independent of the display
  // currency. The store setting supplies the symbol at presentation time.
  IntColumn get price =>
      integer().withDefault(const Constant(0))(); // Selling price in cents
  IntColumn get cost => integer().withDefault(
    const Constant(0),
  )(); // Cost price in cents for profit reporting
  IntColumn get taxPercent =>
      integer().withDefault(const Constant(0))(); // Tax percentage
  TextColumn get status => text().withDefault(const Constant('draft'))();

  // Free-text prep-station label (e.g. "Griglia", "Bar") used to route this
  // product's order items to a kitchen ticket queue. Null means the item
  // never leaves the regular customer receipt (docs/features/02-kitchen-ticket-routing.md).
  TextColumn get prepStation => text().nullable()();
}
