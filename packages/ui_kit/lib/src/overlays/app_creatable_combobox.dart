import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/overlays/app_combobox.dart' show AppComboboxItem;
import 'package:ui_kit/src/overlays/app_dropdown_field.dart';
import 'package:ui_kit/src/overlays/app_dropdown_option_row.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';
import 'package:ui_kit/src/widgets/app_snack_bar.dart';

enum _PendingCreateStatus { pending, committed, failed }

class _PendingCreate<T> {
  _PendingCreate({required this.query, required this.optimisticValue});

  final String query;
  final T optimisticValue;
  _PendingCreateStatus status = _PendingCreateStatus.pending;
}

/// A shadcn-faithful creatable combobox: lets the user type a value that
/// isn't in [items] and create it inline, with an optimistic-update flow —
/// the new option appears selected immediately while [onCreate] runs in the
/// background, and rolls back to the previous value on failure.
///
/// Single-select only for v1 (a multi-select creatable combobox would be an
/// additive extension). Only one create can be in flight at a time; the
/// "Create" row is hidden while one is pending.
///
/// Accessibility: failures are surfaced via [showAppSnackBar] rather than an
/// inline caption, since the popover has already closed by the time the
/// failure is known — there's no popover host left to show it in.
class AppCreatableCombobox<T> extends StatefulWidget {
  const AppCreatableCombobox({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.onCreate,
    required this.optimisticValueBuilder,
    this.createLabelBuilder,
    this.canCreate,
    this.onCreateError,
    this.createErrorMessage = 'Could not create item. Please try again.',
    this.placeholder,
    this.searchHint = 'Search…',
    this.emptyText = 'No results found.',
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
  });

  final List<AppComboboxItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;

  /// Persists the new item; must resolve to the real created value.
  final Future<T> Function(String query) onCreate;

  /// Builds a provisional value shown as selected immediately, before
  /// [onCreate] resolves.
  final T Function(String query) optimisticValueBuilder;

  final String Function(String query)? createLabelBuilder;

  /// Whether the "Create" row should show for the trimmed query; defaults to
  /// disallowing blank queries and queries that already match an item's
  /// label (case-insensitively).
  final bool Function(String query)? canCreate;
  final void Function(Object error, StackTrace stackTrace)? onCreateError;
  final String createErrorMessage;

  final String? placeholder;
  final String searchHint;
  final String emptyText;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  @override
  State<AppCreatableCombobox<T>> createState() =>
      _AppCreatableComboboxState<T>();
}

class _AppCreatableComboboxState<T> extends State<AppCreatableCombobox<T>> {
  final AppPopoverController _controller = AppPopoverController();
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(
    debugLabel: 'AppCreatableCombobox search',
  );
  final ValueNotifier<String> _query = ValueNotifier('');
  final ValueNotifier<int> _highlightedIndex = ValueNotifier(0);

  _PendingCreate<T>? _pending;

  @override
  void dispose() {
    _controller.dispose();
    _queryController.dispose();
    _searchFocusNode.dispose();
    _query.dispose();
    _highlightedIndex.dispose();
    super.dispose();
  }

  List<AppComboboxItem<T>> get _displayItems {
    final pending = _pending;
    if (pending == null || pending.status != _PendingCreateStatus.pending) {
      return widget.items;
    }
    return [
      ...widget.items,
      AppComboboxItem<T>(value: pending.optimisticValue, label: pending.query),
    ];
  }

  List<AppComboboxItem<T>> _filtered(String query) {
    final items = _displayItems;
    if (query.isEmpty) return items;
    final lower = query.toLowerCase();
    return [
      for (final item in items)
        if (item.searchKey.toLowerCase().contains(lower)) item,
    ];
  }

  bool _defaultCanCreate(String query) {
    if (query.isEmpty) return false;
    final lower = query.toLowerCase();
    return !widget.items.any((item) => item.label.toLowerCase() == lower);
  }

  void _handleOpen() {
    _queryController.clear();
    _query.value = '';
    _highlightedIndex.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.isOpen) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _selectItem(T value) {
    widget.onChanged(value);
    _controller.close();
  }

