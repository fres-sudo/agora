import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  Widget wrap(
    Widget child, {
    Brightness brightness = Brightness.light,
    Size? size,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: size ?? const Size(400, 800)),
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        home: child,
      ),
    );
  }

  testWidgets('renders body and paints token background', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AppScaffold(
          appBar: AppAppBar(title: 'Home'),
          body: Center(child: AppText.body('content')),
        ),
      ),
    );
    expect(find.text('content'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.light.background);
  });

  testWidgets('applies responsive insets when requested', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AppScaffold(applyResponsiveInsets: true, body: SizedBox.expand()),
        size: const Size(1200, 900),
      ),
    );
    expect(find.byType(Padding), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders in dark theme', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AppScaffold(body: Center(child: AppText.body('dark'))),
        brightness: Brightness.dark,
      ),
    );
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.dark.background);
  });
}
