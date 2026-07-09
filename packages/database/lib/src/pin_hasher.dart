import 'package:bcrypt/bcrypt.dart';

/// Hashes and verifies short numeric employee PINs.
///
/// PINs are 4-6 digits, i.e. a keyspace of at most 10^6 values, so a fast
/// digest (sha256/md5, even salted) would be brute-forceable offline in
/// well under a second. bcrypt's tunable work factor makes that
/// infeasible while staying fast enough for interactive POS login.
///
/// A PIN is never stored or compared as plaintext outside of this class:
/// callers hash on write and verify on read.
abstract final class PinHasher {
  /// Work factor for [BCrypt.gensalt]. Higher is slower/safer; 10 is
  /// bcrypt's own default and keeps login latency imperceptible on POS
  /// hardware while still being far too slow for bulk PIN brute-forcing.
  static const int _logRounds = 10;

  /// Bcrypt hashes always start with one of these version prefixes,
  /// followed by a two-digit cost and a 22-char base64 salt.
  static const int _saltLength = 29;

  /// Returns a salted bcrypt hash of [pin]. Store the result in place of
  /// the raw PIN.
  static String hash(String pin) =>
      BCrypt.hashpw(pin, BCrypt.gensalt(logRounds: _logRounds));

  /// Returns true if [pin] matches the previously generated [hash].
  ///
  /// Recomputes the digest with the salt embedded in [hash] and compares
  /// the two digests in constant time, rather than relying on whatever
  /// short-circuiting `==` a bcrypt implementation happens to use.
  static bool verify(String pin, String hash) {
    if (!looksHashed(hash)) return false;
    final recomputed = BCrypt.hashpw(pin, hash.substring(0, _saltLength));
    return constantTimeEquals(recomputed, hash);
  }

  /// Heuristic check for "is this value already a bcrypt hash" — used to
  /// distinguish upgraded rows from legacy plaintext PINs during the
  /// lazy migration on login.
  static bool looksHashed(String value) =>
      value.length >= _saltLength &&
      (value.startsWith(r'$2a$') ||
          value.startsWith(r'$2b$') ||
          value.startsWith(r'$2x$') ||
          value.startsWith(r'$2y$'));

  /// Constant-time string comparison so a login attempt doesn't leak how
  /// many leading characters/digits matched via response timing.
  static bool constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
