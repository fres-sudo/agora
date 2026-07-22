import 'package:flutter/widgets.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';

/// The visual treatments available for a product icon in the Agora icon font.
enum ProductIconType {
  outline('Outline'),
  bulk('Bulk'),
  solid('Solid'),
  twotone('Two-tone');

  const ProductIconType(this.label);

  final String label;
}

/// A product-relevant icon from the bundled [AgoraIcons] set.
class ProductIcon {
  const ProductIcon({
    required this.label,
    required this.outline,
    required this.bulk,
    required this.solid,
    required this.twotone,
  });

  final String label;
  final IconData outline;
  final IconData bulk;
  final IconData solid;
  final IconData twotone;

  IconData iconFor(ProductIconType type) {
    return switch (type) {
      ProductIconType.outline => outline,
      ProductIconType.bulk => bulk,
      ProductIconType.solid => solid,
      ProductIconType.twotone => twotone,
    };
  }
}

/// Curated Agora icons that are useful as product visuals.
///
/// Each entry exposes every icon treatment so the selected icon and its type
/// can be stored together.
const kProductIconGallery = <ProductIcon>[
  ProductIcon(
    label: 'Burger',
    outline: AgoraIcons.burger,
    bulk: AgoraIcons.burger_bulk,
    solid: AgoraIcons.burger_solid,
    twotone: AgoraIcons.burger_twotone,
  ),
  ProductIcon(
    label: 'Pizza',
    outline: AgoraIcons.pizza,
    bulk: AgoraIcons.pizza_bulk,
    solid: AgoraIcons.pizza_solid,
    twotone: AgoraIcons.pizza_twotone,
  ),
  ProductIcon(
    label: 'Chef hat',
    outline: AgoraIcons.chef_hat,
    bulk: AgoraIcons.chef_hat_bulk,
    solid: AgoraIcons.chef_hat_solid,
    twotone: AgoraIcons.chef_hat_twotone,
  ),
  ProductIcon(
    label: 'Coffee',
    outline: AgoraIcons.coffee,
    bulk: AgoraIcons.coffee_bulk,
    solid: AgoraIcons.coffee_solid,
    twotone: AgoraIcons.coffee_twotone,
  ),
  ProductIcon(
    label: 'Cup',
    outline: AgoraIcons.cup,
    bulk: AgoraIcons.cup_bulk,
    solid: AgoraIcons.cup_solid,
    twotone: AgoraIcons.cup_twotone,
  ),
  ProductIcon(
    label: 'Cupcake',
    outline: AgoraIcons.cupcake,
    bulk: AgoraIcons.cupcake_bulk,
    solid: AgoraIcons.cupcake_solid,
    twotone: AgoraIcons.cupcake_twotone,
  ),
  ProductIcon(
    label: 'Ice cream',
    outline: AgoraIcons.ice_cream,
    bulk: AgoraIcons.ice_cream_bulk,
    solid: AgoraIcons.ice_cream_solid,
    twotone: AgoraIcons.ice_cream_twotone,
  ),
  ProductIcon(
    label: 'Ramen',
    outline: AgoraIcons.ramen,
    bulk: AgoraIcons.ramen_bulk,
    solid: AgoraIcons.ramen_solid,
    twotone: AgoraIcons.ramen_twotone,
  ),
  ProductIcon(
    label: 'Restaurant',
    outline: AgoraIcons.restaurant,
    bulk: AgoraIcons.restaurant_bulk,
    solid: AgoraIcons.restaurant_solid,
    twotone: AgoraIcons.restaurant_twotone,
  ),
  ProductIcon(
    label: 'Bread',
    outline: AgoraIcons.bread,
    bulk: AgoraIcons.bread_bulk,
    solid: AgoraIcons.bread_solid,
    twotone: AgoraIcons.bread_twotone,
  ),
  ProductIcon(
    label: 'Wine',
    outline: AgoraIcons.wine,
    bulk: AgoraIcons.wine_bulk,
    solid: AgoraIcons.wine_solid,
    twotone: AgoraIcons.wine_twotone,
  ),
  ProductIcon(
    label: 'Juice',
    outline: AgoraIcons.juice,
    bulk: AgoraIcons.juice_bulk,
    solid: AgoraIcons.juice_solid,
    twotone: AgoraIcons.juice_twotone,
  ),
  ProductIcon(
    label: 'Donut',
    outline: AgoraIcons.donut,
    bulk: AgoraIcons.donut_bulk,
    solid: AgoraIcons.donut_solid,
    twotone: AgoraIcons.donut_twotone,
  ),
];

/// The prefix used to persist an Agora icon in `Product.imageUrl`.
const kProductIconPrefix = 'icon:';

/// Persists both an icon's treatment and code point.
///
/// The value is deliberately stored in the existing `imageUrl` column so
/// older databases require no migration. For example:
/// `icon:solid:f2ce`.
String encodeProductIcon(ProductIcon icon, ProductIconType type) {
  final codePoint = icon.iconFor(type).codePoint.toRadixString(16);
  return '$kProductIconPrefix${type.name}:$codePoint';
}

/// Resolves a persisted product icon source, or returns null for another
/// image source (including legacy `stock:` values and device photos).
IconData? resolveProductIcon(String source) {
  if (resolveProductIconType(source) == null) return null;

  final parts = source.substring(kProductIconPrefix.length).split(':');
  final codePoint = int.tryParse(parts.last, radix: 16);
  if (codePoint == null) return null;

  return IconData(codePoint, fontFamily: 'AgoraIcons', fontPackage: 'ui_kit');
}

/// Reads the persisted visual treatment from an icon source.
ProductIconType? resolveProductIconType(String? source) {
  if (source == null || !source.startsWith(kProductIconPrefix)) return null;

  final parts = source.substring(kProductIconPrefix.length).split(':');
  if (parts.length != 2) return null;

  for (final type in ProductIconType.values) {
    if (type.name == parts.first) return type;
  }
  return null;
}