  void _activateCreate(String rawQuery) {
    final query = rawQuery.trim();
    if (_pending != null) return;

    final previousValue = widget.value;
    final optimistic = widget.optimisticValueBuilder(query);
    final pending = _PendingCreate<T>(
      query: query,
      optimisticValue: optimistic,
    );

    setState(() => _pending = pending);
    widget.onChanged(optimistic);
    _controller.close();

    widget
        .onCreate(query)
        .then(
          (real) {
            if (!mounted) return;
            setState(() {
              pending.status = _PendingCreateStatus.committed;
              _pending = null;
            });
            if (widget.value == optimistic) {
              widget.onChanged(real);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!mounted) return;
            setState(() {
              pending.status = _PendingCreateStatus.failed;
              _pending = null;
            });
            if (widget.value == optimistic) {
              widget.onChanged(previousValue);
            }
            widget.onCreateError?.call(error, stackTrace);
            showAppSnackBar(context, widget.createErrorMessage, isError: true);
          },
        );
  }

  void _moveHighlight(int count, int delta) {
    if (count == 0) return;
    var next = _highlightedIndex.value;
    next = (next + delta) % count;
    if (next < 0) next += count;
    _highlightedIndex.value = next;
  }

  @override
  Widget build(BuildContext context) {
    return AppPopoverAnchor(
      controller: _controller,
      autoFocusContent: false,
      onOpen: _handleOpen,
      triggerBuilder: (triggerContext, controller) {
        final colors = triggerContext.colors;
        AppComboboxItem<T>? selected;
        for (final item in _displayItems) {
          if (item.value == widget.value) {
            selected = item;
            break;
          }
        }

        return AppDropdownField(
          label: widget.label,
          helperText: widget.helperText,
          errorText: widget.errorText,
          enabled: widget.enabled,
          isOpen: controller.isOpen,
          onTap: widget.enabled ? controller.toggle : null,
          semanticsValue: selected?.label,
          child: selected == null
              ? AppText.body(
                  widget.placeholder ?? '',
                  color: colors.mutedForeground,
                )
              : AppText.body(selected.label),
        );
      },
      contentBuilder: (contentContext, controller) {
        final tokens = contentContext.tokens;
        final colors = contentContext.colors;
        final typography = contentContext.typography;

        return ValueListenableBuilder<String>(
          valueListenable: _query,
          builder: (context, query, _) {
            final trimmed = query.trim();
            final filtered = _filtered(query);
            final showCreate =
                _pending == null &&
                (widget.canCreate ?? _defaultCanCreate)(trimmed);
            final optionCount = filtered.length + (showCreate ? 1 : 0);

            return ValueListenableBuilder<int>(
              valueListenable: _highlightedIndex,
              builder: (context, highlighted, _) {
                return Focus(
                  onKeyEvent: (node, event) {
                    if (event is! KeyDownEvent) return KeyEventResult.ignored;
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      _moveHighlight(optionCount, 1);
                      return KeyEventResult.handled;
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      _moveHighlight(optionCount, -1);
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
                              width: tokens.borderHairline,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.spaceSm,
                          vertical: tokens.spaceXs,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              AgoraIcons.search,
                              size: tokens.iconSm,
                              color: colors.mutedForeground,
                            ),
                            SizedBox(width: tokens.spaceXs),
                            Expanded(
                              child: TextField(
                                controller: _queryController,
                                focusNode: _searchFocusNode,
                                enabled: _pending == null,
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
                                onSubmitted: (_) {
                                  final index = _highlightedIndex.value;
                                  if (index < filtered.length) {
                                    _selectItem(filtered[index].value);
                                  } else if (showCreate) {
                                    _activateCreate(trimmed);
                                  }
                                },
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
                                  size: tokens.iconSm,
                                  color: colors.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: optionCount == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: tokens.spaceSm,
                                    vertical: tokens.spaceSm,
                                  ),
                                  child: AppText.bodySm(
                                    widget.emptyText,
                                    color: colors.mutedForeground,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                    vertical: tokens.spaceXxs,
                                  ),
                                  itemCount: optionCount,
                                  itemBuilder: (context, index) {
                                    if (index < filtered.length) {
                                      final item = filtered[index];
                                      return AppDropdownOptionRow(
                                        label: item.label,
                                        leadingIcon: item.icon,
                                        enabled: item.enabled,
                                        selected: item.value == widget.value,
                                        highlighted: index == highlighted,
                                        onTap: item.enabled
                                            ? () => _selectItem(item.value)
                                            : null,
                                      );
                                    }
                                    final createLabel =
                                        widget.createLabelBuilder?.call(
                                          trimmed,
                                        ) ??
                                        'Create "$trimmed"';
                                    return AppDropdownOptionRow(
                                      label: createLabel,
                                      leadingIcon: AgoraIcons.plus,
                                      highlighted: index == highlighted,
                                      onTap: () => _activateCreate(trimmed),
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
