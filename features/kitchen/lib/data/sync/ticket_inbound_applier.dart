import 'package:feature_kitchen/data/sources/local/daos/tickets_dao.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// Applies a `tickets`-topic broadcast to the local `AgoraDatabase`,
/// bypassing `SyncableRepository.safeSync` entirely — same reasoning as
/// `OrderInboundApplier`/`StockInboundApplier`: an applied broadcast must
/// never re-enter this station's own outbox.
///
/// Unlike orders/stock, no redelivery dedup is needed: setting
/// `ticketStatus` to the same value twice is naturally idempotent (it's a
/// `SET`, not an accumulating delta), so last-write-wins is safe on its
/// own — acceptable per the doc's explicit "no full KDS" scope
/// (docs/features/02-kitchen-ticket-routing.md).
///
/// Also the apply logic behind `TicketApplyHandler`, used by the host's
/// `HubServer` for exactly the same reason: whether a write originated
/// locally or from a peer, "apply this status to the database" is one
/// piece of logic, not two.
class TicketInboundApplier {
  TicketInboundApplier({required TicketsDao ticketsDao, required Talker logger})
    : _ticketsDao = ticketsDao,
      _logger = logger;

  final TicketsDao _ticketsDao;
  final Talker _logger;

  Future<void> apply(SyncMessage message) async {
    if (message.event != 'ticket.status_changed') {
      _logger.warning(
        '[TicketInboundApplier] unknown event "${message.event}"',
      );
      return;
    }

    final orderSyncId = message.data['orderSyncId'] as String?;
    final station = message.data['station'] as String?;
    final status = message.data['status'] as int?;
    if (orderSyncId == null || station == null || status == null) {
      _logger.warning(
        '[TicketInboundApplier] message missing orderSyncId/station/status — dropping',
      );
      return;
    }

    final orderId = await _ticketsDao.getOrderIdBySyncId(orderSyncId);
    if (orderId == null) {
      // This station never received the order that ticket belongs to
      // (narrow cross-station race, or it isn't paired with that stand at
      // all) — accepted v1 risk, same as OrderInboundApplier's void case.
      _logger.warning(
        '[TicketInboundApplier] status change for unknown orderSyncId=$orderSyncId — dropping',
      );
      return;
    }

    await _ticketsDao.advanceTicket(orderId, station, status);
  }
}
