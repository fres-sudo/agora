import 'package:flutter/material.dart';

/// How much a column matters when the table collapses into cards on a phone.
///
/// A phone card has room for roughly a title, a supporting line and a trailing
/// value — everything else has to go. Tagging columns here is what lets one
/// generic card renderer serve every table in the app.
enum DataTableColumnPriority {
  /// The row's identity — rendered as the card's title. Exactly one column per
  /// table should claim this; the first one wins.
  primary,

  /// Supporting detail — rendered on the card's subtitle line.
  secondary,

  /// The row's headline value (price, total, quantity) — rendered on the
  /// card's trailing edge.
  trailing,

  /// Dropped entirely on phones. The default for anything unlabelled, since
  /// most desktop tables carry more columns than a card can hold.
  hidden,
}

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
  ///
  /// The [BuildContext] belongs to the cell itself. This matters because table
  /// rows are built lazily by a scroll view, potentially after the page that
  /// declared the column has completed its build. It is safe to use for
  /// inherited-state subscriptions such as `context.select`.
  final Widget Function(BuildContext context, T item) cellBuilder;

  /// Where this column lands when the table renders as cards on a phone.
  final DataTableColumnPriority priority;

  /// Whether to prefix the value with [label] on the phone card. Useful for
  /// figures that are ambiguous without their header ("12" vs "Stock 12").
  final bool showLabelOnMobile;

  const DataTableColumn({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.width,
    this.flex = 1,
    this.sortable = false,
    this.alignment = Alignment.centerLeft,
    this.priority = DataTableColumnPriority.hidden,
    this.showLabelOnMobile = false,
  });
}
