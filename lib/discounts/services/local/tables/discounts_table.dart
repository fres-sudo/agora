// Tracks current inventory level.
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:drift/drift.dart';

class DiscountsTable extends Table with TableMixin {
  TextColumn get name => text()();

  // 0 = Percentage, 1 = Fixed Amount
  IntColumn get type => integer()();
  IntColumn get value => integer()(); // e.g. 10 (for 10%) or 500 (for $5.00)

  TextColumn get code => text().nullable()(); // For manual vouchers
  DateTimeColumn get validUntil => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
