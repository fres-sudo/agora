import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  testWidgets('renders its data in both themes', (tester) async {
    for (final brightness in Brightness.values) {
      await tester.pumpComponent(
        const AppText.headingLg('Dashboard'),
        brightness: brightness,
      );
      expect(find.text('Dashboard'), findsOneWidget);
    }
  });

  testWidgets('applies the resolved foreground color by default',
      (tester) async {
    await tester.pumpComponent(const AppText.body('Hi'));
    final text = tester.widget<Text>(find.text('Hi'));
    expect(text.style!.color, AppColors.light.foreground);
  });

  testWidgets('honors an explicit semantic color', (tester) async {
    await tester.pumpComponent(
      Builder(
        builder: (context) => AppText.caption(
          'muted',
          color: context.colors.mutedForeground,
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('muted'));
    expect(text.style!.color, AppColors.light.mutedForeground);
  });

  testWidgets('meets text-contrast guideline on background', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpComponent(const AppText.body('Readable body text'));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
