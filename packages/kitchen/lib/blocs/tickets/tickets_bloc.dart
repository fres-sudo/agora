import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:result/result.dart';

import '../../models/ticket.dart';
import '../../models/ticket_status.dart';
import '../../repositories/tickets_repository.dart';

part 'tickets_bloc.freezed.dart';
part 'tickets_event.dart';
part 'tickets_state.dart';

sealed class TicketsEffect {
  const TicketsEffect();
}

final class TicketsShowError extends TicketsEffect {
  const TicketsShowError(this.message);
  final String message;
}

/// BLoC for a single station's live ticket queue.
class TicketsBloc
    extends EffectBloc<TicketsEvent, TicketsState, TicketsEffect> {
  TicketsBloc({required TicketsRepository ticketsRepository})
    : _ticketsRepository = ticketsRepository,
      super(const TicketsState.initial()) {
    on<_Started>(_onStarted);
    on<_Advanced>(_onAdvanced);
  }

  final TicketsRepository _ticketsRepository;
  StreamSubscription<List<Ticket>>? _subscription;

  Future<void> _onStarted(_Started event, Emitter<TicketsState> emit) async {
    emit(const TicketsState.loading());
    await _subscription?.cancel();
    _subscription = _ticketsRepository
        .watchTicketsForStation(event.station)
        .listen(
          (tickets) {
            if (!isClosed) {
              // ignore: invalid_use_of_visible_for_testing_member
              emit(
                TicketsState.loaded(tickets: tickets, station: event.station),
              );
            }
          },
          onError: (error) {
            if (!isClosed) {
              // ignore: invalid_use_of_visible_for_testing_member
              emit(
                TicketsState.error(
                  message: error.toString(),
                  previousState: state is TicketsLoaded
                      ? state as TicketsLoaded
                      : null,
                ),
              );
            }
          },
        );
  }

  Future<void> _onAdvanced(_Advanced event, Emitter<TicketsState> emit) async {
    final result = await _ticketsRepository.advanceTicket(
      orderId: event.orderId,
      station: event.station,
      newStatus: event.newStatus,
    );

    result.when(
      success: (_) {
        // Stream will update automatically.
      },
      error: (error) {
        emitEffect(
          TicketsShowError('Failed to advance ticket: ${error.toString()}'),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension TicketsBlocExtension on BuildContext {
  TicketsBloc get ticketsBloc => read<TicketsBloc>();
  TicketsBloc get watchTicketsBloc => watch<TicketsBloc>();
}
