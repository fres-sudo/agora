import 'package:database/database.dart';
import 'package:result/result.dart';
import 'package:result/result.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/selected_modifiers.dart';
import 'package:drift/drift.dart';
import 'package:talker/talker.dart';

/// Repository interface for order item operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class OrderItemsRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all items for a specific order.
  Stream<List<OrderLineItem>> watchItemsByOrderId(int orderId);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets all items for a specific order.
  Future<Result<List<OrderLineItem>>> getItemsByOrderId(int orderId);

  /// Gets the total number of items for an order.
  Future<Result<int>> getItemsCount(int orderId);

  /// Gets the total quantity of all items for an order.
  Future<Result<int>> getTotalQuantity(int orderId);

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Adds an item to an order.
  /// Returns the added [OrderLineItem] for optimistic updates.
  Future<Result<OrderLineItem>> addItemToOrder({
    required int orderId,
    required OrderLineItem item,
  });

  /// Updates an item's quantity.
  /// Returns the updated [OrderLineItem] for optimistic updates.
  Future<Result<OrderLineItem>> updateItemQuantity({
    required int itemId,
    required int quantity,
    required OrderLineItem item,
  });

  /// Removes an item from an order (soft delete).
  /// Returns the removed item ID for optimistic updates.
  Future<Result<int>> removeItem(int itemId);

  /// Adds a modifier to an order item.
  /// Returns the [SelectedModifiers] for optimistic updates.
  Future<Result<SelectedModifiers>> addModifierToItem({
    required int itemId,
    required SelectedModifiers modifier,
  });

  /// Removes a modifier from an order item.
  Future<Result<int>> removeModifierFromItem(int modifierId);
}
