// `Color` here is a persisted data value (a user-chosen category color stored
// as an int), not a theme token — the design-system color rule does not apply.
// ignore_for_file: avoid_hardcoded_colors
import 'dart:ui';
import 'package:drift/drift.dart';

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.toARGB32();
}
