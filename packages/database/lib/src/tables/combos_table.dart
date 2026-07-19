import 'package:drift/drift.dart';

import '../database_mixin.dart';
import 'products_table.dart';

// A combo: a fixed set of products sold together as one cart line at one
// flat price (e.g. "Menu Completo €10" = 1 panino + 1 patatine + 1 bibita).
// v1 is fixed-contents only, no substitutable/optional items
// (docs/features/03-combo-modifier-pricing.md).
@DataClassName("ComboEntity")
class CombosTable extends Table with TableMixin {
  TextColumn get name => text()();
  IntColumn get price =>
      integer()(); // Flat combo price in cents, overrides the sum of parts
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
}

// Many-to-many with a quantity: which products (and how many of each) make
// up a combo. Deliberately separate from ProductModifierLinksTable since the
// relationship semantics differ (consumption, not attachment).
@DataClassName("ComboItemEntity")
class ComboItemsTable extends Table with TableMixin {
  IntColumn get comboId =>
      integer().references(CombosTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().references(ProductsTable, #id)();
  TextColumn get productName =>
      text()(); // Denormalized, same convention as OrderItemsTable snapshots
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
