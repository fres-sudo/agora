import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  testWidgets('renders label and forwards onChanged', (tester) async {
    var value = '';
    await tester.pumpComponent(
      AppTextField(label: 'Email', onChanged: (v) => value = v),
    );
    expect(find.text('Email'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'hi@a.com');
    expect(value, 'hi@a.com');
  });

  testWidgets('shows error text and marks the field as errored', (
    tester,
  ) async {
    await tester.pumpComponent(
      const AppTextField(label: 'Name', errorText: 'Required'),
    );
    expect(find.text('Required'), findsOneWidget);

    final decorator = tester.widget<InputDecorator>(
      find.byType(InputDecorator),
    );
    final context = tester.element(find.byType(InputDecorator));
    expect(decorator.decoration.error, isNotNull);
    expect(
      (decorator.decoration.errorBorder! as OutlineInputBorder).borderSide,
      BorderSide(color: context.colors.destructive, width: 1),
    );
  });

  testWidgets('exposes its label to assistive tech', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpComponent(const AppTextField(label: 'Search'));
    expect(find.bySemanticsLabel('Search'), findsWidgets);
    handle.dispose();
  });

  testWidgets('renders in dark theme without error', (tester) async {
    await tester.pumpComponent(
      const AppTextField(label: 'Dark', hintText: 'type…'),
      brightness: Brightness.dark,
    );
    expect(tester.takeException(), isNull);
  });
}
