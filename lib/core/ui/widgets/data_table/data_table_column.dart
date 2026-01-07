import 'package:flutter/material.dart';

/// Defines a column in the data table.
///
/// Each column specifies how to render a cell for a given item of type [T].
class DataTableColumn<T> {
  /// Unique identifier for this column.
  final String id;

  /// Display label shown in the column header.
  final String label;

  /// Optional fixed width for the column.
  /// If null, the column will flex to fill available space.
  final double? width;

  /// Flex factor for the column when width is not specified.
  /// Higher values give more space to the column.
  final int flex;

  /// Whether this column can be used for sorting.
  final bool sortable;

  /// Alignment for the column content.
  final AlignmentGeometry alignment;

  /// Builder function that creates the cell widget for a given item.
  final Widget Function(T item) cellBuilder;

  const DataTableColumn({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.width,
    this.flex = 1,
    this.sortable = false,
    this.alignment = Alignment.centerLeft,
  });
}
