import 'package:bloc_exports/bloc_exports.dart';

import 'ticket_status.dart';

part 'ticket.freezed.dart';

/// A single line within a [Ticket] — one order item routed to this station.
@freezed
abstract class TicketItem with _$TicketItem {
  const factory TicketItem({
    required int orderItemId,
    required String productName,
    required int quantity,
    @Default([]) List<String> modifiers,
  }) = _TicketItem;

  const TicketItem._();
}

/// A kitchen ticket: every item from one order that shares one prep station,
/// advanced together as a single unit
/// (docs/features/02-kitchen-ticket-routing.md — "a ticket = all order items
/// in one order that share one station").
@freezed
abstract class Ticket with _$Ticket {
  const factory Ticket({
    required int orderId,
    String? orderSyncId,
    required String orderNumber,
    required String station,
    required DateTime createdAt,
    required TicketStatus status,
    required List<TicketItem> items,
  }) = _Ticket;

  const Ticket._();
}
