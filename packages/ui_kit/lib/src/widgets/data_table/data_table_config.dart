import 'package:flutter/material.dart';

/// Sort direction for data table sorting.
enum SortDirection { ascending, descending }

/// Represents a sort option available in the sort menu.
class SortOption {
  /// Unique identifier for this sort option.
  final String id;

  /// Display label shown in the sort menu.
  final String label;

  /// Current sort direction.
  final SortDirection direction;

  const SortOption({
    required this.id,
    required this.label,
    this.direction = SortDirection.ascending,
  });

  SortOption copyWith({
    String? id,
    String? label,
    SortDirection? direction,
  }) {
    return SortOption(
      id: id ?? this.id,
      label: label ?? this.label,
      direction: direction ?? this.direction,
    );
  }

  /// Returns a new SortOption with toggled direction.
  SortOption toggleDirection() {
    return copyWith(
      direction: direction == SortDirection.ascending
          ? SortDirection.descending
          : SortDirection.ascending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Configuration for the data table view.
///
/// Contains all the text labels, hints, and options for customizing
/// the table's appearance and behavior.
class DataTableConfig {
  /// Title displayed in the header.
  final String title;

  /// Placeholder text for the search field.
  final String searchHint;

  /// Label for the add button.
  final String addButtonLabel;

  /// Title shown in the empty state.
  final String emptyStateTitle;

  /// Subtitle shown in the empty state.
  final String emptyStateSubtitle;

  /// Icon shown in the empty state.
  final IconData emptyStateIcon;

  /// Title for the delete confirmation dialog.
  final String deleteDialogTitle;

  /// Message for the delete confirmation dialog.
  final String deleteDialogMessage;

  /// Available sort options.
  final List<SortOption> sortOptions;

  /// Number of rows per page options.
  final List<int> rowsPerPageOptions;

  /// Default rows per page.
  final int defaultRowsPerPage;

  const DataTableConfig({
    required this.title,
    this.searchHint = 'Search...',
    this.addButtonLabel = 'Add',
    this.emptyStateTitle = 'No Data Found',
    this.emptyStateSubtitle = 'Try adjusting your search or filters',
    this.emptyStateIcon = Icons.search_off_rounded,
    this.deleteDialogTitle = 'Delete Item?',
    this.deleteDialogMessage =
        'Are you sure you want to delete this item? This action cannot be undone.',
    this.sortOptions = const [],
    this.rowsPerPageOptions = const [10, 25, 50],
    this.defaultRowsPerPage = 10,
  });

  DataTableConfig copyWith({
    String? title,
    String? searchHint,
    String? addButtonLabel,
    String? emptyStateTitle,
    String? emptyStateSubtitle,
    IconData? emptyStateIcon,
    String? deleteDialogTitle,
    String? deleteDialogMessage,
    List<SortOption>? sortOptions,
    List<int>? rowsPerPageOptions,
    int? defaultRowsPerPage,
  }) {
    return DataTableConfig(
      title: title ?? this.title,
      searchHint: searchHint ?? this.searchHint,
      addButtonLabel: addButtonLabel ?? this.addButtonLabel,
      emptyStateTitle: emptyStateTitle ?? this.emptyStateTitle,
      emptyStateSubtitle: emptyStateSubtitle ?? this.emptyStateSubtitle,
      emptyStateIcon: emptyStateIcon ?? this.emptyStateIcon,
      deleteDialogTitle: deleteDialogTitle ?? this.deleteDialogTitle,
      deleteDialogMessage: deleteDialogMessage ?? this.deleteDialogMessage,
      sortOptions: sortOptions ?? this.sortOptions,
      rowsPerPageOptions: rowsPerPageOptions ?? this.rowsPerPageOptions,
      defaultRowsPerPage: defaultRowsPerPage ?? this.defaultRowsPerPage,
    );
  }
}
