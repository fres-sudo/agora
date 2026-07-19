import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_checkbox.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Shared option-row renderer used by `AppSelect`/`AppMultiSelect`/
/// `AppCombobox`/`AppCreatableCombobox`. Not exported from the package
/// barrel — internal to the `overlays/` family.
///
/// Single-select rows reserve a leading `check`-icon gutter (visible only
/// when [selected]) so labels stay aligned across rows; multi-select rows
/// use an [AppCheckbox] instead. [highlighted] drives the
/// `accent`/`accentForeground` hover/keyboard-highlight fill.
class AppDropdownOptionRow extends StatelessWidget {
  const AppDropdownOptionRow({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.highlighted = false,
    this.multiSelect = false,
    this.enabled = true,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool highlighted;
  final bool multiSelect;
  final bool enabled;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final fg = !enabled
        ? colors.mutedForeground
        : highlighted
        ? colors.accentForeground
        : colors.foreground;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      label: label,
      child: Material(
        color: highlighted ? colors.accent : Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceSm,
              vertical: tokens.spaceXs,
            ),
            child: Row(
              children: [
                if (multiSelect) ...[
                  ExcludeSemantics(
                    child: AppCheckbox(
                      value: selected,
                      onChanged: enabled ? (_) => onTap?.call() : null,
                    ),
                  ),
                  SizedBox(width: tokens.spaceXs),
                ] else ...[
                  SizedBox(
                    width: tokens.iconMd,
                    child: selected
                        ? Icon(AgoraIcons.check, size: tokens.iconSm, color: fg)
                        : null,
                  ),
                  SizedBox(width: tokens.spaceXs),
                ],
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: tokens.iconSm, color: fg),
                  SizedBox(width: tokens.spaceXs),
                ],
                Expanded(
                  child: ExcludeSemantics(
                    child: AppText.body(label, color: fg),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
