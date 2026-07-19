import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_chip.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/overlays/app_dropdown_field.dart';
import 'package:ui_kit/src/overlays/app_dropdown_option_row.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/src/overlays/app_select.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A shadcn-faithful multi-select dropdown.
///
/// Selected values render as removable chips on the trigger. Unlike
/// [AppSelect], the popover never auto-closes on selection — toggling an
/// option keeps it open, matching shadcn's multi-select `<Command>` pattern.
/// [onChanged] always receives values in [items] order, regardless of
/// selection order.
///
/// Accessibility: each chip's delete affordance exposes its own "Remove
/// &lt;label&gt;" semantics label distinct from the trigger's own.
class AppMultiSelect<T> extends StatefulWidget {
  const AppMultiSelect({
    super.key,
    required this.items,
    required this.values,
    required this.onChanged,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.maxVisibleChips,
  });

  final List<AppSelectItem<T>> items;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  /// Collapses selected chips beyond this count into a trailing `+N` chip.
  final int? maxVisibleChips;

  @override
  State<AppMultiSelect<T>> createState() => _AppMultiSelectState<T>();
}

class _AppMultiSelectState<T> extends State<AppMultiSelect<T>> {
  final AppPopoverController _controller = AppPopoverController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(T value) {
    final next = Set<T>.from(widget.values);
    if (!next.remove(value)) next.add(value);
    // Preserve `items` order regardless of selection order.
    widget.onChanged([
      for (final item in widget.items)
        if (next.contains(item.value)) item.value,
    ]);
  }

  void _remove(T value) {
    widget.onChanged(widget.values.where((v) => v != value).toList());
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = [
      for (final item in widget.items)
        if (widget.values.contains(item.value)) item,
    ];

    return AppPopoverAnchor(
      controller: _controller,
      triggerBuilder: (triggerContext, controller) {
        final tokens = triggerContext.tokens;
        final colors = triggerContext.colors;

        Widget content;
        if (selectedItems.isEmpty) {
          content = AppText.body(
            widget.placeholder ?? '',
            color: colors.mutedForeground,
          );
        } else {
          final maxVisible = widget.maxVisibleChips;
          final visible =
              maxVisible != null && selectedItems.length > maxVisible
              ? selectedItems.sublist(0, maxVisible)
              : selectedItems;
          final overflow = selectedItems.length - visible.length;
          content = Wrap(
            spacing: tokens.spaceXs,
            runSpacing: tokens.spaceXxs,
            children: [
              for (final item in visible)
                AppChip(
                  label: item.label,
                  selected: true,
                  onDeleted: widget.enabled ? () => _remove(item.value) : null,
                ),
              if (overflow > 0) AppChip(label: '+$overflow'),
            ],
          );
        }

        return AppDropdownField(
          label: widget.label,
          helperText: widget.helperText,
          errorText: widget.errorText,
          enabled: widget.enabled,
          isOpen: controller.isOpen,
          onTap: widget.enabled ? controller.toggle : null,
          semanticsValue: selectedItems.isEmpty
              ? null
              : selectedItems.map((e) => e.label).join(', '),
          child: content,
        );
      },
      contentBuilder: (contentContext, controller) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              vertical: contentContext.tokens.spaceXxs,
            ),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return AppDropdownOptionRow(
                label: item.label,
                leadingIcon: item.icon,
                enabled: item.enabled,
                multiSelect: true,
                selected: widget.values.contains(item.value),
                onTap: item.enabled ? () => _toggle(item.value) : null,
              );
            },
          ),
        );
      },
    );
  }
}
