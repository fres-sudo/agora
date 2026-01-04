import 'package:agora/core/mixins/database_mixin.dart';
import 'package:drift/drift.dart';

@DataClassName("OrderEntity")
class OrdersTable extends Table with TableMixin {
  // Status: 0=Pending, 1=Completed, 2=Voided/Refunded
  IntColumn get status => integer().withDefault(const Constant(0))();

  IntColumn get subtotal => integer()();
  IntColumn get discountTotal => integer().withDefault(const Constant(0))();
  IntColumn get taxTotal => integer().withDefault(const Constant(0))();
  IntColumn get grandTotal => integer()();

  TextColumn get paymentMethod => text().nullable()(); // "Cash", "Card", etc.
  TextColumn get note => text().nullable()();
}
