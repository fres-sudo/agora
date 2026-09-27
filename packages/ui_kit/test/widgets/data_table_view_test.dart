import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  testWidgets('row action icons align with the menu left inset', (
    tester,
  ) async {
    await tester.pumpComponent(
      DataTableView<int>(
        items: const [1],
        columns: [
          DataTableColumn<int>(
            id: 'item',
            label: 'Item',
            cellBuilder: (context, item) => Text('Item $item'),
          ),
        ],
        config: const DataTableConfig(title: 'Items'),
        showAddButton: false,
      ),
    );

    await tester.tap(find.byIcon(AgoraIcons.dots_horizontal));
    await tester.pumpAndSettle();

    final editRow = tester.widget<Row>(
      find.ancestor(
        of: find.text('Edit'),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.children.any(
                (child) => child is Icon && child.icon == AgoraIcons.pencil,
              ),
        ),
      ),
    );
    final deleteRow = tester.widget<Row>(
      find.ancestor(
        of: find.text('Delete'),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.children.any(
                (child) => child is Icon && child.icon == AgoraIcons.trash,
              ),
        ),
      ),
    );

    expect(editRow.children.first, isA<Icon>());
    expect(deleteRow.children.first, isA<Icon>());
  });
}
