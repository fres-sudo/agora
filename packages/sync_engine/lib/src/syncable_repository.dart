import 'package:result/result.dart';
import 'package:talker/talker.dart';

import 'model/outbox_entry.dart';
import 'sync_manager.dart';

/// Base class for repositories that participate in offline-first sync.
///
/// Extends [Repository] with [safeSync], which writes locally then immediately
/// enqueues the mutation for remote delivery — all inside the standard [safe]
/// error boundary.  If the device is online [SyncManager] drains the outbox
/// right away; if not, the entry waits until connectivity is restored.
///
/// Usage:
/// ```dart
/// class OrdersRepositoryImpl extends SyncableRepository
///     implements OrdersRepository {
///   OrdersRepositoryImpl({
///     required this.dao,
///     required super.syncManager,
///     super.logger,
///   });
///
///   final OrdersDao dao;
///
///   @override
///   Future<Result<Order>> createOrder(Order order) => safeSync(
///     operation: 'create_order',
///     entityType: 'order',
///     outboxOperation: OutboxOperation.create,
///     entityLocalId: order.localId,
///     payload: order.toJson(),
///     localWrite: () async {
///       await dao.insertOrder(order.toCompanion());
///       return order;
///     },
///   );
/// }
/// ```
abstract class SyncableRepository extends Repository {
  SyncableRepository({required this.syncManager, Talker? logger})
    : super(logger);

  final SyncManager syncManager;

  /// Writes locally then enqueues the mutation for remote sync in one step.
  ///
  /// [localWrite] executes first inside a [safe] boundary.  Only on success
  /// does the entry land in the outbox, so a failed local write never
  /// produces a dangling outbox record.
  ///
  /// - [operation]: short log identifier, e.g. `'create_order'`.
  /// - [entityType]: matches a registered [SyncHandler.entityType].
  /// - [outboxOperation]: create / update / delete.
  /// - [entityLocalId]: stable local ID for deduplication.
  /// - [payload]: JSON-serialisable map sent to the backend.
  /// - [remoteId]: server-side ID if already known (e.g. on update/delete).
  Future<Result<T>> safeSync<T>({
    required String operation,
    required String entityType,
    required OutboxOperation outboxOperation,
    required String entityLocalId,
    required Map<String, dynamic> payload,
    String? remoteId,
    required Future<T> Function() localWrite,
  }) {
    return safe(operation, () async {
      final value = await localWrite();
      await syncManager.enqueue(
        entityType: entityType,
        operation: outboxOperation,
        entityLocalId: entityLocalId,
        payload: payload,
        remoteId: remoteId,
      );
      return value;
    });
  }
}
