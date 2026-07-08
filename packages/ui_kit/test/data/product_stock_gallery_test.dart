import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('resolveProductStockImage', () {
    test('returns the matching stock image for a known id', () {
      final image = resolveProductStockImage('burger');

      expect(image, isNotNull);
      expect(image!.id, 'burger');
      expect(image.assetPath, 'assets/product_gallery/burger.svg');
    });

    test('returns null for an unknown id', () {
      expect(resolveProductStockImage('not-a-real-id'), isNull);
    });

    test('every entry in the catalog resolves to itself', () {
      for (final entry in kProductStockGallery) {
        expect(resolveProductStockImage(entry.id), same(entry));
      }
    });
  });
}
