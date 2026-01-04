import 'package:agora/core/database/database.dart';
import 'package:agora/orders/local/tables/oder_items_table.dart';
import 'package:agora/orders/local/tables/oders_table.dart';
import 'package:drift/drift.dart';

part 'order_items_dao.g.dart';

@DriftAccessor(tables: [OrderItemsTable, OrderItemModifiers, OrdersTable])
class OrderItemsDao extends DatabaseAccessor<AgoraDatabase>
    with _$OrderItemsDaoMixin {
  OrderItemsDao(super.db);

  // ============================================================
  // ORDER ITEMS - READ OPERATIONS
  // ============================================================

  /// Watches all items for a specific order.
  Stream<List<OrderItemEntity>> watchItemsByOrderId(int orderId) {
    return (select(orderItemsTable)
          ..where((t) => t.orderId.equals(orderId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  /// Gets all items for a specific order (Future-based).
  Future<List<OrderItemEntity>> getItemsByOrderId(int orderId) {
    return (select(orderItemsTable)
          ..where((t) => t.orderId.equals(orderId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  /// Gets a single order item by ID.
  Future<OrderItemEntity?> getOrderItemById(int id) {
    return (select(
      orderItemsTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Gets the total number of items for an order.
  Future<int> getItemsCountByOrderId(int orderId) async {
    final count = orderItemsTable.id.count();
    final query = selectOnly(orderItemsTable)
      ..addColumns([count])
      ..where(
        orderItemsTable.orderId.equals(orderId) &
            orderItemsTable.deletedAt.isNull(),
      );
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Gets the total quantity of all items for an order.
  Future<int> getTotalQuantityByOrderId(int orderId) async {
    final sum = orderItemsTable.quantity.sum();
    final query = selectOnly(orderItemsTable)
      ..addColumns([sum])
      ..where(
        orderItemsTable.orderId.equals(orderId) &
            orderItemsTable.deletedAt.isNull(),
      );
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  // ============================================================
  // ORDER ITEMS - WRITE OPERATIONS
  // ============================================================

  /// Inserts a new order item and returns the new ID.
  Future<int> insertOrderItem(OrderItemEntity companion) {
    return into(orderItemsTable).insert(companion);
  }

  /// Updates an existing order item.
  Future<bool> updateOrderItem(int id, OrderItemEntity companion) {
    return (update(orderItemsTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Updates the quantity of an order item.
  Future<bool> updateOrderItemQuantity(int id, int quantity) {
    return (update(orderItemsTable)..where((t) => t.id.equals(id)))
        .write(
          OrderItemsTableCompanion(
            quantity: Value(quantity),
            updatedAt: Value(DateTime.now()),
          ),
        )
        .then((rows) => rows > 0);
  }

  // ============================================================
  // ORDER ITEMS - DELETE OPERATIONS
  // ============================================================

  /// Soft deletes an order item.
  Future<bool> softDeleteOrderItem(int id) {
    return (update(orderItemsTable)..where((t) => t.id.equals(id)))
        .write(OrderItemsTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes an order item.
  Future<int> hardDeleteOrderItem(int id) {
    return (delete(orderItemsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Permanently deletes all items for an order.
  Future<int> hardDeleteItemsByOrderId(int orderId) {
    return (delete(
      orderItemsTable,
    )..where((t) => t.orderId.equals(orderId))).go();
  }

  // ============================================================
  // ORDER ITEM MODIFIERS - READ OPERATIONS
  // ============================================================

  /// Watches all modifiers for a specific order item.
  Stream<List<OrderItemModifierEntity>> watchModifiersByOrderItemId(
    int orderItemId,
  ) {
    return (select(orderItemModifiers)
          ..where((t) => t.orderItemId.equals(orderItemId))
          ..orderBy([(t) => OrderingTerm.asc(t.modifierName)]))
        .watch();
  }

  /// Gets all modifiers for a specific order item (Future-based).
  Future<List<OrderItemModifierEntity>> getModifiersByOrderItemId(
    int orderItemId,
  ) {
    return (select(orderItemModifiers)
          ..where((t) => t.orderItemId.equals(orderItemId))
          ..orderBy([(t) => OrderingTerm.asc(t.modifierName)]))
        .get();
  }

  /// Gets the total price change from modifiers for an order item.
  Future<int> getTotalModifierPriceByOrderItemId(int orderItemId) async {
    final sum = orderItemModifiers.priceChange.sum();
    final query = selectOnly(orderItemModifiers)
      ..addColumns([sum])
      ..where(orderItemModifiers.orderItemId.equals(orderItemId));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  // ============================================================
  // ORDER ITEM MODIFIERS - WRITE OPERATIONS
  // ============================================================

  /// Inserts a new order item modifier and returns the new ID.
  Future<int> insertOrderItemModifier(OrderItemModifiersCompanion companion) {
    return into(orderItemModifiers).insert(companion);
  }

  /// Adds a modifier to an order item with all required fields.
  Future<int> addModifierToOrderItem({
    required int orderItemId,
    required String modifierName,
    required String optionName,
    required int priceChange,
  }) {
    return into(orderItemModifiers).insert(
      OrderItemModifiersCompanion.insert(
        orderItemId: orderItemId,
        modifierName: modifierName,
        optionName: optionName,
        priceChange: priceChange,
      ),
    );
  }

  // ============================================================
  // ORDER ITEM MODIFIERS - DELETE OPERATIONS
  // ============================================================

  /// Deletes a specific order item modifier.
  Future<int> deleteOrderItemModifier(int id) {
    return (delete(orderItemModifiers)..where((t) => t.id.equals(id))).go();
  }

  /// Deletes all modifiers for an order item.
  Future<int> deleteModifiersByOrderItemId(int orderItemId) {
    return (delete(
      orderItemModifiers,
    )..where((t) => t.orderItemId.equals(orderItemId))).go();
  }
}
