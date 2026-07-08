import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

/// Test harness for design-system components.
///
/// Wraps [child] in a real [MaterialApp] carrying [AppTheme.light]/[AppTheme.dark]
/// so components resolve their tokens exactly as they would in the app. Every
/// component is expected to be exercised in **both** [Brightness]es.
extension PumpComponent on WidgetTester {
  Future<void> pumpComponent(
    Widget child, {
    Brightness brightness = Brightness.light,
  }) {
    return pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }
}
