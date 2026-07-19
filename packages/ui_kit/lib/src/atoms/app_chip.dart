import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// A selectable, token-aware chip (filters, tags, quick-select).
///
/// TODO(design-system): add leading avatar and chip groups.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.onDeleted,
    this.deleteIcon = AgoraIcons.x_mark,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  /// When set, renders a trailing delete affordance and makes this a
  /// removable tag (e.g. a selected value in a multi-select trigger).
  final VoidCallback? onDeleted;
  final IconData deleteIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final bg = selected ? colors.primary : colors.muted;
    final fg = selected ? colors.primaryForeground : colors.foreground;

    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(tokens.radiusFull),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(tokens.radiusFull),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd, vertical: tokens.spaceSm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: tokens.iconSm, color: fg),
                  SizedBox(width: tokens.spaceXs),
                ],
                AppText.label(label, color: fg),
                if (onDeleted != null) ...[
                  SizedBox(width: tokens.spaceXs),
                  Semantics(
                    container: true,
                    button: true,
                    label: 'Remove $label',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onDeleted,
                      child: Icon(deleteIcon, size: tokens.iconSm, color: fg),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
