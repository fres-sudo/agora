import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> pumpApp(Widget widget, {bool wrapWithScaffold = true}) {
    return pumpWidget(
      MaterialApp(
        home: wrapWithScaffold ? Scaffold(body: widget) : widget,
      ),
    );
  }
}
