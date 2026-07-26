import 'package:flutter/material.dart';
import 'package:ui_kit/src/overlays/app_dropdown_option_row.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/ui_kit.dart';

/// Row action types for the data table.
enum DataTableRowAction { edit, reprint, delete }

/// A reusable data table view component for POS applications.
///
/// Provides a complete table UI with:
/// - Header (title, search, sort, filter, add button)
/// - Column headers and data rows
/// - Pagination
/// - Empty state
/// - Loading skeleton state
///
/// Example usage:
/// ```dart
/// DataTableView<Product>(
///   items: products,
///   columns: [
///     DataTableColumn(
///       id: 'name',
///       label: 'Product Name',
///       cellBuilder: (context, item) => Text(item.name),
///     ),
///   ],
///   config: DataTableConfig(title: 'Products'),
///   controller: controller,
///   onAdd: () => print('Add clicked'),
/// )
/// ```
class DataTableView<T> extends StatefulWidget {
  const DataTableView({
    super.key,
    required this.items,
    required this.columns,
    required this.config,
    this.controller,
    this.isLoading = false,
    this.showAddButton = true,
    this.showEditAction = true,
    this.showReprintAction = false,
    this.showDeleteAction = true,
    this.onSearch,
    this.onSort,
    this.onFilter,
    this.onAdd,
    this.onRowTap,
    this.onRowAction,
    this.filterDialogBuilder,
    this.mobileCardBuilder,
  });

  /// The data items to display in the table.
  final List<T> items;

  /// Column definitions for the table.
  final List<DataTableColumn<T>> columns;

  /// Configuration for titles, labels, and options.
  final DataTableConfig config;

  /// Optional controller for managing table state.
  /// If not provided, an internal controller will be created.
  final DataTableController<T>? controller;

  /// Whether to show the loading skeleton state.
  final bool isLoading;

  /// Whether to show the add button in the header.
  final bool showAddButton;

  /// Whether to show the edit action in the row menu.
  final bool showEditAction;

  /// Whether to show the reprint action in the row menu.
  final bool showReprintAction;

  /// Whether to show the delete action in the row menu.
  final bool showDeleteAction;

  /// Callback when search query changes.
  final ValueChanged<String>? onSearch;

  /// Callback when sort option is selected.
  final ValueChanged<SortOption>? onSort;

  /// Callback when filter button is tapped.
  /// Can be used to show a custom filter dialog.
  final VoidCallback? onFilter;

  /// Callback when add button is tapped.
  final VoidCallback? onAdd;

  /// Callback when a row is tapped.
  final ValueChanged<T>? onRowTap;

  /// Callback when a row action (edit/delete) is selected.
  final void Function(T item, DataTableRowAction action)? onRowAction;

  /// Builder for custom filter dialog content.
  final Widget Function(BuildContext context)? filterDialogBuilder;

  /// Overrides the phone card body. When null, cards are derived from
  /// [columns] via [DataTableColumnPriority] — see [DataTableMobileList].
  final Widget Function(BuildContext context, T item)? mobileCardBuilder;

  @override
  State<DataTableView<T>> createState() => _DataTableViewState<T>();
}

