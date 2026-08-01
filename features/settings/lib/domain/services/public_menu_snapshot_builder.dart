import 'package:catalog/models/category.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/models/product_status.dart';
import 'package:feature_settings/domain/models/public_menu_models.dart';

/// Converts catalog data to the narrow public-menu wire schema. No private
/// catalog field can reach the publisher unless it is explicitly added here.
class PublicMenuSnapshotBuilder {
  const PublicMenuSnapshotBuilder();

  PublicMenuSnapshot build({
    required PublicMenuConfiguration configuration,
    required List<Category> categories,
    required List<Product> products,
    required List<Combo> combos,
  }) {
    final activeProducts =
        products
            .where((product) => product.status == ProductStatus.active)
            .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    final visibleCategories =
        categories.where((category) => category.isEnabled).toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    final categoryPayload = visibleCategories
        .map((category) {
          final items = activeProducts
              .where((product) => product.categoryId == category.id)
              .map(
                (product) => <String, dynamic>{
                  'kind': 'product',
                  'name': product.name,
                  if (configuration.showDescriptions &&
                      product.description?.trim().isNotEmpty == true)
                    'description': product.description!.trim(),
                  'priceCents': product.priceCents,
                },
              )
              .toList(growable: false);
          return <String, dynamic>{
            'name': category.name,
            if (configuration.showCategoryIcons && category.icon != null)
              'icon': category.icon!.codePoint.toRadixString(16),
            'items': items,
          };
        })
        .where((category) => (category['items'] as List).isNotEmpty)
        .toList();
    final enabledCombos = combos.where((combo) => combo.isEnabled).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return PublicMenuSnapshot(
      menu: {
        'title': configuration.title.trim(),
        if (configuration.subtitle.trim().isNotEmpty)
          'subtitle': configuration.subtitle.trim(),
        'currency': 'EUR',
        if (configuration.disclaimer.trim().isNotEmpty)
          'disclaimer': configuration.disclaimer.trim(),
      },
      categories: categoryPayload,
      combos: enabledCombos
          .map(
            (combo) => <String, dynamic>{
              'kind': 'combo',
              'name': combo.name,
              'priceCents': combo.priceCents,
            },
          )
          .toList(growable: false),
    );
  }
}
