import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/overlays/app_dropdown_field.dart';
import 'package:ui_kit/src/overlays/app_dropdown_option_row.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A single item in an [AppSelect] or [AppMultiSelect].
@immutable
class AppSelectItem<T> {
  const AppSelectItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;
}

/// A shadcn-faithful single-select dropdown.
///
/// Renders [placeholder] (in `mutedForeground`) when [value] is `null`, or
/// the matching item's label otherwise. Selecting an item always closes the
/// popover, matching shadcn's `<Select>`.
///
/// Accessibility: the trigger exposes a button role with [label] as its
/// accessible name and the selected item's label as its value; arrow keys
/// move a keyboard highlight through the options and Enter/Space commits it.
class AppSelect<T> extends StatefulWidget {
  const AppSelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.allowClear = false,
    this.selectedBuilder,
  });

  final List<AppSelectItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  /// Adds a trailing clear (`x_mark`) affordance when a value is set.
  final bool allowClear;

  /// Custom rendering of the selected value in the trigger; defaults to the
  /// matching item's label.
  final Widget Function(T value)? selectedBuilder;

  @override
  State<AppSelect<T>> createState() => _AppSelectState<T>();
}

class _AppSelectState<T> extends State<AppSelect<T>> {
  final AppPopoverController _controller = AppPopoverController();
  final ValueNotifier<int> _highlightedIndex = ValueNotifier(-1);

  @override
  void dispose() {
    _controller.dispose();
    _highlightedIndex.dispose();
    super.dispose();
  }

  AppSelectItem<T>? get _selectedItem {
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  void _selectAt(int index) {
    if (index < 0 || index >= widget.items.length) return;
    final item = widget.items[index];
    if (!item.enabled) return;
    widget.onChanged(item.value);
    _controller.close();
  }

  void _handleOpen() {
    final selected = _selectedItem;
    _highlightedIndex.value = selected == null
        ? 0
        : widget.items.indexOf(selected);
  }

  void _moveHighlight(int delta) {
    final count = widget.items.length;
    if (count == 0) return;
    var next = _highlightedIndex.value;
    for (var i = 0; i < count; i++) {
      next = (next + delta) % count;
      if (next < 0) next += count;
      if (widget.items[next].enabled) {
        _highlightedIndex.value = next;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = _selectedItem;

    return AppPopoverAnchor(
      controller: _controller,
      onOpen: _handleOpen,
      triggerBuilder: (triggerContext, controller) {
        return AppDropdownField(
          label: widget.label,
          helperText: widget.helperText,
          errorText: widget.errorText,
          enabled: widget.enabled,
          isOpen: controller.isOpen,
          onTap: widget.enabled ? controller.toggle : null,
          semanticsValue: selected?.label,
          trailing: widget.allowClear && selected != null
              ? IconButton(
                  tooltip: 'Clear',
                  icon: Icon(
                    AgoraIcons.x_mark,
                    size: triggerContext.tokens.iconSm,
                  ),
                  onPressed: () => widget.onChanged(null),
                )
              : null,
          child: selected == null
              ? AppText.body(
                  widget.placeholder ?? '',
                  color: colors.mutedForeground,
                )
              : (widget.selectedBuilder?.call(selected.value) ??
                    AppText.body(selected.label)),
        );
      },
      contentBuilder: (contentContext, controller) {
        return ValueListenableBuilder<int>(
          valueListenable: _highlightedIndex,
          builder: (context, highlighted, _) {
            return Focus(
              onKeyEvent: (node, event) {
                if (event is! KeyDownEvent) return KeyEventResult.ignored;
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  _moveHighlight(1);
                  return KeyEventResult.handled;
                }
                if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  _moveHighlight(-1);
                  return KeyEventResult.handled;
                }
                if (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) {
                  _selectAt(_highlightedIndex.value);
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    vertical: context.tokens.spaceXxs,
                  ),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return AppDropdownOptionRow(
                      label: item.label,
                      leadingIcon: item.icon,
                      enabled: item.enabled,
                      selected: item.value == widget.value,
                      highlighted: index == highlighted,
                      onTap: () => _selectAt(index),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
