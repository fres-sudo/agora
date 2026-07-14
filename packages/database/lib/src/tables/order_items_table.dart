// CRITICAL: We copy the product name and cost at the time of sale.
import 'package:drift/drift.dart';

import '../database_mixin.dart';
import 'orders_table.dart';
import 'products_table.dart';

@DataClassName("OrderItemEntity")
class OrderItemsTable extends Table with TableMixin {
  IntColumn get orderId =>
      integer().references(OrdersTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId =>
      integer().nullable().references(ProductsTable, #id)();

  // Data Snapshots (History protection)
  TextColumn get productName => text()();
  IntColumn get unitPrice => integer()(); // Price at moment of sale
  IntColumn get costPrice =>
      integer()(); // Cost at moment of sale (for profit calculation)

  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();

  // Prep-station snapshot (from ProductsTable.prepStation at sale time, same
  // reasoning as productName/unitPrice above). Null = never ticketed, stays
  // on the customer receipt only (docs/features/02-kitchen-ticket-routing.md).
  TextColumn get prepStation => text().nullable()();

  // Kitchen ticket status: 0=pending, 1=inProgress, 2=ready, 3=bumped.
  // Meaningless for items with a null prepStation.
  IntColumn get ticketStatus => integer().withDefault(const Constant(0))();
}

// Tracks specific choices made for a line item (e.g., "No Sugar")
@DataClassName("OrderItemModifierEntity")
class OrderItemModifiers extends Table with TableMixin {
  IntColumn get orderItemId =>
      integer().references(OrderItemsTable, #id, onDelete: KeyAction.cascade)();

  // Snapshot of the option name and price at time of sale
  TextColumn get modifierName => text()(); // e.g. "Size"
  TextColumn get optionName => text()(); // e.g. "Large"
  IntColumn get priceChange => integer()();
}
