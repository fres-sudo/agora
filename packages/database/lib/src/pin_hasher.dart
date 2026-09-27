import 'package:bcrypt/bcrypt.dart';

/// Hashes and verifies short numeric employee PINs.
///
/// PINs are 4-6 digits, i.e. a keyspace of at most 10^6 values, so a fast
/// digest (sha256/md5, even salted) would be brute-forceable offline in
/// well under a second. bcrypt's tunable work factor makes that
/// materially slower while staying practical for interactive POS login.
///
/// A PIN is never stored or compared as plaintext outside of this class:
/// callers hash on write and verify on read.
abstract final class PinHasher {
  /// Work factor for [BCrypt.gensalt]. Existing lower-cost hashes are
  /// transparently upgraded after a successful login.
  static const int _logRounds = 12;

  /// Bcrypt hashes always start with one of these version prefixes,
  /// followed by a two-digit cost and a 22-char base64 salt.
  static const int _saltLength = 29;

  static final RegExp _pinPattern = RegExp(r'^\d{4,6}$');
  static final RegExp _bcryptPattern = RegExp(
    r'^\$2[abxy]\$(\d{2})\$[./A-Za-z0-9]{53}$',
  );

  /// Whether [pin] is a valid employee PIN at the trust boundary.
  static bool isValid(String pin) => _pinPattern.hasMatch(pin);

  /// Returns a salted bcrypt hash of [pin]. Store the result in place of
  /// the raw PIN.
  static String hash(String pin) {
    if (!isValid(pin)) {
      throw ArgumentError.value(pin, 'pin', 'must be 4-6 numeric digits');
    }
    return BCrypt.hashpw(pin, BCrypt.gensalt(logRounds: _logRounds));
  }

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

  /// Validates the complete shape and work-factor range of a bcrypt hash.
  /// Used to distinguish upgraded rows from legacy plaintext PINs during
  /// the lazy migration on login.
  static bool looksHashed(String value) {
    final match = _bcryptPattern.firstMatch(value);
    if (match == null) return false;
    final rounds = int.tryParse(match.group(1)!);
    return rounds != null && rounds >= 4 && rounds <= 31;
  }

  /// Existing hashes are upgraded after the next successful login. This
  /// raises the work factor without a destructive data migration.
  static bool needsRehash(String value) {
    if (!looksHashed(value)) return false;
    final match = _bcryptPattern.firstMatch(value)!;
    final rounds = int.tryParse(match.group(1)!);
    return rounds != null && rounds < _logRounds;
  }

  /// Constant-time string comparison so a login attempt doesn't leak how
  /// many leading characters/digits matched via response timing.
  static bool constantTimeEquals(String a, String b) {
    final maxLength = a.length > b.length ? a.length : b.length;
    var diff = a.length ^ b.length;
    for (var i = 0; i < maxLength; i++) {
      final aUnit = i < a.length ? a.codeUnitAt(i) : 0;
      final bUnit = i < b.length ? b.codeUnitAt(i) : 0;
      diff |= aUnit ^ bUnit;
    }
    return diff == 0;
  }
}
