import 'package:catalog/models/catalog_snapshot.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'catalog_template.freezed.dart';

/// A named, saved catalog template
/// (docs/features/06-season-to-season-catalog-reuse.md). Stock levels are
/// deliberately not part of [snapshot] — a template is a menu/pricing
/// definition, not a stock snapshot.
@freezed
abstract class CatalogTemplate with _$CatalogTemplate {
  const factory CatalogTemplate({
    required int id,
    required String name,
    required DateTime savedAt,
    required CatalogSnapshot snapshot,
  }) = _CatalogTemplate;

  const CatalogTemplate._();
}
