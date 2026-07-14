import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// Applies a `stock`-topic broadcast to the local `AgoraDatabase`,
/// bypassing `SyncableRepository.safeSync` entirely — same reasoning as
/// `OrderInboundApplier`: an applied broadcast must never re-enter this
/// station's own outbox. Dedupes on `syncId` so redelivery (including the
/// host's own loopback broadcast of its own writes) is a safe no-op.
///
/// Also the apply logic behind `StockApplyHandler`, used by the host's
/// `HubServer` — see that class's doc comment for why sharing this logic
/// matters.
class StockInboundApplier {
  StockInboundApplier({
    required StocksDao stocksDao,
    required StockMovementsDao stockMovementsDao,
    required Talker logger,
  }) : _stocksDao = stocksDao,
       _stockMovementsDao = stockMovementsDao,
       _logger = logger;

  final StocksDao _stocksDao;
  final StockMovementsDao _stockMovementsDao;
  final Talker _logger;

  Future<void> apply(SyncMessage message) async {
    if (message.event != 'stock.adjusted') {
      _logger.warning('[StockInboundApplier] unknown event "${message.event}"');
      return;
    }

    final syncId = message.data['syncId'] as String?;
    if (syncId == null) {
      _logger.warning(
        '[StockInboundApplier] message with no syncId — dropping',
      );
      return;
    }

    if (await _stockMovementsDao.getMovementBySyncId(syncId) != null) {
      return; // Already applied — redelivery or our own loopback echo.
    }

    final productId = message.data['productId'] as int;
    final delta = message.data['delta'] as int;
    final reason = message.data['reason'] as String;

    await _stocksDao.transaction(() async {
      await _stocksDao.adjustStockQuantityAtomic(
        productId: productId,
        delta: delta,
      );
      await _stockMovementsDao.recordMovement(
        productId: productId,
        quantityChange: delta,
        reason: reason,
        syncId: syncId,
      );
    });
  }
}
