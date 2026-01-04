import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

enum OrderStatus {
  pending(0),
  completed(1),
  voided(2);

  final int value;

  const OrderStatus(this.value);
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    required int? id, // Null if it's a new cart not yet saved to DB
    required DateTime createdAt,
    required OrderStatus status,
    required List<OrderLineItem> items,
    required String? note,

    // Financials
    required int subtotalCents,
    required int taxCents,
    required int discountCents,
    required int grandTotalCents,
  }) = _Order;

  const Order._();
}
