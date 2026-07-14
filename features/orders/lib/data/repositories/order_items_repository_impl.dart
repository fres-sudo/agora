import 'package:database/database.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/models/selected_modifiers.dart';
import 'package:feature_orders/domain/repositories/order_items_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

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
      id: entity.id,
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
      prepStation: entity.prepStation,
    );
  }

  OrderItemsTableCompanion _itemToInsertCompanion(
    int orderId,
    OrderLineItem item,
  ) {
    return OrderItemsTableCompanion.insert(
      orderId: orderId,
      productId: Value(item.productId),
      productName: item.productName,
      unitPrice: item.unitPriceCents,
      costPrice: 0, // Cost price not tracked in OrderLineItem model
      quantity: Value(item.quantity),
      discountAmount: Value(0), // Discount applied at order level
      prepStation: Value(item.prepStation),
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
      _itemToInsertCompanion(orderId, item),
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
