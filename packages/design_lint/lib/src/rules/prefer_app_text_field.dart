import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../design_system_paths.dart';

/// Steers callers from raw `TextField` / `TextFormField` to `AppTextField`.
///
/// `AppTextField` carries the design-system label/hint/error treatment and the
/// themed focus ring, so inputs look and behave consistently everywhere.
class PreferAppTextField extends DartLintRule {
  const PreferAppTextField() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_app_text_field',
    problemMessage:
        'Use AppTextField instead of a raw TextField/TextFormField.',
    correctionMessage:
        'Replace with AppTextField(...) for consistent labels, error states '
        'and the themed focus ring.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static const _checkers = [
    TypeChecker.fromName('TextField', packageName: 'flutter'),
    TypeChecker.fromName('TextFormField', packageName: 'flutter'),
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
