import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/src/atoms/app_chip.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/overlays/app_dropdown_field.dart';
import 'package:ui_kit/src/overlays/app_dropdown_option_row.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A single item in an [AppCombobox] / [AppCreatableCombobox].
@immutable
class AppComboboxItem<T> {
  const AppComboboxItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    String? searchKey,
  }) : searchKey = searchKey ?? label;

  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  /// Text matched against the search query; defaults to [label]. Lets a
  /// caller filter by e.g. a SKU while still displaying a product name.
  final String searchKey;
}

/// A shadcn-faithful searchable dropdown (combobox), in single- or
/// multi-select mode via [AppCombobox.single]/[AppCombobox.multiple].
///
/// The embedded filter box sits flush at the top of the popover with only a
/// bottom rule (matching shadcn's `<CommandInput>`) rather than the fully
/// outlined chrome of [AppTextField]. Arrow keys move a keyboard highlight
/// through the filtered results without moving focus out of the search
/// field; Enter commits the highlighted row.
class AppCombobox<T> extends StatefulWidget {
  const AppCombobox.single({
    super.key,
    required this.items,
    required ValueChanged<T?> onChanged,
    this.value,
    this.placeholder,
    this.searchHint = 'Search…',
    this.emptyText = 'No results found.',
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
  }) : multiple = false,
       onChangedSingle = onChanged,
       onChangedMultiple = null,
       values = const [];

  const AppCombobox.multiple({
    super.key,
    required this.items,
    required ValueChanged<List<T>> onChanged,
    this.values = const [],
    this.placeholder,
    this.searchHint = 'Search…',
    this.emptyText = 'No results found.',
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
  }) : multiple = true,
       onChangedMultiple = onChanged,
       onChangedSingle = null,
       value = null;

  final List<AppComboboxItem<T>> items;
  final bool multiple;
  final T? value;
  final List<T> values;
  final ValueChanged<T?>? onChangedSingle;
  final ValueChanged<List<T>>? onChangedMultiple;
  final String? placeholder;
  final String searchHint;
  final String emptyText;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  @override
  State<AppCombobox<T>> createState() => _AppComboboxState<T>();
}

class _AppComboboxState<T> extends State<AppCombobox<T>> {
  final AppPopoverController _controller = AppPopoverController();
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(
    debugLabel: 'AppCombobox search',
  );
  final ValueNotifier<String> _query = ValueNotifier('');
  final ValueNotifier<int> _highlightedIndex = ValueNotifier(0);

  @override
  void dispose() {
    _controller.dispose();
    _queryController.dispose();
    _searchFocusNode.dispose();
    _query.dispose();
    _highlightedIndex.dispose();
    super.dispose();
  }

  List<AppComboboxItem<T>> _filtered(String query) {
    if (query.isEmpty) return widget.items;
    final lower = query.toLowerCase();
    return [
      for (final item in widget.items)
        if (item.searchKey.toLowerCase().contains(lower)) item,
    ];
  }

