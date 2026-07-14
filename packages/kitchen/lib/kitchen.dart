/// Shared kitchen-ticket domain — models, repository interface, and the
/// station ticket-queue BLoC.
///
/// Lives in `packages/` because it is consumed by `feature_kitchen` (which
/// supplies the concrete `TicketsRepositoryImpl`) and, in future, other
/// order-completion-adjacent features
/// (docs/features/02-kitchen-ticket-routing.md).
library;

export 'models/ticket.dart';
export 'models/ticket_status.dart';
export 'repositories/tickets_repository.dart';
export 'blocs/tickets/tickets_bloc.dart';
