import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Phone rendering of [DataTableView]'s rows: one card per item instead of a
/// horizontally cramped grid.
///
/// The card is derived from the same [DataTableColumn] list the desktop table
/// uses, routed by [DataTableColumnPriority] — so a feature adds phone support
/// by tagging its columns, not by writing a second widget. Tables whose data
/// doesn't fit that shape can bypass it with `DataTableView.mobileCardBuilder`.
class DataTableMobileList<T> extends StatelessWidget {
  const DataTableMobileList({
    super.key,
    required this.items,
    required this.columns,
    this.onRowTap,
    this.rowActionsBuilder,
    this.cardBuilder,
  });

  final List<T> items;
  final List<DataTableColumn<T>> columns;
  final ValueChanged<T>? onRowTap;

  /// Builds the trailing overflow menu for a row, if any.
  final Widget Function(T item)? rowActionsBuilder;

  /// Full override of the card body for tables the generic layout doesn't suit.
  final Widget Function(BuildContext context, T item)? cardBuilder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return ListView.separated(
      padding: EdgeInsets.all(tokens.spaceMd),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: tokens.spaceSm),
      itemBuilder: (context, index) {
        final item = items[index];
        return _MobileRowCard<T>(
          item: item,
          columns: columns,
          onTap: onRowTap == null ? null : () => onRowTap!(item),
          actions: rowActionsBuilder?.call(item),
          cardBuilder: cardBuilder,
        );
      },
    );
  }
}

class _MobileRowCard<T> extends StatelessWidget {
  const _MobileRowCard({
    required this.item,
    required this.columns,
    required this.onTap,
    required this.actions,
    required this.cardBuilder,
  });

  final T item;
  final List<DataTableColumn<T>> columns;
  final VoidCallback? onTap;
  final Widget? actions;
  final Widget Function(BuildContext context, T item)? cardBuilder;

  DataTableColumn<T>? _first(DataTableColumnPriority priority) =>
      columns.where((c) => c.priority == priority).firstOrNull;

  List<DataTableColumn<T>> _all(DataTableColumnPriority priority) =>
      columns.where((c) => c.priority == priority).toList();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = context.colors;

    return Material(
      color: colors.card,
      borderRadius: tokens.borderRadiusSm,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(tokens.spaceMd),
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.border,
              width: tokens.borderHairline,
            ),
            borderRadius: tokens.borderRadiusSm,
          ),
          child: cardBuilder != null
              ? cardBuilder!(context, item)
              : _buildDefaultCard(context),
        ),
      ),
    );
  }

  Widget _buildDefaultCard(BuildContext context) {
    final tokens = context.tokens;
    final primary = _first(DataTableColumnPriority.primary);
    final secondaries = _all(DataTableColumnPriority.secondary);
    final trailing = _all(DataTableColumnPriority.trailing);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (primary != null) primary.cellBuilder(context, item),
              if (secondaries.isNotEmpty) ...[
                SizedBox(height: tokens.spaceXs),
                Wrap(
                  spacing: tokens.spaceSm,
                  runSpacing: tokens.spaceXs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final column in secondaries)
                      _LabelledCell<T>(column: column, item: item),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (trailing.isNotEmpty) ...[
          SizedBox(width: tokens.spaceSm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < trailing.length; i++) ...[
                if (i > 0) SizedBox(height: tokens.spaceXs),
                _LabelledCell<T>(column: trailing[i], item: item),
              ],
            ],
          ),
        ],
        if (actions != null) actions!,
      ],
    );
  }
}

/// A cell optionally prefixed with its column label, for values that don't
/// stand on their own outside a table header.
class _LabelledCell<T> extends StatelessWidget {
  const _LabelledCell({required this.column, required this.item});

  final DataTableColumn<T> column;
  final T item;

  @override
  Widget build(BuildContext context) {
    final cell = column.cellBuilder(context, item);
    if (!column.showLabelOnMobile) return cell;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.caption(
          '${column.label}: ',
          color: context.colors.mutedForeground,
        ),
        cell,
      ],
    );
  }
}
