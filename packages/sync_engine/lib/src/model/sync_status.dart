sealed class SyncStatus {
  const SyncStatus();
}

/// No pending operations; sync is up-to-date.
final class SyncIdle extends SyncStatus {
  const SyncIdle();
}

/// Actively pushing entries from the outbox.
final class SyncInProgress extends SyncStatus {
  const SyncInProgress(this.pendingCount);

  final int pendingCount;
}

/// Device is offline; sync is suspended.
final class SyncPaused extends SyncStatus {
  const SyncPaused();
}

/// One or more entries have exhausted their retries.
final class SyncFailed extends SyncStatus {
  const SyncFailed(this.reason);

  final String reason;
}