  void _handleOpen() {
    _queryController.clear();
    _query.value = '';
    _highlightedIndex.value = 0;
    // The search field's own `autofocus` only claims focus if nothing else
    // already has it, and the just-tapped trigger typically does — force it
    // once the entry has actually mounted (mirrors AppPopoverAnchor's own
    // forced-focus fix for the same underlying Flutter behavior).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.isOpen) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  AppComboboxItem<T>? _selectedSingleItem() {
    if (widget.multiple) return null;
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  List<AppComboboxItem<T>> _selectedMultiItems() {
    if (!widget.multiple) return const [];
    return [
      for (final item in widget.items)
        if (widget.values.contains(item.value)) item,
    ];
  }

  void _toggleMulti(T value) {
    final next = Set<T>.from(widget.values);
    if (!next.remove(value)) next.add(value);
    widget.onChangedMultiple!([
      for (final item in widget.items)
        if (next.contains(item.value)) item.value,
    ]);
  }

  void _selectAt(List<AppComboboxItem<T>> filtered, int index) {
    if (index < 0 || index >= filtered.length) return;
    final item = filtered[index];
    if (!item.enabled) return;
    if (widget.multiple) {
      _toggleMulti(item.value);
    } else {
      widget.onChangedSingle!(item.value);
      _controller.close();
    }
  }

  void _moveHighlight(List<AppComboboxItem<T>> filtered, int delta) {
    final count = filtered.length;
    if (count == 0) return;
    var next = _highlightedIndex.value;
    for (var i = 0; i < count; i++) {
      next = (next + delta) % count;
      if (next < 0) next += count;
      if (filtered[next].enabled) {
        _highlightedIndex.value = next;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPopoverAnchor(
      controller: _controller,
      // The search field autofocuses itself once the popover opens; don't
      // have the shared primitive fight it for focus.
      autoFocusContent: false,
      onOpen: _handleOpen,
      triggerBuilder: (triggerContext, controller) {
        final colors = triggerContext.colors;
        final tokens = triggerContext.tokens;

        Widget content;
        String? semanticsValue;
        if (widget.multiple) {
          final selected = _selectedMultiItems();
          if (selected.isEmpty) {
            content = AppText.body(
              widget.placeholder ?? '',
              color: colors.mutedForeground,
            );
          } else {
            semanticsValue = selected.map((e) => e.label).join(', ');
            content = Wrap(
              spacing: tokens.spacing.xs,
              runSpacing: tokens.spacing.xxs,
              children: [
                for (final item in selected)
                  AppChip(
                    label: item.label,
                    selected: true,
                    onDeleted: widget.enabled
                        ? () => _toggleMulti(item.value)
                        : null,
                  ),
              ],
            );
          }
        } else {
          final selected = _selectedSingleItem();
          semanticsValue = selected?.label;
          content = selected == null
              ? AppText.body(
                  widget.placeholder ?? '',
                  color: colors.mutedForeground,
                )
              : AppText.body(selected.label);
        }

        return AppDropdownField(
          label: widget.label,
          helperText: widget.helperText,
          errorText: widget.errorText,
          enabled: widget.enabled,
          isOpen: controller.isOpen,
          onTap: widget.enabled ? controller.toggle : null,
          semanticsValue: semanticsValue,
          child: content,
        );
      },
      contentBuilder: (contentContext, controller) {
        final tokens = contentContext.tokens;
        final colors = contentContext.colors;
        final typography = contentContext.typography;

        return ValueListenableBuilder<String>(
          valueListenable: _query,
          builder: (context, query, _) {
            final filtered = _filtered(query);
            return ValueListenableBuilder<int>(
              valueListenable: _highlightedIndex,
              builder: (context, highlighted, _) {
                return Focus(
                  onKeyEvent: (node, event) {
                    if (event is! KeyDownEvent) return KeyEventResult.ignored;
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      _moveHighlight(filtered, 1);
                      return KeyEventResult.handled;
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      _moveHighlight(filtered, -1);
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: colors.border,
                              width: tokens.border.hairline,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.spacing.sm,
                          vertical: tokens.spacing.xs,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              AgoraIcons.search,
                              size: tokens.iconSize.sm,
                              color: colors.mutedForeground,
                            ),
                            SizedBox(width: tokens.spacing.xs),
                            Expanded(
                              child: TextField(
                                controller: _queryController,
                                focusNode: _searchFocusNode,
                                style: typography.body.copyWith(
                                  color: colors.foreground,
                                ),
                                cursorColor: colors.ring,
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  hintText: widget.searchHint,
                                  hintStyle: typography.body.copyWith(
                                    color: colors.mutedForeground,
                                  ),
                                ),
                                onChanged: (value) {
                                  _query.value = value;
                                  _highlightedIndex.value = 0;
                                },
                                onSubmitted: (_) => _selectAt(
                                  filtered,
                                  _highlightedIndex.value,
                                ),
                              ),
                            ),
                            if (query.isNotEmpty)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _queryController.clear();
                                  _query.value = '';
                                },
                                child: Icon(
                                  AgoraIcons.x_mark,
                                  size: tokens.iconSize.sm,
                                  color: colors.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: filtered.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: tokens.spacing.sm,
                                    vertical: tokens.spacing.sm,
                                  ),
                                  child: AppText.bodySm(
                                    widget.emptyText,
                                    color: colors.mutedForeground,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                    vertical: tokens.spacing.xxs,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final item = filtered[index];
                                    final selected = widget.multiple
                                        ? widget.values.contains(item.value)
                                        : item.value == widget.value;
                                    return AppDropdownOptionRow(
                                      label: item.label,
                                      leadingIcon: item.icon,
                                      enabled: item.enabled,
                                      multiSelect: widget.multiple,
                                      selected: selected,
                                      highlighted: index == highlighted,
                                      onTap: item.enabled
                                          ? () => _selectAt(filtered, index)
                                          : null,
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
