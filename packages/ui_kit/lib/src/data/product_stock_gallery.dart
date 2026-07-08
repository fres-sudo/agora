/// A single bundled stock illustration that a product can use as its photo.
class ProductStockImage {
  const ProductStockImage({
    required this.id,
    required this.label,
    required this.assetPath,
  });

  /// Stable key, persisted as `"stock:<id>"` in `Product.imageUrl`.
  final String id;

  /// Human-readable label for accessibility/tooltips.
  final String label;

  /// Path within `packages/ui_kit/assets/product_gallery/`.
  final String assetPath;
}

/// The curated set of stock illustrations offered when picking a product photo.
const kProductStockGallery = <ProductStockImage>[
  ProductStockImage(
    id: 'burger',
    label: 'Burger',
    assetPath: 'assets/product_gallery/burger.svg',
  ),
  ProductStockImage(
    id: 'cake',
    label: 'Cake',
    assetPath: 'assets/product_gallery/cake.svg',
  ),
  ProductStockImage(
    id: 'chicken',
    label: 'Chicken',
    assetPath: 'assets/product_gallery/chicken.svg',
  ),
  ProductStockImage(
    id: 'coffee',
    label: 'Coffee',
    assetPath: 'assets/product_gallery/coffee.svg',
  ),
  ProductStockImage(
    id: 'drink',
    label: 'Drink',
    assetPath: 'assets/product_gallery/drink.svg',
  ),
  ProductStockImage(
    id: 'ice_cream',
    label: 'Ice Cream',
    assetPath: 'assets/product_gallery/ice_cream.svg',
  ),
  ProductStockImage(
    id: 'glass',
    label: 'Glass',
    assetPath: 'assets/product_gallery/glass.svg',
  ),
  ProductStockImage(
    id: 'spoon_fork',
    label: 'Spoon & Fork',
    assetPath: 'assets/product_gallery/spoon_fork.svg',
  ),
];

/// The `"stock:"` prefix used to encode a stock pick inside `imageUrl`.
const kProductStockImagePrefix = 'stock:';

/// Looks up a stock image by its [id] (without the `"stock:"` prefix).
ProductStockImage? resolveProductStockImage(String id) {
  for (final image in kProductStockGallery) {
    if (image.id == id) return image;
  }
  return null;
}
