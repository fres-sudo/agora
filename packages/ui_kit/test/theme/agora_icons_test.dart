import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final loader = FontLoader('packages/ui_kit/AgoraIcons')
      ..addFont(rootBundle.load('packages/ui_kit/assets/fonts/AgoraIcons.ttf'));
    await loader.load();
  });

  testWidgets('every AgoraIcons glyph paints at the expected scale', (
    tester,
  ) async {
    final icons = <MapEntry<String, IconData>>[
      for (final entry in AgoraIcons.all.entries)
        MapEntry(entry.key, entry.value),
    ];

    expect(icons, hasLength(2482));
    expect(
      icons.map((entry) => entry.value.codePoint).toSet(),
      hasLength(icons.length),
      reason: 'Every generated binding must address a distinct codepoint.',
    );

    const columns = 50;
    const cellSize = 40;
    const iconSize = 32.0;
    const scaleCheckedIconNames = {
      'activity',
      'activity_bulk',
      'activity_solid',
      'activity_twotone',
      'burger',
      'burger_bulk',
      'burger_solid',
      'burger_twotone',
      'chef_hat',
      'chef_hat_bulk',
      'chef_hat_solid',
      'chef_hat_twotone',
      'x_mark_twotone',
    };
    final rows = (icons.length / columns).ceil();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = TextPainter(textDirection: TextDirection.ltr);

    for (var index = 0; index < icons.length; index++) {
      final icon = icons[index].value;
      painter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontFamily: icon.fontFamily,
          fontFamilyFallback: icon.fontFamilyFallback,
          package: icon.fontPackage,
          fontSize: iconSize,
          height: 1,
        ),
      );
      painter.layout();

      final column = index % columns;
      final row = index ~/ columns;
      painter.paint(
        canvas,
        Offset(
          column * cellSize + (cellSize - painter.width) / 2,
          row * cellSize + (cellSize - painter.height) / 2,
        ),
      );
    }

    final picture = recorder.endRecording();
    final byteData = await tester.runAsync(() async {
      final image = await picture.toImage(columns * cellSize, rows * cellSize);
      picture.dispose();
      try {
        return await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      } finally {
        image.dispose();
      }
    });
    expect(byteData, isNotNull);
    final pixels = byteData!.buffer.asUint8List();
    final imageWidth = columns * cellSize;
    final failures = <String>[];

    for (var index = 0; index < icons.length; index++) {
      final cellX = (index % columns) * cellSize;
      final cellY = (index ~/ columns) * cellSize;
      var minX = cellSize;
      var maxX = -1;

      for (var y = 0; y < cellSize; y++) {
        for (var x = 0; x < cellSize; x++) {
          final alphaIndex = ((cellY + y) * imageWidth + cellX + x) * 4 + 3;
          if (pixels[alphaIndex] == 0) continue;
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
        }
      }

      final paintedWidth = maxX < minX ? 0 : maxX - minX + 1;
      final minimumPaintedWidth =
          scaleCheckedIconNames.contains(icons[index].key) ? 20 : 1;
      if (paintedWidth < minimumPaintedWidth) {
        failures.add('${icons[index].key}: painted width $paintedWidth px');
      }
    }

    expect(
      failures,
      isEmpty,
      reason:
          'Glyphs must not be blank or retain unnormalized 24-unit geometry. '
          'Failures: ${failures.take(20).join(', ')}',
    );
  });
}
