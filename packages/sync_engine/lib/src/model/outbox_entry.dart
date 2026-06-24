enum OutboxOperation {
  create,
  update,
  delete;

  static OutboxOperation fromString(String value) => switch (value) {
        'create' => OutboxOperation.create,
        'update' => OutboxOperation.update,
        'delete' => OutboxOperation.delete,
        _ => throw ArgumentError('Unknown OutboxOperation: $value'),
      };
}

enum OutboxEntryStatus {
  pending,
  inflight,
  failed;

  static OutboxEntryStatus fromString(String value) => switch (value) {
        'pending' => OutboxEntryStatus.pending,
        'inflight' => OutboxEntryStatus.inflight,
        'failed' => OutboxEntryStatus.failed,
        _ => throw ArgumentError('Unknown OutboxEntryStatus: $value'),
      };
}

class OutboxEntry {
  const OutboxEntry({
    required this.id,
    required this.operation,
    required this.entityType,
    required this.entityLocalId,
    this.remoteId,
    required this.payload,
    required this.status,
    required this.retryCount,
    this.failedReason,
    required this.createdAt,
    this.processedAt,
  });

  final int id;
  final OutboxOperation operation;
  final String entityType;
  final String entityLocalId;
  final String? remoteId;
  final Map<String, dynamic> payload;
  final OutboxEntryStatus status;
  final int retryCount;
  final String? failedReason;
  final DateTime createdAt;
  final DateTime? processedAt;
}
