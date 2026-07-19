import 'package:order_management/order_management.dart';
import 'package:printing/printing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Order buildOrder(List<OrderLineItem> items) {
    return Order(
      id: 42,
      createdAt: DateTime(2026, 1, 1),
      status: OrderStatus.completed,
      items: items,
      note: null,
      subtotalCents: 1000,
      taxCents: 0,
      discountCents: 0,
      grandTotalCents: 1000,
    );
  }

  group('OrderReceiptMapper.toReceipt — combo grouping '
      '(docs/features/03-combo-modifier-pricing.md)', () {
    test('groups fanned-out combo rows sharing a comboLineId back into one '
        'ReceiptLine, with every constituent (including the lead row\'s own '
        'product) listed as a breakdown sub-line, since the line\'s display '
        'name is the combo name, not the lead product\'s name', () {
      final order = buildOrder(const [
        OrderLineItem(
          id: 101,
          productId: 10,
          productName: 'Panino',
          quantity: 1,
          unitPriceCents: 1000,
          selectedModifiers: [],
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
          comboSaleQuantity: 1,
        ),
        OrderLineItem(
          id: 102,
          productId: 11,
          productName: 'Patatine',
          quantity: 1,
          unitPriceCents: 0,
          selectedModifiers: [],
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
        ),
        OrderLineItem(
          id: 103,
          productId: 12,
          productName: 'Bibita',
          quantity: 1,
          unitPriceCents: 0,
          selectedModifiers: [],
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
        ),
      ]);

      final receipt = order.toReceipt(const ReceiptConfig());

      expect(receipt.lines, hasLength(1));
      final line = receipt.lines.single;
      expect(line.name, 'Menu Completo');
      expect(line.quantity, 1);
      expect(line.unitPriceCents, 1000);
      expect(line.modifiers, ['1x Panino', '1x Patatine', '1x Bibita']);
    });

    test('leaves non-combo lines untouched, mixed with a combo line', () {
      final order = buildOrder(const [
        OrderLineItem(
          id: 1,
          productId: 5,
          productName: 'Acqua',
          quantity: 2,
          unitPriceCents: 100,
          selectedModifiers: [],
        ),
        OrderLineItem(
          id: 101,
          productId: 10,
          productName: 'Panino',
          quantity: 1,
          unitPriceCents: 1000,
          selectedModifiers: [],
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
          comboSaleQuantity: 1,
        ),
        OrderLineItem(
          id: 102,
          productId: 11,
          productName: 'Patatine',
          quantity: 1,
          unitPriceCents: 0,
          selectedModifiers: [],
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
        ),
      ]);

      final receipt = order.toReceipt(const ReceiptConfig());

      expect(receipt.lines, hasLength(2));
      expect(receipt.lines.first.name, 'Acqua');
      expect(receipt.lines.last.name, 'Menu Completo');
    });
  });

  group('OrderReceiptMapper.toStationTickets — combo constituents stay '
      'per-station, not grouped', () {
    test('routes each combo constituent to its own station ticket '
        'independently of its siblings', () {
      final order = buildOrder(const [
        OrderLineItem(
          id: 101,
          productId: 10,
          productName: 'Panino',
          quantity: 1,
          unitPriceCents: 1000,
          selectedModifiers: [],
          prepStation: 'Griglia',
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
          comboSaleQuantity: 1,
        ),
        OrderLineItem(
          id: 102,
          productId: 11,
          productName: 'Patatine',
          quantity: 1,
          unitPriceCents: 0,
          selectedModifiers: [],
          prepStation: 'Fritti',
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
        ),
        OrderLineItem(
          id: 103,
          productId: 12,
          productName: 'Bibita',
          quantity: 1,
          unitPriceCents: 0,
          selectedModifiers: [],
          // No prepStation — never ticketed.
          comboId: 1,
          comboName: 'Menu Completo',
          comboLineId: 101,
        ),
      ]);

      final tickets = order.toStationTickets();

      expect(tickets, hasLength(2));
      final byStore = {for (final t in tickets) t.storeName: t};
      expect(byStore['GRIGLIA']!.lines.single.name, 'Panino');
      expect(byStore['FRITTI']!.lines.single.name, 'Patatine');
    });
  });
}
