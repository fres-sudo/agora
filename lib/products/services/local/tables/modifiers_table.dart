// Modifiers (Groups)
// Example: "Size", "Milk Type", "Toppings"
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
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
}
