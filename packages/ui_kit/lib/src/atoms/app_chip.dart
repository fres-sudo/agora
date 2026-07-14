import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';
import 'package:ui_kit/ui_kit.dart';

/// A selectable, token-aware chip (filters, tags, quick-select).
///
/// TODO(design-system): add leading avatar, deletable variant and chip groups.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

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
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceMd,
              vertical: tokens.spaceSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: tokens.iconSm, color: fg),
                  SizedBox(width: tokens.spaceXs),
                ],
                AppText.label(label, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