class _DataTableViewState<T> extends State<DataTableView<T>> {
  late DataTableController<T> _controller;
  late TextEditingController _searchController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DataTableController<T>(
        rowsPerPage: widget.config.defaultRowsPerPage,
      );
      _ownsController = true;
    }
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(DataTableView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownsController) {
        _controller.dispose();
        _ownsController = false;
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
      } else {
        _controller = DataTableController<T>(
          rowsPerPage: widget.config.defaultRowsPerPage,
        );
        _ownsController = true;
      }
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  List<T> get _paginatedItems {
    final start = _controller.currentPage * _controller.rowsPerPage;
    final end = (start + _controller.rowsPerPage).clamp(0, widget.items.length);
    if (start >= widget.items.length) return [];
    return widget.items.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    // Update total items count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.totalItems != widget.items.length) {
        _controller.totalItems = widget.items.length;
      }
    });

    // On a phone the table fills the screen edge to edge: the framing card
    // would waste ~32dp of the little horizontal room there is, and the rows
    // are already individually carded.
    final isMobile = context.isMobile;

    return Container(
      margin: isMobile
          ? EdgeInsets.zero
          : EdgeInsets.all(context.tokens.spacing.md),
      decoration: isMobile
          ? BoxDecoration(color: context.colors.background)
          : BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.colors.border),
            ),
      child: Column(
        children: [
          // Header
          DataTableHeader(
            title: widget.config.title,
            searchHint: widget.config.searchHint,
            addButtonLabel: widget.config.addButtonLabel,
            sortOptions: widget.config.sortOptions,
            currentSort: _controller.currentSort,
            searchController: _searchController,
            hasActiveFilters: _controller.hasActiveFilters,
            onSearch: (query) {
              _controller.searchQuery = query;
              widget.onSearch?.call(query);
            },
            onSort: (option) {
              // If same option selected, toggle direction
              if (_controller.currentSort?.id == option.id) {
                _controller.currentSort = option.toggleDirection();
              } else {
                _controller.currentSort = option;
              }
              widget.onSort?.call(_controller.currentSort!);
            },
            onFilter: widget.onFilter,
            onAdd: widget.showAddButton ? widget.onAdd : null,
          ),
          // Divider
          Divider(height: 1, color: context.colors.border),
          // Content
          Expanded(
            child: widget.isLoading
                ? DataTableLoadingState(columnCount: widget.columns.length)
                : widget.items.isEmpty
                ? DataTableEmptyState(
                    title: widget.config.emptyStateTitle,
                    subtitle: widget.config.emptyStateSubtitle,
                    icon: widget.config.emptyStateIcon,
                  )
                : isMobile
                ? _buildMobileList()
                : _buildTable(),
          ),
          // Pagination (only show if there are items)
          if (!widget.isLoading && widget.items.isNotEmpty) ...[
            Divider(height: 1, color: context.colors.border),
            DataTablePagination(
              currentPage: _controller.currentPage,
              totalPages: _controller.totalPages,
              rowsPerPage: _controller.rowsPerPage,
              rowsPerPageOptions: widget.config.rowsPerPageOptions,
              onPageChanged: (page) => _controller.currentPage = page,
              onRowsPerPageChanged: (count) => _controller.rowsPerPage = count,
            ),
          ],
        ],
      ),
    );
  }

  bool get _hasRowActions =>
      widget.showEditAction ||
      widget.showReprintAction ||
      widget.showDeleteAction;

  Widget _buildMobileList() {
    return DataTableMobileList<T>(
      items: _paginatedItems,
      columns: widget.columns,
      onRowTap: widget.onRowTap,
      cardBuilder: widget.mobileCardBuilder,
      rowActionsBuilder: _hasRowActions
          ? (item) => _RowActionMenu(
              showEdit: widget.showEditAction,
              showReprint: widget.showReprintAction,
              showDelete: widget.showDeleteAction,
              onSelected: (action) => widget.onRowAction?.call(item, action),
            )
          : null,
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        // Column headers
        _buildColumnHeaders(),
        // Data rows
        Expanded(
          child: ListView.builder(
            itemCount: _paginatedItems.length,
            itemBuilder: (context, index) =>
                _buildDataRow(context, _paginatedItems[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeaders() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spacing.md,
        vertical: context.tokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.muted,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        children: [
          ...widget.columns.map((column) {
            if (column.width != null) {
              return SizedBox(
                width: column.width,
                child: _buildHeaderCell(column),
              );
            }
            return Expanded(flex: column.flex, child: _buildHeaderCell(column));
          }),
          // Actions column placeholder
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(DataTableColumn<T> column) {
    return Align(
      alignment: column.alignment,
      child: Text(
        column.label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: context.colors.mutedForeground,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, T item) {
    return InkWell(
      onTap: widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.tokens.spacing.md,
          vertical: context.tokens.spacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          children: [
            ...widget.columns.map((column) {
              if (column.width != null) {
                return SizedBox(
                  width: column.width,
                  child: Align(
                    alignment: column.alignment,
                    child: Builder(
                      builder: (context) => column.cellBuilder(context, item),
                    ),
                  ),
                );
              }
              return Expanded(
                flex: column.flex,
                child: Align(
                  alignment: column.alignment,
                  child: Builder(
                    builder: (context) => column.cellBuilder(context, item),
                  ),
                ),
              );
            }),
            if (_hasRowActions)
              SizedBox(
                width: 48,
                child: _RowActionMenu(
                  showEdit: widget.showEditAction,
                  showReprint: widget.showReprintAction,
                  showDelete: widget.showDeleteAction,
                  onSelected: (action) =>
                      widget.onRowAction?.call(item, action),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Row-level action menu (edit/reprint/delete) built on [AppPopoverAnchor].
class _RowActionMenu extends StatelessWidget {
  const _RowActionMenu({
    required this.showEdit,
    required this.showReprint,
    required this.showDelete,
    required this.onSelected,
  });

  final bool showEdit;
  final bool showReprint;
  final bool showDelete;
  final ValueChanged<DataTableRowAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppPopoverAnchor(
      minWidth: 160,
      triggerBuilder: (triggerContext, controller) {
        return AppIconButton.ghost(
          onPressed: controller.toggle,
          icon: Icon(
            AgoraIcons.dots_horizontal,
            color: triggerContext.colors.mutedForeground,
            size: 20,
          ),
        );
      },
      contentBuilder: (contentContext, controller) {
        void select(DataTableRowAction action) {
          onSelected(action);
          controller.close();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: contentContext.tokens.spacing.xxs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showEdit)
                AppDropdownOptionRow(
                  label: 'Edit',
                  leadingIcon: AgoraIcons.pencil,
                  onTap: () => select(DataTableRowAction.edit),
                ),
              if (showReprint)
                AppDropdownOptionRow(
                  label: 'Reprint',
                  leadingIcon: AgoraIcons.printer,
                  onTap: () => select(DataTableRowAction.reprint),
                ),
              if (showDelete)
                _DestructiveOptionRow(
                  label: 'Delete',
                  onTap: () => select(DataTableRowAction.delete),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A destructive variant of [AppDropdownOptionRow] (red icon + label), used
/// for the row menu's "Delete" entry. [AppDropdownOptionRow] itself has no
/// destructive styling hook, so this composes the same row chrome directly.
class _DestructiveOptionRow extends StatelessWidget {
  const _DestructiveOptionRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.xxs,
        vertical: tokens.spacing.xxs / 2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: tokens.radius.borderSm,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: tokens.radius.borderSm,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.sm,
              vertical: tokens.spacing.xs,
            ),
            child: Row(
              children: [
                SizedBox(width: tokens.iconSize.md),
                SizedBox(width: tokens.spacing.xs),
                Icon(
                  AgoraIcons.trash,
                  size: tokens.iconSize.sm,
                  color: colors.destructive,
                ),
                SizedBox(width: tokens.spacing.xs),
                Expanded(child: AppText.body(label, color: colors.destructive)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
