part of 'tickets_bloc.dart';

@freezed
sealed class TicketsEvent with _$TicketsEvent {
  /// Start watching tickets for [station] — this device's configured
  /// station (docs/features/02-kitchen-ticket-routing.md).
  const factory TicketsEvent.started({required String station}) = _Started;

  /// Advance one ticket to its next status.
  const factory TicketsEvent.advanced({
    required int orderId,
    required String station,
    required TicketStatus newStatus,
  }) = _Advanced;
}
