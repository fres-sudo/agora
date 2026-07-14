import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'tickets_dao.g.dart';

/// One joined `order_items` x `orders` row, grouped client-side (in
/// [TicketsRepositoryImpl]) into a [Ticket] per (orderId, prepStation).
class TicketRow {
  TicketRow({
    required this.orderId,
    required this.orderSyncId,
    required this.orderCreatedAt,
    required this.orderItemId,
    required this.productName,
    required this.quantity,
    required this.prepStation,
    required this.ticketStatus,
  });

  final int orderId;
  final String? orderSyncId;
  final DateTime orderCreatedAt;
  final int orderItemId;
  final String productName;
  final int quantity;
  final String prepStation;
  final int ticketStatus;
}

/// Kitchen tickets are derived from `OrderItemsTable` at read time (grouped
/// by order + prep station) rather than a separate tickets table — avoids a
/// second source of truth for what was ordered
/// (docs/features/02-kitchen-ticket-routing.md). Declares its own accessor
/// directly on the shared `OrdersTable`/`OrderItemsTable` rather than
/// depending on `feature_orders`' DAOs, keeping `features ↛ features`.
@DriftAccessor(tables: [OrderItemsTable, OrdersTable])
class TicketsDao extends DatabaseAccessor<AgoraDatabase>
    with _$TicketsDaoMixin {
  TicketsDao(super.db);

  // Mirrors OrdersDao's private status constants (features/orders) — not
  // shared centrally because these are plain int columns, not an enum
  // known to the database layer.
  static const int _statusVoided = 2;

  /// Watches every non-bumped ticket item routed to [station], oldest order
  /// first. A "ticket" (all items sharing one order + station) is bumped as
  /// one unit, so filtering out bumped items here is equivalent to
  /// filtering out bumped tickets.
  Stream<List<TicketRow>> watchOpenTicketRows(String station) {
    final query =
        select(orderItemsTable).join([
            innerJoin(
              ordersTable,
              ordersTable.id.equalsExp(orderItemsTable.orderId),
            ),
          ])
          ..where(
            orderItemsTable.deletedAt.isNull() &
                orderItemsTable.prepStation.equals(station) &
                orderItemsTable.ticketStatus.equals(3).not() &
                ordersTable.deletedAt.isNull() &
                ordersTable.status.equals(_statusVoided).not(),
          )
          ..orderBy([OrderingTerm.asc(ordersTable.createdAt)]);

    return query.watch().map(
      (rows) => rows.map((row) {
        final item = row.readTable(orderItemsTable);
        final order = row.readTable(ordersTable);
        return TicketRow(
          orderId: order.id,
          orderSyncId: order.syncId,
          orderCreatedAt: order.createdAt,
          orderItemId: item.id,
          productName: item.productName,
          quantity: item.quantity,
          prepStation: item.prepStation!,
          ticketStatus: item.ticketStatus,
        );
      }).toList(),
    );
  }

  /// Advances every item of the ticket for [orderId]/[station] to
  /// [newStatus] in one bulk update.
  Future<void> advanceTicket(int orderId, String station, int newStatus) {
    return (update(orderItemsTable)..where(
          (t) =>
              t.orderId.equals(orderId) &
              t.prepStation.equals(station) &
              t.deletedAt.isNull(),
        ))
        .write(OrderItemsTableCompanion(ticketStatus: Value(newStatus)));
  }

  /// Resolves a local order id from its LAN-sync id, for applying an
  /// inbound `ticket.status_changed` broadcast. Returns null if this
  /// station never received the order that ticket belongs to.
  Future<int?> getOrderIdBySyncId(String syncId) async {
    final row = await (select(
      ordersTable,
    )..where((t) => t.syncId.equals(syncId))).getSingleOrNull();
    return row?.id;
  }

  /// Resolves the LAN-sync id of the order that owns [orderId], for
  /// publishing an outbound `ticket.status_changed` event. Returns null for
  /// an order that never synced (legacy/unpaired) — same reasoning as
  /// `OrdersRepositoryImpl.voidOrder`'s no-syncId guard.
  Future<String?> getOrderSyncId(int orderId) async {
    final row = await (select(
      ordersTable,
    )..where((t) => t.id.equals(orderId))).getSingleOrNull();
    return row?.syncId;
  }
}
