import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/design_lint_plugin.dart';

/// Entry point discovered by `custom_lint`. Registers every design-system rule.
PluginBase createPlugin() => DesignLintPlugin();
