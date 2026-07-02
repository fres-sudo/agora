import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../design_system_paths.dart';

/// Steers callers from the raw Material `Text` widget to `AppText`.
///
/// `AppText` binds every string to the design-system type scale and resolves
/// its color from the theme, so it stays correct across light/dark mode.
class PreferAppText extends DartLintRule {
  const PreferAppText() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_app_text',
    problemMessage: 'Use AppText instead of the raw Text widget.',
    correctionMessage:
        'Replace Text(...) with AppText(...) (e.g. AppText.body(...)) so it '
        'follows the design-system type scale and theming.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static const _textChecker =
      TypeChecker.fromName('Text', packageName: 'flutter');

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExemptPath(resolver.path)) return;

    context.registry.addInstanceCreationExpression((node) {
      final type = node.constructorName.type.type;
      if (type != null && _textChecker.isExactlyType(type)) {
        reporter.atNode(node, _code);
      }
    });
  }
}
