import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:ui_kit/src/widgets/app_product_icon.dart'
    show buildProductIconVisual;

void main() {
  testWidgets('every opacity-bearing product asset is bundled', (tester) async {
    for (final icon in kProductIconGallery) {
      for (final type in [ProductIconType.bulk, ProductIconType.twotone]) {
        final path = icon.assetPathFor(type)!;
        final source = await rootBundle.loadString('packages/ui_kit/$path');
        expect(source, contains('<svg'), reason: '$path must be a valid asset');
        if (type == ProductIconType.twotone) {
          expect(
            source,
            contains('opacity="0.4"'),
            reason: '$path must preserve its secondary tone',
          );
        }
      }
    }
  });

  test('two-tone product icon selects the opacity-preserving renderer', () {
    final rendered = buildProductIconVisual(
      icon: kProductIconGallery.first,
      type: ProductIconType.twotone,
      size: 96,
      color: Colors.black,
      iconTheme: const IconThemeData(),
    );

    expect(rendered, isA<SvgPicture>());
    expect((rendered as SvgPicture).colorFilter, isNotNull);
  });

  test('outline product icon continues to use the icon font', () {
    final rendered = buildProductIconVisual(
      icon: kProductIconGallery.first,
      type: ProductIconType.outline,
      iconTheme: const IconThemeData(),
    );

    expect(rendered, isA<Icon>());
  });
}
