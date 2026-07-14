// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Hand-restored: drift_dev cannot resolve cross-package tables
// (`package:database`'s `OrderItemsTable`/`OrdersTable`) from this
// feature package and silently emits an empty mixin here — see memory
// `project_drift_crosspackage_codegen`. These getters mirror the ones
// `drift_dev` emits for `packages/database`-local accessors (compare
// `features/orders/lib/data/sources/local/daos/order_items_dao.g.dart`).
// Do not regenerate this file with `build_runner`; hand-edit instead.

part of 'tickets_dao.dart';

// ignore_for_file: type=lint
mixin _$TicketsDaoMixin on DatabaseAccessor<AgoraDatabase> {
  $OrderItemsTableTable get orderItemsTable => attachedDatabase.orderItemsTable;
  $OrdersTableTable get ordersTable => attachedDatabase.ordersTable;
}
