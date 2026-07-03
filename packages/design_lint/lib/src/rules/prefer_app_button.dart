import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../design_system_paths.dart';

/// Steers callers from raw Material buttons to `AppButton`.
///
/// Covers `ElevatedButton`, `FilledButton`, `OutlinedButton` and `TextButton`
/// (including their `.icon` constructors). `AppButton` maps these onto the
/// design-system variants (primary/secondary/ghost/outline/destructive) with
/// token-driven sizing, loading state and accessible tap targets.
class PreferAppButton extends DartLintRule {
  const PreferAppButton() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_app_button',
    problemMessage: 'Use AppButton instead of a raw Material button.',
    correctionMessage:
        'Replace with AppButton (e.g. AppButton.primary / .secondary / .ghost '
        '/ .outline / .destructive) for consistent variants and sizing.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static const _checkers = [
    TypeChecker.fromName('ElevatedButton', packageName: 'flutter'),
    TypeChecker.fromName('FilledButton', packageName: 'flutter'),
    TypeChecker.fromName('OutlinedButton', packageName: 'flutter'),
    TypeChecker.fromName('TextButton', packageName: 'flutter'),
  ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExemptPath(resolver.path)) return;

    context.registry.addInstanceCreationExpression((node) {
      final type = node.constructorName.type.type;
      if (type == null) return;
      if (_checkers.any((c) => c.isExactlyType(type))) {
        reporter.atNode(node, _code);
      }
    });
  }
}
