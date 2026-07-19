import 'dart:async';

import 'package:result/result.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:catalog/models/combo.dart';
import 'package:catalog/repositories/combos_repository.dart';

part 'combos_bloc.freezed.dart';
part 'combos_event.dart';
part 'combos_state.dart';

sealed class CombosEffect {
  const CombosEffect();
}

final class CombosShowError extends CombosEffect {
  const CombosShowError(this.message);
  final String message;
}

/// BLoC for managing combos with real-time updates.
class CombosBloc extends EffectBloc<CombosEvent, CombosState, CombosEffect> {
  CombosBloc({required CombosRepository combosRepository})
    : _combosRepository = combosRepository,
      super(const CombosState.initial()) {
    on<_Started>(_onStarted);
    on<_Created>(_onCreated);
    on<_Updated>(_onUpdated);
    on<_Deleted>(_onDeleted);
  }

  final CombosRepository _combosRepository;

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<CombosState> emit) async {
    emit(const CombosState.loading());

    await emit.forEach<List<Combo>>(
      _combosRepository.watchAllCombos(),
      onData: (combos) => CombosState.loaded(combos: combos),
      onError: (error, stackTrace) => CombosState.error(
        message: error.toString(),
        previousState: state is CombosLoaded ? state as CombosLoaded : null,
      ),
    );
  }

  Future<void> _onCreated(_Created event, Emitter<CombosState> emit) async {
    final result = await _combosRepository.createCombo(event.combo);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(
          CombosShowError('Failed to create combo: ${error.toString()}'),
        );
      },
    );
  }

  Future<void> _onUpdated(_Updated event, Emitter<CombosState> emit) async {
    final result = await _combosRepository.updateCombo(event.combo);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(
          CombosShowError('Failed to update combo: ${error.toString()}'),
        );
      },
    );
  }

  Future<void> _onDeleted(_Deleted event, Emitter<CombosState> emit) async {
    final result = await _combosRepository.deleteCombo(event.id);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(
          CombosShowError('Failed to delete combo: ${error.toString()}'),
        );
      },
    );
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension CombosBlocExtension on BuildContext {
  CombosBloc get combosBloc => read<CombosBloc>();
  CombosBloc get watchCombosBloc => watch<CombosBloc>();
}
