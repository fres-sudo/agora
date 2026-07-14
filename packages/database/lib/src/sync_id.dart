import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A client-generated identity for an entity that can be shared across
/// stations over LAN sync — distinct from the station-local Drift
/// autoincrement `id`, which is never safe to compare across devices.
String generateSyncId() => _uuid.v4();
