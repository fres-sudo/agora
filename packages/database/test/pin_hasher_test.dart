import 'package:bcrypt/bcrypt.dart';
import 'package:database/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PinHasher', () {
    test('accepts only 4-6 numeric digits for new hashes', () {
      expect(() => PinHasher.hash('123'), throwsArgumentError);
      expect(() => PinHasher.hash('1234567'), throwsArgumentError);
      expect(() => PinHasher.hash('12ab'), throwsArgumentError);
      expect(PinHasher.verify('1234', PinHasher.hash('1234')), isTrue);
    });

    test('does not classify a malformed bcrypt-like value as a hash', () {
      expect(PinHasher.looksHashed(r'$2b$10$not-a-valid-bcrypt-hash'), isFalse);
      expect(
        PinHasher.looksHashed(
          r'$2a$99$.....................................................',
        ),
        isFalse,
      );
    });

    test('marks lower-cost bcrypt hashes for a transparent upgrade', () {
      final oldHash = BCrypt.hashpw('1234', BCrypt.gensalt(logRounds: 10));
      final currentHash = PinHasher.hash('1234');

      expect(PinHasher.needsRehash(oldHash), isTrue);
      expect(PinHasher.needsRehash(currentHash), isFalse);
    });
  });
}
