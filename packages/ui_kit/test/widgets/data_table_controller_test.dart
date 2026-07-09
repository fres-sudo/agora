import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('DataTableController pagination', () {
    test('clamps currentPage when totalItems shrinks', () {
      final controller = DataTableController<int>(rowsPerPage: 10);
      controller.totalItems = 25; // 3 pages (0, 1, 2)
      controller.currentPage = 2;

      controller.totalItems = 15; // now 2 pages (0, 1)

      expect(controller.currentPage, 1);
    });

    test('resets currentPage to 0 when totalItems drops to 0 '
        '(e.g. last item on last page deleted)', () {
      final controller = DataTableController<int>(rowsPerPage: 10);
      controller.totalItems = 1;
      controller.currentPage = 0;

      controller.totalItems = 0;

      expect(controller.currentPage, 0);
      expect(controller.totalPages, 0);
    });

    test('stays on page 0 when totalItems goes from 0 to 0', () {
      final controller = DataTableController<int>(rowsPerPage: 10);

      controller.totalItems = 0;

      expect(controller.currentPage, 0);
    });

    test('does not change currentPage when it is already in range', () {
      final controller = DataTableController<int>(rowsPerPage: 10);
      controller.totalItems = 25;
      controller.currentPage = 1;

      controller.totalItems = 30; // still enough pages for page 1

      expect(controller.currentPage, 1);
    });
  });
}
