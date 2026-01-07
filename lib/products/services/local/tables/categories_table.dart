import 'package:agora/core/database/color_converter.dart';
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:drift/drift.dart';

@DataClassName("CategoryEntity")
class CategoriesTable extends Table with TableMixin {
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get color =>
      integer().map(const ColorConverter())(); // Hex code for UI
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get iconCodePoint => integer().withDefault(const Constant(0))();
}
