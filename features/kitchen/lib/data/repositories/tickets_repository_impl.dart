import 'package:feature_kitchen/data/sources/local/daos/tickets_dao.dart';
import 'package:kitchen/kitchen.dart';
import 'package:result/result.dart';
import 'package:sync_engine/sync_engine.dart';

class TicketsRepositoryImpl extends SyncableRepository
    implements TicketsRepository {
  TicketsRepositoryImpl({
    required TicketsDao ticketsDao,
    required super.syncManager,
    required this.deviceId,
    super.logger,
  }) : _ticketsDao = ticketsDao;

  final TicketsDao _ticketsDao;
  final DeviceId deviceId;

  @override
  Stream<List<Ticket>> watchTicketsForStation(String station) {
    return _ticketsDao
        .watchOpenTicketRows(station)
        .map(_rowsToTickets)
        .safeCode(logger);
  }

  List<Ticket> _rowsToTickets(List<TicketRow> rows) {
    final byOrderId = <int, List<TicketRow>>{};
    for (final row in rows) {
      (byOrderId[row.orderId] ??= []).add(row);
    }

    return byOrderId.entries.map((entry) {
      final orderRows = entry.value;
      final first = orderRows.first;
      return Ticket(
        orderId: entry.key,
        orderSyncId: first.orderSyncId,
        orderNumber: entry.key.toString(),
        station: first.prepStation,
        createdAt: first.orderCreatedAt,
        status: TicketStatus.values[first.ticketStatus],
        items: orderRows
            .map(
              (row) => TicketItem(
                orderItemId: row.orderItemId,
                productName: row.productName,
                quantity: row.quantity,
              ),
            )
            .toList(),
      );
    }).toList();
  }

  @override
  Future<Result<void>> advanceTicket({
    required int orderId,
    required String station,
    required TicketStatus newStatus,
  }) async {
    final orderSyncId = await _ticketsDao.getOrderSyncId(orderId);

    // An order that never synced (legacy/unpaired station) has nothing to
    // reconcile against on other stations — mirrors
    // OrdersRepositoryImpl.voidOrder's no-syncId guard.
    if (orderSyncId == null) {
      return safe(
        'advanceTicket($orderId, $station)',
        () => _ticketsDao.advanceTicket(orderId, station, newStatus.index),
      );
    }

    return safeSync<void>(
      operation: 'advanceTicket($orderId, $station)',
      entityType: 'ticket_status',
      outboxOperation: OutboxOperation.update,
      entityLocalId: '$orderSyncId:$station',
      payload: {
        'orderSyncId': orderSyncId,
        'originDeviceId': deviceId.value,
        'station': station,
        'status': newStatus.index,
      },
      localWrite: () =>
          _ticketsDao.advanceTicket(orderId, station, newStatus.index),
    );
  }
}
