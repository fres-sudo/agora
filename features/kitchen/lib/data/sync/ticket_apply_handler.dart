import 'package:feature_kitchen/data/sources/local/daos/tickets_dao.dart';
import 'package:feature_kitchen/data/sync/ticket_inbound_applier.dart';
import 'package:lan_hub/lan_hub.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// The host-side counterpart of [TicketInboundApplier] — registered into
/// `HubServer.applyHandlers['tickets']` (in the app shell, see
/// `apps/agora/lib/app/sync_feature.dart`) so a `publish` frame from any
/// paired station gets applied to the host's own database exactly the same
/// way an inbound broadcast would be.
class TicketApplyHandler implements HubApplyHandler {
  TicketApplyHandler({required TicketsDao ticketsDao, required Talker logger})
    : _applier = TicketInboundApplier(ticketsDao: ticketsDao, logger: logger);

  final TicketInboundApplier _applier;

  @override
  String get topic => 'tickets';

  @override
  Future<Map<String, dynamic>> apply({
    required String originDeviceId,
    required String event,
    required Map<String, dynamic> data,
  }) async {
    await _applier.apply(
      SyncMessage(topic: 'tickets', event: event, data: data),
    );
    return data;
  }
}
