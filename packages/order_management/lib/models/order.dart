import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/models/order_type.dart';
import 'package:order_management/models/payment_status.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'order.freezed.dart';

enum OrderStatus {
  pending(0),
  completed(1),
  voided(2),
  paymentPending(3);

  final int value;

  const OrderStatus(this.value);
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    required int? id, // Null if it's a new cart not yet saved to DB
    required DateTime createdAt,
    required OrderStatus status,
    @Default(OrderType.dineIn) OrderType orderType,
    required List<OrderLineItem> items,
    required String? note,

    // Cross-station identity for LAN sync (uuid v4). Null for orders never
    // synced (pre-migration, or a station that has never paired) — see
    // OrdersTable.syncId and docs/features/01-lan-sync.md.
    String? syncId,

    // Payment
    String? paymentMethod, // "Cash", "Card", etc. Null until paid.
    String? paymentProvider,
    PaymentStatus? paymentStatus,
    String? paymentAttemptId,
    String? paymentTransactionCode,
    String? paymentError,
    // Volunteer who took the order, for shift cash reconciliation
    // (docs/features/04-volunteer-shift-accountability.md). Nullable
    // defensively — checkout shouldn't crash if session state is ever
    // momentarily absent — and never populated on orders applied from a
    // peer station via LAN sync (employee records aren't synced).
    int? employeeId,
    // Financials
    required int subtotalCents,
    required int taxCents,
    required int discountCents,
    required int grandTotalCents,
  }) = _Order;

  const Order._();
}
