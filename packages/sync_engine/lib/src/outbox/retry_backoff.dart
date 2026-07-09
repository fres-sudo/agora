/// Computes the exponential backoff delay applied between retry attempts
/// for failed outbox entries (see `OutboxTable`).
///
/// Per `SyncHandler.handle`'s contract, a thrown error marks the entry as
/// failed and "schedules a retry with exponential backoff" — this is where
/// that schedule is defined and evaluated.
///
/// The delay doubles with every failed attempt, starting at [baseDelay] and
/// capped at [maxDelay]:
///   retryCount=1 -> 30s
///   retryCount=2 -> 1m
///   retryCount=3 -> 2m
///   retryCount=4 -> 4m
class RetryBackoff {
  const RetryBackoff._();

  /// Delay before the first retry (i.e. after a single failure).
  static const Duration baseDelay = Duration(seconds: 30);

  /// Upper bound on the computed delay, regardless of [retryCount].
  static const Duration maxDelay = Duration(minutes: 30);

  /// The delay to wait, after the [retryCount]-th recorded failure, before
  /// the entry is eligible to be retried again.
  ///
  /// A [retryCount] of 0 (never attempted, or freshly enqueued) has no
  /// delay — it's eligible immediately.
  static Duration delayFor(int retryCount) {
    if (retryCount <= 0) return Duration.zero;

    // Cap the exponent so the shift can't overflow for pathological inputs;
    // real callers never see retryCount anywhere near this since entries
    // stop being retried once they hit the max-retries cap.
    final exponent = (retryCount - 1).clamp(0, 20);
    final scaled = baseDelay * (1 << exponent);
    return scaled > maxDelay ? maxDelay : scaled;
  }

  /// Whether an entry that has failed [retryCount] times, last attempted at
  /// [lastAttemptAt], is now eligible to be retried.
  ///
  /// Entries that have never been attempted ([lastAttemptAt] is null) are
  /// always ready.
  static bool isReady({
    required int retryCount,
    required DateTime? lastAttemptAt,
    DateTime? now,
  }) {
    if (lastAttemptAt == null) return true;
    final effectiveNow = now ?? DateTime.now();
    return !effectiveNow.isBefore(lastAttemptAt.add(delayFor(retryCount)));
  }
}
