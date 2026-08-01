import 'package:catalog/models/category.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/models/product_status.dart';
import 'package:feature_settings/domain/models/public_menu_models.dart';
import 'package:feature_settings/domain/services/public_menu_snapshot_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const builder = PublicMenuSnapshotBuilder();
  const configuration = PublicMenuConfiguration(
    title: 'Sagra di San Rocco',
    templateId: 'rustic-festival',
    templateVersion: 3,
  );

  test('exports only visible catalog items and safe public fields', () {
    final snapshot = builder.build(
      configuration: configuration,
      categories: const [
        Category(id: 1, name: 'Primi'),
        Category(id: 2, name: 'Hidden', isEnabled: false),
      ],
      products: const [
        Product(
          id: 1,
          name: 'Tagliatelle',
          description: 'Ragù di cinghiale',
          sku: 'INTERNAL-42',
          imageUrl: '/private/photo.jpg',
          categoryId: 1,
          priceCents: 800,
          costCents: 250,
          taxPercent: 10,
          stockQuantity: 7,
          prepStation: 'Griglia',
          status: ProductStatus.active,
        ),
        Product(
          id: 2,
          name: 'Draft item',
          categoryId: 1,
          priceCents: 500,
          costCents: 1,
          stockQuantity: 1,
        ),
        Product(
          id: 3,
          name: 'Disabled category item',
          categoryId: 2,
          priceCents: 500,
          costCents: 1,
          stockQuantity: 1,
          status: ProductStatus.active,
        ),
      ],
      combos: const [
        Combo(id: 1, name: 'Menu completo', priceCents: 1200),
        Combo(id: 2, name: 'Hidden combo', priceCents: 1000, isEnabled: false),
      ],
    );

    expect(snapshot.toJson(), {
      'schemaVersion': 1,
      'menu': {'title': 'Sagra di San Rocco', 'currency': 'EUR'},
      'categories': [
        {
          'name': 'Primi',
          'icon': isA<String>(),
          'items': [
            {
              'kind': 'product',
              'name': 'Tagliatelle',
              'description': 'Ragù di cinghiale',
              'priceCents': 800,
            },
          ],
        },
      ],
      'combos': [
        {'kind': 'combo', 'name': 'Menu completo', 'priceCents': 1200},
      ],
    });
  });
}
