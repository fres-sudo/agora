import 'package:analyzer/dart/ast/ast.dart' show AstNode;
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../design_system_paths.dart';

/// Flags hard-coded colors — `Color(0xFF...)`, `Color.fromARGB(...)`,
/// `Colors.red`, etc. — anywhere outside the design system.
///
/// Colors must resolve from the active theme so they stay correct in light and
/// dark mode. Read a semantic token via `context.colors.*` instead.
class AvoidHardcodedColors extends DartLintRule {
  const AvoidHardcodedColors() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_hardcoded_colors',
    problemMessage: 'Hard-coded color. This will not adapt to light/dark mode.',
    correctionMessage:
        'Use a semantic token: context.colors.<token> (e.g. '
        'context.colors.primary, context.colors.mutedForeground).',
    errorSeverity: ErrorSeverity.WARNING,
  );

  // Flutter's `Color` (covers Color(), Color.fromARGB(), Color.fromRGBO()).
  static const _colorChecker = TypeChecker.fromName(
    'Color',
    packageName: 'flutter',
  );
  // dart:ui `Color`, in case it is referenced directly.
  static const _uiColorChecker = TypeChecker.fromUrl('dart:ui#Color');

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExemptPath(resolver.path)) return;

    // Constructor calls: Color(0xFF..), Color.fromARGB(...), Color.fromRGBO(...)
    context.registry.addInstanceCreationExpression((node) {
      final type = node.constructorName.type.type;
      if (type == null) return;
      if (_colorChecker.isExactlyType(type) ||
          _uiColorChecker.isExactlyType(type)) {
        _report(reporter, node);
      }
    });

    // Static references off the `Colors` swatch table: Colors.red, Colors.white…
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name != 'Colors') return;
      final element = node.prefix.element;
      // Only the Flutter `Colors` class, not some unrelated `Colors` symbol.
      if (element == null || element.library?.uri.toString() == _materialUri) {
        _report(reporter, node);
      }
    });
  }

  static const _materialUri = 'package:flutter/src/material/colors.dart';

  /// Reports [node] via [reporter], guarding against a crash in
  /// `custom_lint_builder`'s `// ignore:` comment scanner.
  ///
  /// `custom_lint_builder`'s `parseIgnoreForLine` (`custom_lint_builder/src/
  /// ignore.dart`) slices the source text to look for a trailing `// ignore:`
  /// comment above every reported diagnostic. For certain AST shapes — e.g.
  /// two violations on one line, both covered by a single `// ignore:` comment
  /// on the line above, as in `apps/agora/lib/app/app.dart`'s flavor banner
  /// (`color: isStaging ? Colors.deepOrange : Colors.blue`) — that internal
  /// bookkeeping throws an uncaught `RangeError`, which previously killed the
  /// whole plugin isolate and silently suppressed every other diagnostic for
  /// the run (see the repo's now-removed `custom_lint.log`, which recorded
  /// this exact crash repeatedly). Reporting is a leaf operation with no
  /// further side effects we need to protect, so we contain the failure here
  /// instead of letting one bad node take down the entire lint pass.
  static void _report(ErrorReporter reporter, AstNode node) {
    try {
      reporter.atNode(node, _code);
    } catch (_) {
      // Swallow: see the doc comment above. Losing one diagnostic on a
      // pathological AST shape is far preferable to losing every diagnostic
      // in the run.
    }
  }
}
