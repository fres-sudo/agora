import 'dart:async';

import 'package:feature_inventory/data/sync/stock_inbound_applier.dart';
import 'package:feature_kitchen/data/sync/ticket_inbound_applier.dart';
import 'package:feature_orders/data/sync/order_inbound_applier.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// Listens to `SyncManager.inboundMessages` and dispatches each broadcast
/// to the applier for its topic. Lives in the app shell (not a feature)
/// because it needs appliers from `feature_orders`, `feature_inventory`
/// and `feature_kitchen` — a fourth `features/` package importing all
/// three would violate the `features ↛ features` rule.
///
/// Safe to start unconditionally at app boot regardless of this station's
/// sync role: `subscribe()` on an unconnected `SyncWebSocket` is a no-op
/// that just registers the topic for whenever a connection is later made
/// (see Settings' Sync section), and `inboundMessages` never emits without
/// one. A standalone station therefore behaves identically to before this
/// feature existed.
class SyncBootstrap {
  SyncBootstrap({
    required SyncManager syncManager,
    required OrderInboundApplier orderApplier,
    required StockInboundApplier stockApplier,
    required TicketInboundApplier ticketApplier,
    required Talker logger,
  }) : _syncManager = syncManager,
       _orderApplier = orderApplier,
       _stockApplier = stockApplier,
       _ticketApplier = ticketApplier,
       _logger = logger;

  final SyncManager _syncManager;
  final OrderInboundApplier _orderApplier;
  final StockInboundApplier _stockApplier;
  final TicketInboundApplier _ticketApplier;
  final Talker _logger;

  StreamSubscription<SyncMessage>? _sub;

  void start() {
    _sub ??= _syncManager.inboundMessages.listen((message) async {
      try {
        switch (message.topic) {
          case 'orders':
            await _orderApplier.apply(message);
          case 'stock':
            await _stockApplier.apply(message);
          case 'tickets':
            await _ticketApplier.apply(message);
          default:
            _logger.warning('[SyncBootstrap] unknown topic "${message.topic}"');
        }
      } catch (e, st) {
        _logger.error(
          '[SyncBootstrap] failed applying inbound ${message.topic}/${message.event}',
          e,
          st,
        );
      }
    });
    _syncManager.subscribe('orders');
    _syncManager.subscribe('stock');
    _syncManager.subscribe('tickets');
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }
}
