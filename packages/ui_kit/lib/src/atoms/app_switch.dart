import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Token-aware on/off switch.
///
/// TODO(design-system): expand with size variants and a labelled row layout.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colors.primaryForeground,
        activeTrackColor: colors.primary,
        inactiveThumbColor: colors.mutedForeground,
        inactiveTrackColor: colors.muted,
        trackOutlineColor: WidgetStatePropertyAll(colors.border),
      ),
    );
  }
}
