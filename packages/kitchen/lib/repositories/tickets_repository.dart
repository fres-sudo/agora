import 'package:result/result.dart';

import '../models/ticket.dart';
import '../models/ticket_status.dart';

/// Repository interface for kitchen ticket operations.
abstract interface class TicketsRepository {
  /// Watches every open ticket routed to [station], derived from order
  /// items rather than a separate tickets table
  /// (docs/features/02-kitchen-ticket-routing.md).
  Stream<List<Ticket>> watchTicketsForStation(String station);

  /// Advances every item of the ticket for [orderId]/[station] to
  /// [newStatus] as one unit. Syncs the change over LAN if the order is
  /// paired (has a `syncId`) — a no-op sync-wise otherwise.
  Future<Result<void>> advanceTicket({
    required int orderId,
    required String station,
    required TicketStatus newStatus,
  });
}
