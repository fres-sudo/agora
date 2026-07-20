import 'package:catalog/models/category.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/product.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'catalog_snapshot.freezed.dart';
part 'catalog_snapshot.g.dart';

/// The serialized shape of a saved catalog template
/// (docs/features/06-season-to-season-catalog-reuse.md).
///
/// This is a snapshot, not a live relational schema: every id in
/// [categories]/[modifierGroups]/[products]/[combos] is whatever id it had
/// in the catalog at save time, kept only so the restore step can resolve
/// the references between them (e.g. a product's `categoryId`, a combo
/// item's `productId`) — restoring always inserts fresh rows with new ids,
/// never reuses these.
@freezed
abstract class CatalogSnapshot with _$CatalogSnapshot {
  const factory CatalogSnapshot({
    @Default([]) List<Category> categories,
    @Default([]) List<ModifierGroup> modifierGroups,
    @Default([]) List<Product> products,
    @Default([]) List<Combo> combos,
  }) = _CatalogSnapshot;

  factory CatalogSnapshot.fromJson(Map<String, dynamic> json) =>
      _$CatalogSnapshotFromJson(json);

  const CatalogSnapshot._();
}
