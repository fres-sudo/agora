import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'discovery/hub_advertiser.dart';
import 'hub_server.dart';
import 'pairing/pairing_token_service.dart';

/// Promotes this station to "host this event": starts the embedded
/// [HubServer], advertises it via [HubAdvertiser], and then — this is the
/// load-bearing design decision, see docs/features/01-lan-sync.md — points
/// this station's own [SyncManager] at its own hub over loopback, exactly
/// like any other paired station.
///
/// Hosting therefore implies joining yourself. There is deliberately no
/// separate "local write" code path for the host: every write goes
/// through the same `safeSync` → outbox → `SyncWebSocket.publish` →
/// `HubApplyHandler` → broadcast round trip, so the apply-to-database
/// logic is exercised identically regardless of which station a write
/// originated on. The cost is that the host's own broadcast comes back to
/// itself as an inbound message — the inbound appliers' dedupe-on-syncId
/// is what makes that a safe no-op, not an incidental detail.
class HostSessionController {
  HostSessionController({
    required HubServer hubServer,
    required HubAdvertiser hubAdvertiser,
    required SyncManager syncManager,
    required PairingTokenService pairingTokenService,
    required String deviceId,
    required Talker logger,
  }) : _hubServer = hubServer,
       _hubAdvertiser = hubAdvertiser,
       _syncManager = syncManager,
       _pairingTokenService = pairingTokenService,
       _deviceId = deviceId,
       _logger = logger;

  final HubServer _hubServer;
  final HubAdvertiser _hubAdvertiser;
  final SyncManager _syncManager;
  final PairingTokenService _pairingTokenService;
  final String _deviceId;
  final Talker _logger;

  bool _hosting = false;

  bool get isHosting => _hosting;

  Future<void> startHosting({required String stationName}) async {
    if (_hosting) return;

    final port = await _hubServer.start();
    await _hubAdvertiser.start(port: port, stationName: stationName);
    final selfToken = _pairingTokenService.issueLoopbackToken(_deviceId);

    await WakelockPlus.enable();
    await _syncManager.start(
      webSocketUrl: 'ws://127.0.0.1:$port/sync',
      authToken: selfToken,
    );

    _hosting = true;
    _logger.info(
      '[HostSessionController] hosting as "$stationName" on port $port',
    );
  }

  Future<void> stopHosting() async {
    if (!_hosting) return;

    await _syncManager.stop();
    await WakelockPlus.disable();
    await _hubAdvertiser.stop();
    await _hubServer.stop();

    _hosting = false;
    _logger.info('[HostSessionController] stopped hosting');
  }
}
