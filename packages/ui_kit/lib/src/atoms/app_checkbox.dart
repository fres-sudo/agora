import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Token-aware checkbox with an optional inline label.
///
/// TODO(design-system): add indeterminate state and error styling.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: colors.primary,
      checkColor: colors.primaryForeground,
      side: BorderSide(color: colors.border, width: context.tokens.borderThin),
      shape: RoundedRectangleBorder(
        borderRadius: context.tokens.borderRadiusSm,
      ),
    );

    if (label == null) {
      return Semantics(label: label, checked: value, child: checkbox);
    }

    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      borderRadius: context.tokens.borderRadiusSm,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          SizedBox(width: context.tokens.spaceXs),
          Flexible(child: AppText.body(label!)),
        ],
      ),
    );
  }
}
