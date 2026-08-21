import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('product icon sources', () {
    test('encodeProductIcon persists both the type and icon code point', () {
      final value = encodeProductIcon(
        kProductIconGallery.first,
        ProductIconType.solid,
      );

      expect(value, 'icon:solid:f2ce');
    });

    test('resolveProductIcon restores an AgoraIcons glyph', () {
      final icon = resolveProductIcon('icon:twotone:f2cf');

      expect(icon, isNotNull);
      expect(icon!.codePoint, AgoraIcons.burger_twotone.codePoint);
      expect(icon.fontFamily, 'AgoraIcons');
      expect(icon.fontPackage, 'ui_kit');
      expect(
        resolveProductIconType('icon:twotone:f2cf'),
        ProductIconType.twotone,
      );
    });

    test('opacity-bearing treatments resolve their bundled SVGs', () {
      final burger = kProductIconGallery.first;

      expect(burger.assetPathFor(ProductIconType.outline), isNull);
      expect(burger.assetPathFor(ProductIconType.solid), isNull);
      expect(
        burger.assetPathFor(ProductIconType.bulk),
        'assets/product_icons/bulk/burger.svg',
      );
      expect(
        burger.assetPathFor(ProductIconType.twotone),
        'assets/product_icons/twotone/burger.svg',
      );
    });

    test('persisted icon resolves its curated definition', () {
      final definition = resolveProductIconDefinition('icon:twotone:f2cf');

      expect(definition, same(kProductIconGallery.first));
    });

    test('resolveProductIcon rejects malformed and non-icon sources', () {
      expect(resolveProductIcon('stock:burger'), isNull);
      expect(resolveProductIcon('icon:not-a-type:f2d0'), isNull);
      expect(resolveProductIcon('icon:solid:not-a-code-point'), isNull);
    });
  });
}
