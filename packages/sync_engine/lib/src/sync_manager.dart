import 'dart:async';

import 'package:talker/talker.dart';

import 'connectivity/connectivity_monitor.dart';
import 'model/outbox_entry.dart';
import 'model/sync_status.dart';
import 'outbox/outbox_queue.dart';
import 'sync_handler.dart';
import 'websocket/sync_web_socket.dart';

/// Orchestrates the offline-first sync loop.
///
/// Responsibilities:
///   - Monitors connectivity and suspends/resumes draining accordingly.
///   - Drains the [OutboxQueue] by dispatching each entry to the matching [SyncHandler].
///   - Maintains the managed [SyncWebSocket] for real-time inbound events.
///   - Emits [SyncStatus] so the UI (Bloc/Cubit) can react without knowing HTTP internals.
///
/// Usage:
/// ```dart
/// final manager = SyncManager(
///   outboxQueue: ctx.read(),
///   connectivity: ConnectivityMonitorImpl(),
///   webSocket: SyncWebSocket(logger: ctx.read()),
///   logger: ctx.read(),
/// );
/// manager.registerHandler(OrderSyncHandler(ctx.read()));
/// await manager.start(webSocketUrl: 'wss://api.agora.io/ws', authToken: jwt);
/// ```
class SyncManager {
  SyncManager({
    required OutboxQueue outboxQueue,
    required ConnectivityMonitor connectivity,
    required SyncWebSocket webSocket,
    required Talker logger,
  })  : _queue = outboxQueue,
        _connectivity = connectivity,
        _webSocket = webSocket,
        _logger = logger;

  final OutboxQueue _queue;
  final ConnectivityMonitor _connectivity;
  final SyncWebSocket _webSocket;
  final Talker _logger;

  final Map<String, SyncHandler> _handlers = {};

  final _statusController = StreamController<SyncStatus>.broadcast();
  StreamSubscription<bool>? _connectivitySub;
  Timer? _periodicTimer;

  bool _isOnline = false;
  bool _draining = false;

  static const _maxRetries = 5;
  static const _drainInterval = Duration(seconds: 30);

  // ------------------------------------------------------------------ public

  /// Emits sync state changes; safe to listen to before [start] is called.
  Stream<SyncStatus> get status => _statusController.stream;

  /// Emits inbound real-time messages from the backend.
  Stream<dynamic> get inboundMessages => _webSocket.messages;

  /// Register a handler for a specific entity type.
  /// Call before [start].
  void registerHandler(SyncHandler handler) {
    _handlers[handler.entityType] = handler;
  }

  /// Begin monitoring connectivity and draining the outbox.
  ///
  /// Optionally connects the WebSocket for real-time inbound events.
  Future<void> start({String? webSocketUrl, String? authToken}) async {
    _isOnline = await _connectivity.currentStatus;

    _connectivitySub = _connectivity.isOnline.listen((online) async {
      final wasOffline = !_isOnline;
      _isOnline = online;

      if (online) {
        _logger.info('[SyncManager] online — starting drain');
        if (webSocketUrl != null && authToken != null) {
          await _webSocket.connect(webSocketUrl, authToken);
        }
        if (wasOffline) await _drain();
      } else {
        _logger.info('[SyncManager] offline — pausing sync');
        _statusController.add(const SyncPaused());
        await _webSocket.disconnect();
      }
    });

    if (_isOnline) {
      if (webSocketUrl != null && authToken != null) {
        await _webSocket.connect(webSocketUrl, authToken);
      }
      await _drain();
    } else {
      _statusController.add(const SyncPaused());
    }

    _periodicTimer = Timer.periodic(_drainInterval, (_) {
      if (_isOnline && !_draining) _drain();
    });
  }

  /// Graceful shutdown — cancels timers and closes the WebSocket.
  Future<void> stop() async {
    _periodicTimer?.cancel();
    await _connectivitySub?.cancel();
    await _webSocket.disconnect();
    await _statusController.close();
  }

  /// Enqueue a mutation and trigger an immediate drain if online.
  Future<void> enqueue({
    required String entityType,
    required OutboxOperation operation,
    required String entityLocalId,
    required Map<String, dynamic> payload,
    String? remoteId,
  }) async {
    await _queue.enqueue(
      entityType: entityType,
      operation: operation,
      entityLocalId: entityLocalId,
      payload: payload,
      remoteId: remoteId,
    );

    if (_isOnline && !_draining) {
      _drain(); // fire-and-forget; errors are caught inside
    }
  }

  /// Subscribe the WebSocket to a topic (e.g. `order:loc123`).
  void subscribe(String topic) => _webSocket.subscribe(topic);

  /// Unsubscribe from a WebSocket topic.
  void unsubscribe(String topic) => _webSocket.unsubscribe(topic);

  // ------------------------------------------------------------------ drain

  // ignore: avoid-returning-void-in-future — intentional fire-and-forget entry point
  Future<void> _drain() async {
    if (_draining) return;
    _draining = true;

    try {
      final entries = await _queue.pendingEntries();

      if (entries.isEmpty) {
        _statusController.add(const SyncIdle());
        return;
      }

      _statusController.add(SyncInProgress(entries.length));

      for (final entry in entries) {
        if (!_isOnline) break;

        final handler = _handlers[entry.entityType];
        if (handler == null) {
          _logger.warning(
            '[SyncManager] no handler for entity type "${entry.entityType}" — marking failed',
          );
          await _queue.markFailed(
            entry.id,
            'No handler registered for "${entry.entityType}"',
            entry.retryCount,
          );
          continue;
        }

        await _queue.markInflight(entry.id);

        try {
          await handler.handle(entry);
          await _queue.markDone(entry.id);
          _logger.info(
            '[SyncManager] synced ${entry.entityType}#${entry.entityLocalId}',
          );
        } catch (e, st) {
          final reason = e.toString();
          _logger.error(
            '[SyncManager] failed ${entry.entityType}#${entry.entityLocalId}: $reason',
            e,
            st,
          );
          await _queue.markFailed(entry.id, reason, entry.retryCount);

          if (entry.retryCount + 1 >= _maxRetries) {
            _statusController.add(
              SyncFailed(
                'Max retries reached for ${entry.entityType}#${entry.entityLocalId}',
              ),
            );
          }
        }
      }

      // Re-check remaining after the loop (some may have been added concurrently).
      final remaining = await _queue.pendingEntries();
      _statusController.add(
        remaining.isEmpty ? const SyncIdle() : SyncInProgress(remaining.length),
      );
    } finally {
      _draining = false;
    }
  }
}
