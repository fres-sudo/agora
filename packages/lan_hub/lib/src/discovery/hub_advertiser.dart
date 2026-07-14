import 'package:bonsoir/bonsoir.dart';
import 'package:talker/talker.dart';

/// Advertises the embedded hub on the LAN via mDNS/Bonjour so paired
/// stations can find it without the organiser typing an IP address —
/// manual `host:port` entry (see `HubPairingClient`) always remains
/// available as a fallback, this is discovery-as-convenience only.
class HubAdvertiser {
  HubAdvertiser({required Talker logger}) : _logger = logger;

  final Talker _logger;

  /// Shared between [HubAdvertiser] and [HubDiscovery] so both sides agree
  /// on what they're advertising/looking for.
  static const serviceType = '_agora-sync._tcp';

  BonsoirBroadcast? _broadcast;

  Future<void> start({required int port, required String stationName}) async {
    final service = BonsoirService(
      name: stationName,
      type: serviceType,
      port: port,
    );
    final broadcast = BonsoirBroadcast(service: service);
    await broadcast.ready;
    await broadcast.start();
    _broadcast = broadcast;
    _logger.info('[HubAdvertiser] advertising "$stationName" on port $port');
  }

  Future<void> stop() async {
    await _broadcast?.stop();
    _broadcast = null;
  }
}
