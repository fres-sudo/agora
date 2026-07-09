import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('QuantityButton accessibility', () {
    testWidgets('increment control exposes a semantic label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(
        QuantityButton(quantity: 1, onChanged: (_) {}),
      );

      expect(find.bySemanticsLabel('Increase quantity'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('decrement control exposes a semantic label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(
        QuantityButton(quantity: 1, onChanged: (_) {}),
      );

      expect(find.bySemanticsLabel('Decrease quantity'), findsOneWidget);
      handle.dispose();
    });
  });

  group('QuantityButton behavior', () {
    testWidgets('tapping increment calls onChanged with quantity + 1', (
      tester,
    ) async {
      int? result;
      await tester.pumpComponent(
        QuantityButton(quantity: 2, onChanged: (value) => result = value),
      );

      await tester.tap(find.bySemanticsLabel('Increase quantity'));
      expect(result, 3);
    });

    testWidgets('decrement is disabled and unlabeled-tap-safe at min', (
      tester,
    ) async {
      int? result;
      await tester.pumpComponent(
        QuantityButton(
          quantity: 0,
          min: 0,
          onChanged: (value) => result = value,
        ),
      );

      await tester.tap(
        find.bySemanticsLabel('Decrease quantity'),
        warnIfMissed: false,
      );
      expect(result, isNull);
    });
  });
}
