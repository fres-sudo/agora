import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:talker/talker.dart';

import 'hub_advertiser.dart';

/// A hub found on the LAN, resolved to a connectable address.
typedef HubCandidate = ({String name, String host, int port});

/// Discovers hubs advertised by [HubAdvertiser] on the LAN via mDNS/Bonjour.
///
/// Purely a convenience layer over manual `host:port` entry (see
/// `HubPairingClient`) — never the only way to pair, per
/// docs/features/01-lan-sync.md's explicit recommendation to keep manual
/// entry as a permanent fallback.
class HubDiscovery {
  HubDiscovery({required Talker logger}) : _logger = logger;

  final Talker _logger;

  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _sub;
  final _candidatesController =
      StreamController<List<HubCandidate>>.broadcast();
  final Map<String, HubCandidate> _resolved = {};

  /// Starts discovery (if not already running) and returns a stream of the
  /// current candidate list, updated as hubs are found/resolved/lost.
  Stream<List<HubCandidate>> discover() {
    unawaited(_ensureStarted());
    return _candidatesController.stream;
  }

  Future<void> _ensureStarted() async {
    if (_discovery != null) return;

    final discovery = BonsoirDiscovery(type: HubAdvertiser.serviceType);
    await discovery.ready;

    _sub = discovery.eventStream?.listen(
      _handleEvent,
      onError: (Object e) => _logger.error('[HubDiscovery] error: $e'),
    );

    await discovery.start();
    _discovery = discovery;
    _logger.info('[HubDiscovery] discovery started');
  }

  void _handleEvent(BonsoirDiscoveryEvent event) {
    switch (event.type) {
      case BonsoirDiscoveryEventType.discoveryServiceFound:
        // Found but not yet resolved to a host/port — resolve it so it
        // becomes connectable.
        event.service?.resolve(_discovery!.serviceResolver);
      case BonsoirDiscoveryEventType.discoveryServiceResolved:
        final service = event.service;
        if (service is ResolvedBonsoirService && service.host != null) {
          _resolved[service.name] = (
            name: service.name,
            host: service.host!,
            port: service.port,
          );
          _emit();
        }
      case BonsoirDiscoveryEventType.discoveryServiceLost:
        final name = event.service?.name;
        if (name != null) {
          _resolved.remove(name);
          _emit();
        }
      default:
        break;
    }
  }

  void _emit() {
    if (!_candidatesController.isClosed) {
      _candidatesController.add(_resolved.values.toList());
    }
  }

  Future<void> stopDiscovery() async {
    await _sub?.cancel();
    _sub = null;
    await _discovery?.stop();
    _discovery = null;
    _resolved.clear();
    _logger.info('[HubDiscovery] discovery stopped');
  }
}
