import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Shared bordered trigger box for the `AppSelect`/`AppMultiSelect`/
/// `AppCombobox`/`AppCreatableCombobox` family. Not exported from the
/// package barrel — internal to the `overlays/` family.
///
/// Mirrors `AppTextField`'s exact border recipe (`colors.input`/hairline
/// idle, `colors.ring`/thin when open, `colors.destructive` on error) so a
/// dropdown dropped next to text fields in a form reads consistently. Height
/// is intrinsic (not a fixed token) so a multi-select's wrapping chip row can
/// grow it.
class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.child,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.isOpen = false,
    this.onTap,
    this.trailing,
    this.semanticsLabel,
    this.semanticsValue,
  });

  /// The trigger's content (placeholder/selected-value text, or a chip Wrap
  /// for multi-select).
  final Widget child;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  /// Whether the popover is currently open — drives the focus-ring border.
  final bool isOpen;
  final VoidCallback? onTap;

  /// Overrides the default trailing `chevron_up_down` affordance.
  final Widget? trailing;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final hasError = errorText != null;

    final borderColor = !enabled
        ? colors.border
        : hasError
        ? colors.destructive
        : isOpen
        ? colors.ring
        : colors.input;
    final borderWidth = isOpen || hasError
        ? tokens.borderThin
        : tokens.borderHairline;

    final field = Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel ?? label,
      value: semanticsValue,
      child: Material(
        color: enabled ? colors.background : colors.muted,
        shape: RoundedRectangleBorder(
          borderRadius: tokens.borderRadiusMd,
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: tokens.borderRadiusMd,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceSm,
              vertical: tokens.spaceXs,
            ),
            child: Row(
              children: [
                Expanded(child: child),
                SizedBox(width: tokens.spaceXs),
                ExcludeSemantics(
                  child:
                      trailing ??
                      Icon(
                        AgoraIcons.chevron_up_down,
                        size: tokens.iconMd,
                        color: colors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          AppText.label(label!),
          SizedBox(height: tokens.spaceXs),
        ],
        field,
        if (hasError || helperText != null) ...[
          SizedBox(height: tokens.spaceXs),
          AppText.caption(
            errorText ?? helperText!,
            color: hasError ? colors.destructive : colors.mutedForeground,
          ),
        ],
      ],
    );
  }
}
