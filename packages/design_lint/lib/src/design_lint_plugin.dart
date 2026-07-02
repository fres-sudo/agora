import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'rules/avoid_hardcoded_colors.dart';
import 'rules/avoid_hardcoded_text_styles.dart';
import 'rules/prefer_app_button.dart';
import 'rules/prefer_app_text.dart';
import 'rules/prefer_app_text_field.dart';

/// The Agora design-system lint plugin.
///
/// Every rule steers callers toward the `ui_kit` design system: semantic tokens
/// read from `context` instead of hard-coded colors/text styles, and the atomic
/// components (`AppText`, `AppTextField`, `AppButton`) instead of the raw
/// Material widgets they wrap.
///
/// Each rule is `warning` severity so it is visible in the IDE and fails
/// `custom_lint` / CI, but can be silenced on a single line with
/// `// ignore: <rule_name>` for the rare, deliberate exception. Rules can also
/// be toggled per package under `custom_lint: rules:` in `analysis_options.yaml`.
class DesignLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidHardcodedColors(),
        const AvoidHardcodedTextStyles(),
        const PreferAppText(),
        const PreferAppTextField(),
        const PreferAppButton(),
      ];
}
