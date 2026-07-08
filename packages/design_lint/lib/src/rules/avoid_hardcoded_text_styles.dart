import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../design_system_paths.dart';

/// Flags inline `TextStyle(...)` construction outside the design system.
///
/// Typography must come from the design-system scale so weights, sizes and
/// tracking stay consistent and color-agnostic. Use `context.typography.*`
/// (optionally `.copyWith(...)` for one-off tweaks), or render text with
/// `AppText`, which is already bound to the scale.
class AvoidHardcodedTextStyles extends DartLintRule {
  const AvoidHardcodedTextStyles() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_hardcoded_text_styles',
    problemMessage: 'Inline TextStyle bypasses the design-system type scale.',
    correctionMessage:
        'Use context.typography.<style> (add .copyWith(...) for tweaks) or '
        'render with AppText.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static const _textStyleChecker = TypeChecker.fromName(
    'TextStyle',
    packageName: 'flutter',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExemptPath(resolver.path)) return;

    context.registry.addInstanceCreationExpression((node) {
      final type = node.constructorName.type.type;
      if (type != null && _textStyleChecker.isExactlyType(type)) {
        reporter.atNode(node, _code);
      }
    });
  }
}
