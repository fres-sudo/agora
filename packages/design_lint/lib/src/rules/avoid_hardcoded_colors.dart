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
    problemMessage:
        'Hard-coded color. This will not adapt to light/dark mode.',
    correctionMessage:
        'Use a semantic token: context.colors.<token> (e.g. '
        'context.colors.primary, context.colors.mutedForeground).',
    errorSeverity: ErrorSeverity.WARNING,
  );

  // Flutter's `Color` (covers Color(), Color.fromARGB(), Color.fromRGBO()).
  static const _colorChecker =
      TypeChecker.fromName('Color', packageName: 'flutter');
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
        reporter.atNode(node, _code);
      }
    });

    // Static references off the `Colors` swatch table: Colors.red, Colors.white…
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name != 'Colors') return;
      final element = node.prefix.element;
      // Only the Flutter `Colors` class, not some unrelated `Colors` symbol.
      if (element == null || element.library?.uri.toString() == _materialUri) {
        reporter.atNode(node, _code);
      }
    });
  }

  static const _materialUri = 'package:flutter/src/material/colors.dart';
}
