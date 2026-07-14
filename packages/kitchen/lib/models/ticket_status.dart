/// The lifecycle of a kitchen ticket, matching the existing `ClockRecord`
/// style of a simple, linear state machine — no timers, no anomaly
/// detection (docs/features/02-kitchen-ticket-routing.md scopes that out).
enum TicketStatus {
  pending,
  inProgress,
  ready,
  bumped;

  /// The status reached by tapping "advance" on a ticket in [pending],
  /// [inProgress] or [ready]. Returns `null` once [bumped] — there is
  /// nowhere further to advance to.
  TicketStatus? get next => switch (this) {
    TicketStatus.pending => TicketStatus.inProgress,
    TicketStatus.inProgress => TicketStatus.ready,
    TicketStatus.ready => TicketStatus.bumped,
    TicketStatus.bumped => null,
  };
}
