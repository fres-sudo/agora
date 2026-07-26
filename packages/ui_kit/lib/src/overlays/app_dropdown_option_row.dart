import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_checkbox.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/app_palette.dart';
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
    this.leadingIconBackgroundColor,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool highlighted;
  final bool multiSelect;
  final bool enabled;
  final IconData? leadingIcon;
  final Color? leadingIconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final fg = !enabled ? colors.mutedForeground : colors.foreground;
    final leadingIconColor = leadingIconBackgroundColor == null
        ? fg
        : leadingIconBackgroundColor!.computeLuminance() > 0.5
        ? AppPalette.neutral800
        : AppPalette.white;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      label: label,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.xxs,
          vertical: tokens.spacing.xxs / 2,
        ),
        child: Material(
          color: highlighted ? colors.accent : Colors.transparent,
          borderRadius: tokens.radius.borderSm,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: tokens.radius.borderSm,
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacing.sm,
                vertical: tokens.spacing.xs,
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
                    SizedBox(width: tokens.spacing.xs),
                  ] else ...[
                    SizedBox(
                      width: tokens.iconSize.md,
                      child: selected
                          ? Icon(
                              AgoraIcons.check,
                              size: tokens.iconSize.sm,
                              color: fg,
                            )
                          : null,
                    ),
                    SizedBox(width: tokens.spacing.xs),
                  ],
                  if (leadingIcon != null) ...[
                    leadingIconBackgroundColor == null
                        ? Icon(leadingIcon, size: tokens.iconSize.sm, color: fg)
                        : Container(
                            alignment: Alignment.center,
                            width: tokens.iconSize.lg,
                            height: tokens.iconSize.lg,
                            decoration: BoxDecoration(
                              color: leadingIconBackgroundColor,
                              borderRadius: tokens.radius.borderSm,
                            ),
                            child: Icon(
                              leadingIcon,
                              size: tokens.iconSize.sm,
                              color: leadingIconColor,
                            ),
                          ),
                    SizedBox(width: tokens.spacing.xs),
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
      ),
    );
  }
}
