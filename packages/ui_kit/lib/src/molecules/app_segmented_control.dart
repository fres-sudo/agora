import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// One choice in an [AppSegmentedControl].
class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.icon});
  final T value;
  final String label;
  final IconData? icon;
}

/// A compact single-select control (e.g. list/grid, day/week/month).
///
/// TODO(design-system): add scrollable overflow and size variants.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<AppSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    return Container(
      padding: EdgeInsets.all(tokens.spacing.xxs),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: tokens.radius.borderMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final segment in segments)
            _Segment<T>(
              segment: segment,
              isSelected: segment.value == selected,
              onTap: () => onChanged(segment.value),
            ),
        ],
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.isSelected,
    required this.onTap,
  });

  final AppSegment<T> segment;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final fg = isSelected ? colors.foreground : colors.mutedForeground;
    return Semantics(
      button: true,
      selected: isSelected,
      label: segment.label,
      child: Material(
        color: isSelected ? colors.card : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(tokens.radius.sm),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.md,
              vertical: tokens.spacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (segment.icon != null) ...[
                  Icon(segment.icon, size: tokens.iconSize.sm, color: fg),
                  SizedBox(width: tokens.spacing.xs),
                ],
                Text(
                  segment.label,
                  style: context.typography.label.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
