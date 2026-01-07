import 'package:agora/core/database/database.dart';
import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/orders/local/daos/order_items_dao.dart';
import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:agora/orders/models/selected_modifiers/selected_modifiers.dart';
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

/// Implementation of [OrderItemsRepository] using Drift DAOs.
class OrderItemsRepositoryImpl extends Repository
    implements OrderItemsRepository {
  OrderItemsRepositoryImpl({
    required OrderItemsDao orderItemsDao,
    Talker? logger,
  }) : _orderItemsDao = orderItemsDao,
       super(logger);

  final OrderItemsDao _orderItemsDao;

  // ============================================================
  // HELPERS
  // ============================================================

  Future<OrderLineItem> _entityToModel(OrderItemEntity entity) async {
    final modifierEntities = await _orderItemsDao.getModifiersByOrderItemId(
      entity.id,
    );
    return OrderLineItem(
      productId: entity.productId,
      productName: entity.productName,
      quantity: entity.quantity,
      unitPriceCents: entity.unitPrice,
      selectedModifiers: modifierEntities
          .map(
            (m) => SelectedModifiers(
              groupName: m.modifierName,
              optionName: m.optionName,
              priceChangeCents: m.priceChange,
            ),
          )
          .toList(),
    );
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<OrderLineItem>> watchItemsByOrderId(int orderId) {
    return _orderItemsDao
        .watchItemsByOrderId(orderId)
        .asyncMap((entities) async {
          final items = <OrderLineItem>[];
          for (final entity in entities) {
            items.add(await _entityToModel(entity));
          }
          return items;
        })
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<List<OrderLineItem>>> getItemsByOrderId(int orderId) =>
      safe('getItemsByOrderId($orderId)', () async {
        final entities = await _orderItemsDao.getItemsByOrderId(orderId);
        final items = <OrderLineItem>[];
        for (final entity in entities) {
          items.add(await _entityToModel(entity));
        }
        return items;
      });

  @override
  Future<Result<int>> getItemsCount(int orderId) => safe(
    'getItemsCount($orderId)',
    () => _orderItemsDao.getItemsCountByOrderId(orderId),
  );

  @override
  Future<Result<int>> getTotalQuantity(int orderId) => safe(
    'getTotalQuantity($orderId)',
    () => _orderItemsDao.getTotalQuantityByOrderId(orderId),
  );

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<OrderLineItem>> addItemToOrder({
    required int orderId,
    required OrderLineItem item,
  }) => safe('addItemToOrder($orderId)', () async {
    // Insert item
    final itemId = await _orderItemsDao.insertOrderItem(
      OrderItemEntity(
        id: 0,
        orderId: orderId,
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        unitPrice: item.unitPriceCents,
        costPrice: 0, // Cost price not tracked in OrderLineItem model
        discountAmount: 0, // Discount applied at order level
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      ),
    );

    // Insert modifiers
    for (final modifier in item.selectedModifiers) {
      await _orderItemsDao.addModifierToOrderItem(
        orderItemId: itemId,
        modifierName: modifier.groupName,
        optionName: modifier.optionName,
        priceChange: modifier.priceChangeCents,
      );
    }

    // Return the item for optimistic updates
    return item;
  });

  @override
  Future<Result<OrderLineItem>> updateItemQuantity({
    required int itemId,
    required int quantity,
    required OrderLineItem item,
  }) => safe('updateItemQuantity($itemId, $quantity)', () async {
    await _orderItemsDao.updateOrderItemQuantity(itemId, quantity);
    // Return the updated item
    return item.copyWith(quantity: quantity);
  });

  @override
  Future<Result<int>> removeItem(int itemId) =>
      safe('removeItem($itemId)', () async {
        // Delete modifiers first
        await _orderItemsDao.deleteModifiersByOrderItemId(itemId);
        // Soft delete item
        await _orderItemsDao.softDeleteOrderItem(itemId);
        return itemId;
      });

  @override
  Future<Result<SelectedModifiers>> addModifierToItem({
    required int itemId,
    required SelectedModifiers modifier,
  }) => safe('addModifierToItem($itemId)', () async {
    await _orderItemsDao.addModifierToOrderItem(
      orderItemId: itemId,
      modifierName: modifier.groupName,
      optionName: modifier.optionName,
      priceChange: modifier.priceChangeCents,
    );
    return modifier;
  });

  @override
  Future<Result<int>> removeModifierFromItem(int modifierId) =>
      safe('removeModifierFromItem($modifierId)', () async {
        await _orderItemsDao.deleteOrderItemModifier(modifierId);
        return modifierId;
      });
}
