import 'package:drift/drift.dart';

import '../database_mixin.dart';

// A named, saved catalog snapshot
// (docs/features/06-season-to-season-catalog-reuse.md). One JSON blob per
// template — deliberately simple, since a sagra menu is dozens of items, not
// thousands, and this avoids a full relational snapshot schema for no real
// benefit at this scale. `createdAt` (from TableMixin) doubles as "saved at".
@DataClassName("CatalogTemplateEntity")
class CatalogTemplatesTable extends Table with TableMixin {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get snapshotJson => text()();
}
