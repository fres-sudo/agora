part of 'tickets_bloc.dart';

@freezed
class TicketsState with _$TicketsState {
  const TicketsState._();

  /// Initial state, before a station has been chosen.
  const factory TicketsState.initial() = _Initial;

  /// Loading tickets for a station.
  const factory TicketsState.loading() = _Loading;

  /// Loaded with this station's open tickets.
  const factory TicketsState.loaded({
    required List<Ticket> tickets,
    required String station,
  }) = TicketsLoaded;

  /// Error state.
  const factory TicketsState.error({
    required String message,
    TicketsLoaded? previousState,
  }) = _Error;

  /// Returns tickets if loaded.
  List<Ticket> get tickets => maybeMap(
    loaded: (s) => s.tickets,
    error: (s) => s.previousState?.tickets ?? [],
    orElse: () => [],
  );
}
