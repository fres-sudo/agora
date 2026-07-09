import 'package:flutter_test/flutter_test.dart';
import 'package:sync_engine/sync_engine.dart';

void main() {
  group('RetryBackoff.delayFor', () {
    test('has no delay before the first failure', () {
      expect(RetryBackoff.delayFor(0), Duration.zero);
    });

    test('doubles the base delay with every recorded failure', () {
      expect(RetryBackoff.delayFor(1), const Duration(seconds: 30));
      expect(RetryBackoff.delayFor(2), const Duration(seconds: 60));
      expect(RetryBackoff.delayFor(3), const Duration(seconds: 120));
      expect(RetryBackoff.delayFor(4), const Duration(seconds: 240));
    });

    test('caps the delay at maxDelay for large retry counts', () {
      final delay = RetryBackoff.delayFor(20);
      expect(delay, RetryBackoff.maxDelay);
    });
  });

  group('RetryBackoff.isReady', () {
    test('is always ready when never attempted', () {
      final ready = RetryBackoff.isReady(
        retryCount: 0,
        lastAttemptAt: null,
        now: DateTime(2026, 1, 1),
      );
      expect(ready, isTrue);
    });

    test('is not ready before the backoff window elapses', () {
      final lastAttempt = DateTime(2026, 1, 1, 12);
      final ready = RetryBackoff.isReady(
        retryCount: 2, // 60s backoff
        lastAttemptAt: lastAttempt,
        now: lastAttempt.add(const Duration(seconds: 59)),
      );
      expect(ready, isFalse);
    });

    test('is ready once the backoff window elapses', () {
      final lastAttempt = DateTime(2026, 1, 1, 12);
      final ready = RetryBackoff.isReady(
        retryCount: 2, // 60s backoff
        lastAttemptAt: lastAttempt,
        now: lastAttempt.add(const Duration(seconds: 60)),
      );
      expect(ready, isTrue);
    });

    test('later retries wait progressively longer', () {
      final lastAttempt = DateTime(2026, 1, 1, 12);
      final justAfterFirstDelay = lastAttempt.add(const Duration(seconds: 31));

      // Ready to retry after failure #1 (30s window).
      expect(
        RetryBackoff.isReady(
          retryCount: 1,
          lastAttemptAt: lastAttempt,
          now: justAfterFirstDelay,
        ),
        isTrue,
      );

      // Not yet ready to retry after failure #3 (120s window).
      expect(
        RetryBackoff.isReady(
          retryCount: 3,
          lastAttemptAt: lastAttempt,
          now: justAfterFirstDelay,
        ),
        isFalse,
      );
    });
  });
}
