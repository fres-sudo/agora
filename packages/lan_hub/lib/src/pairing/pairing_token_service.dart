import 'package:sync_engine/sync_engine.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

typedef _Session = ({String deviceId, DateTime expiresAt});

/// Thrown when a pairing attempt is rejected — wrong PIN, or the
/// requester is currently locked out after too many failed attempts.
class PairingException implements Exception {
  PairingException(this.message);

  final String message;

  @override
  String toString() => 'PairingException: $message';
}

/// Issues short-lived session tokens to stations that present the event's
/// pairing PIN over the hub's `/pair` HTTP endpoint (see [HubServer]).
///
/// There is no persistent account model — a token is scoped to this one
/// hosting session and is discarded when hosting stops ([revokeAll]).
/// Brute-forcing a short PIN over LAN is otherwise trivial, so failed
/// attempts are tracked per [requesterKey] (typically the connecting
/// socket's remote address) and locked out with the same exponential
/// curve `sync_engine` already uses for retry backoff — reused here
/// rather than inventing a second one.
class PairingTokenService {
  PairingTokenService({
    required String Function() pinProvider,
    this.tokenTtl = const Duration(hours: 12),
    this.maxAttemptsBeforeLockout = 5,
  }) : _pinProvider = pinProvider;

  final String Function() _pinProvider;
  final Duration tokenTtl;
  final int maxAttemptsBeforeLockout;

  final Map<String, _Session> _sessions = {};
  final Map<String, int> _failedAttempts = {};
  final Map<String, DateTime> _lockedOutSince = {};

  /// Validates [suppliedPin] against the current pairing PIN and, on
  /// success, issues a fresh session token bound to [deviceId]. Throws
  /// [PairingException] on a wrong PIN or while [requesterKey] is locked
  /// out.
  ({String token, DateTime expiresAt}) issue({
    required String deviceId,
    required String suppliedPin,
    required String requesterKey,
  }) {
    final lockedSince = _lockedOutSince[requesterKey];
    if (lockedSince != null) {
      final attempts = _failedAttempts[requesterKey] ?? 0;
      final unlockAt = lockedSince.add(RetryBackoff.delayFor(attempts));
      if (DateTime.now().isBefore(unlockAt)) {
        throw PairingException(
          'Too many failed attempts — try again after $unlockAt',
        );
      }
    }

    if (suppliedPin != _pinProvider()) {
      final attempts = (_failedAttempts[requesterKey] ?? 0) + 1;
      _failedAttempts[requesterKey] = attempts;
      if (attempts >= maxAttemptsBeforeLockout) {
        _lockedOutSince[requesterKey] = DateTime.now();
      }
      throw PairingException('Invalid pairing PIN');
    }

    _failedAttempts.remove(requesterKey);
    _lockedOutSince.remove(requesterKey);

    final token = _uuid.v4();
    final expiresAt = DateTime.now().add(tokenTtl);
    _sessions[token] = (deviceId: deviceId, expiresAt: expiresAt);
    return (token: token, expiresAt: expiresAt);
  }

  /// The host connecting to its own embedded server (see
  /// `HostSessionController`) skips the PIN challenge entirely — it's
  /// already the device that set the PIN.
  String issueLoopbackToken(String deviceId) {
    final token = _uuid.v4();
    _sessions[token] = (
      deviceId: deviceId,
      expiresAt: DateTime.now().add(tokenTtl),
    );
    return token;
  }

  bool validate(String token) {
    final session = _sessions[token];
    return session != null && DateTime.now().isBefore(session.expiresAt);
  }

  /// The device identity bound to [token] at pairing time, or `null` if the
  /// token is missing/expired. Used to attribute a connection to a station
  /// without trusting a client-supplied deviceId on every frame.
  String? deviceIdForToken(String token) {
    final session = _sessions[token];
    if (session == null || !DateTime.now().isBefore(session.expiresAt)) {
      return null;
    }
    return session.deviceId;
  }

  /// Discards every issued session token and lockout state. Called when
  /// hosting stops — every paired station must re-pair on the next hub run.
  void revokeAll() {
    _sessions.clear();
    _failedAttempts.clear();
    _lockedOutSince.clear();
  }
}
