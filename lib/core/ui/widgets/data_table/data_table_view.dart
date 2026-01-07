import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_column.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_config.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_controller.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_header.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_empty_state.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_loading_state.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_pagination.dart';

/// Row action types for the data table.
enum DataTableRowAction { edit, delete }

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
///       cellBuilder: (item) => Text(item.name),
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
    this.onSearch,
    this.onSort,
    this.onFilter,
    this.onAdd,
    this.onRowTap,
    this.onRowAction,
    this.filterDialogBuilder,
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
    // Update total items count
    _controller.totalItems = widget.items.length;
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

    return Container(
      margin: const EdgeInsets.all(Sizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.md),
        border: Border.all(color: AppColors.neutral200),
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
            onAdd: widget.onAdd,
          ),
          // Divider
          const Divider(height: 1, color: AppColors.neutral200),
          // Content
          Expanded(
            child: widget.isLoading
                ? DataTableLoadingState(
                    columnCount: widget.columns.length,
                  )
                : widget.items.isEmpty
                    ? DataTableEmptyState(
                        title: widget.config.emptyStateTitle,
                        subtitle: widget.config.emptyStateSubtitle,
                        icon: widget.config.emptyStateIcon,
                      )
                    : _buildTable(),
          ),
          // Pagination (only show if there are items)
          if (!widget.isLoading && widget.items.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.neutral200),
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

  Widget _buildTable() {
    return Column(
      children: [
        // Column headers
        _buildColumnHeaders(),
        // Data rows
        Expanded(
          child: ListView.builder(
            itemCount: _paginatedItems.length,
            itemBuilder: (context, index) => _buildDataRow(_paginatedItems[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeaders() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.lg,
        vertical: Sizes.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.neutral50,
        border: Border(
          bottom: BorderSide(color: AppColors.neutral200),
        ),
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
            return Expanded(
              flex: column.flex,
              child: _buildHeaderCell(column),
            );
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
              color: AppColors.neutral500,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  Widget _buildDataRow(T item) {
    return InkWell(
      onTap: widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.lg,
          vertical: Sizes.md,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.neutral200),
          ),
        ),
        child: Row(
          children: [
            ...widget.columns.map((column) {
              if (column.width != null) {
                return SizedBox(
                  width: column.width,
                  child: Align(
                    alignment: column.alignment,
                    child: column.cellBuilder(item),
                  ),
                );
              }
              return Expanded(
                flex: column.flex,
                child: Align(
                  alignment: column.alignment,
                  child: column.cellBuilder(item),
                ),
              );
            }),
            // Row actions menu
            SizedBox(
              width: 48,
              child: PopupMenuButton<DataTableRowAction>(
                onSelected: (action) => widget.onRowAction?.call(item, action),
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.neutral500,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: DataTableRowAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: Sizes.sm),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: DataTableRowAction.delete,
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.error500,
                        ),
                        SizedBox(width: Sizes.sm),
                        Text(
                          'Delete',
                          style: TextStyle(color: AppColors.error500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
