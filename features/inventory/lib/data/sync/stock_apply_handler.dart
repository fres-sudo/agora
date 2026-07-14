import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_inventory/data/sync/stock_inbound_applier.dart';
import 'package:lan_hub/lan_hub.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// The host-side counterpart of [StockInboundApplier] — registered into
/// `HubServer.applyHandlers['stock']` (in the app shell, see
/// `apps/agora/lib/app/sync_feature.dart`) so a `publish` frame from any
/// paired station gets applied to the host's own database exactly the same
/// way an inbound broadcast would be.
class StockApplyHandler implements HubApplyHandler {
  StockApplyHandler({
    required StocksDao stocksDao,
    required StockMovementsDao stockMovementsDao,
    required Talker logger,
  }) : _applier = StockInboundApplier(
         stocksDao: stocksDao,
         stockMovementsDao: stockMovementsDao,
         logger: logger,
       );

  final StockInboundApplier _applier;

  @override
  String get topic => 'stock';

  @override
  Future<Map<String, dynamic>> apply({
    required String originDeviceId,
    required String event,
    required Map<String, dynamic> data,
  }) async {
    await _applier.apply(SyncMessage(topic: 'stock', event: event, data: data));
    return data;
  }
}
