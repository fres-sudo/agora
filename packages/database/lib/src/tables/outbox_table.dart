import 'package:drift/drift.dart';

// Pending operations waiting to be synced to the backend.
// Entries are deleted on success; they accumulate only while offline or on failure.
@DataClassName('OutboxEntity')
class OutboxTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 'create' | 'update' | 'delete'
  TextColumn get operationType => text()();

  // Logical entity name, e.g. 'order', 'order_item'
  TextColumn get entityType => text()();

  // Local Drift row id (as string for generality)
  TextColumn get entityLocalId => text()();

  // Backend UUID — null until first successful sync
  TextColumn get remoteId => text().nullable()();

  // JSON-encoded mutation payload
  TextColumn get payload => text()();

  // 'pending' | 'inflight' | 'failed'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  TextColumn get failedReason => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get processedAt => dateTime().nullable()();
}
