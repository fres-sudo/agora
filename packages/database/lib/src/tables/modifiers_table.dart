import '../database_mixin.dart';
import 'products_table.dart';
// Modifiers (Groups)
// Example: "Size", "Milk Type", "Toppings"

import 'package:drift/drift.dart';

@DataClassName("ModifierEntity")
class ModifiersTable extends Table with TableMixin {
  TextColumn get name => text()(); // e.g., "Pizza Toppings"
  BoolColumn get isMultiSelect =>
      boolean().withDefault(const Constant(false))(); // Radio vs Checkbox
}

// Example: "Small", "Medium", "Large", "Oat Milk"
@DataClassName("ModifierOptionEntity")
class ModifierOptionsTable extends Table with TableMixin {
  IntColumn get modifierId => integer().references(ModifiersTable, #id)();
  TextColumn get name => text()();
  IntColumn get priceChange =>
      integer().withDefault(const Constant(0))(); // Additional cost in cents
}

// Many-to-Many relationship: Which products have which modifiers?
@DataClassName("ProductModifierLinkEntity")
class ProductModifierLinksTable extends Table with TableMixin {
  IntColumn get productId => integer().references(ProductsTable, #id)();
  IntColumn get modifierId => integer().references(ModifiersTable, #id)();

  // A product may only be linked to a given modifier once. Without this,
  // nothing stops the same modifier from being attached to a product more
  // than once, which surfaces as a duplicated option in the POS/product UI.
  @override
  List<Set<Column>> get uniqueKeys => [
    {productId, modifierId},
  ];
}
