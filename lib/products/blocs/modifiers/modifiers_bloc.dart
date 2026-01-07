import 'dart:async';

import 'package:agora/core/misc/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/products/models/modifier_group/modifier_group.dart';
import 'package:agora/products/repositories/modifiers_repository.dart';

part 'modifiers_bloc.freezed.dart';
part 'modifiers_event.dart';
part 'modifiers_state.dart';

/// BLoC for managing modifier groups with real-time updates.
class ModifiersBloc extends Bloc<ModifiersEvent, ModifiersState> {
  ModifiersBloc({required ModifiersRepository modifiersRepository})
    : _modifiersRepository = modifiersRepository,
      super(const ModifiersState.initial()) {
    on<_Started>(_onStarted);
    on<_Created>(_onCreated);
    on<_Updated>(_onUpdated);
    on<_Deleted>(_onDeleted);
    on<_LinkedToProduct>(_onLinkedToProduct);
    on<_UnlinkedFromProduct>(_onUnlinkedFromProduct);
  }

  final ModifiersRepository _modifiersRepository;
  StreamSubscription<List<ModifierGroup>>? _subscription;

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<ModifiersState> emit) async {
    emit(const ModifiersState.loading());

    await _subscription?.cancel();

    _subscription = _modifiersRepository.watchAllModifiers().listen(
      (modifiers) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(ModifiersState.loaded(modifiers: modifiers));
        }
      },
      onError: (error) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(
            ModifiersState.error(
              message: error.toString(),
              previousState: state is ModifiersLoaded
                  ? state as ModifiersLoaded
                  : null,
            ),
          );
        }
      },
    );
  }

  Future<void> _onCreated(_Created event, Emitter<ModifiersState> emit) async {
    final result = await _modifiersRepository.createModifier(
      event.modifierGroup,
    );

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emit(
          ModifiersState.error(
            message: 'Failed to create modifier: ${error.toString()}',
            previousState: state is ModifiersLoaded
                ? state as ModifiersLoaded
                : null,
          ),
        );
      },
    );
  }

  Future<void> _onUpdated(_Updated event, Emitter<ModifiersState> emit) async {
    final result = await _modifiersRepository.updateModifier(
      event.modifierGroup,
    );

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emit(
          ModifiersState.error(
            message: 'Failed to update modifier: ${error.toString()}',
            previousState: state is ModifiersLoaded
                ? state as ModifiersLoaded
                : null,
          ),
        );
      },
    );
  }

  Future<void> _onDeleted(_Deleted event, Emitter<ModifiersState> emit) async {
    final result = await _modifiersRepository.deleteModifier(event.id);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emit(
          ModifiersState.error(
            message: 'Failed to delete modifier: ${error.toString()}',
            previousState: state is ModifiersLoaded
                ? state as ModifiersLoaded
                : null,
          ),
        );
      },
    );
  }

  Future<void> _onLinkedToProduct(
    _LinkedToProduct event,
    Emitter<ModifiersState> emit,
  ) async {
    final result = await _modifiersRepository.linkModifierToProduct(
      productId: event.productId,
      modifierId: event.modifierId,
    );

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emit(
          ModifiersState.error(
            message: 'Failed to link modifier: ${error.toString()}',
            previousState: state is ModifiersLoaded
                ? state as ModifiersLoaded
                : null,
          ),
        );
      },
    );
  }

  Future<void> _onUnlinkedFromProduct(
    _UnlinkedFromProduct event,
    Emitter<ModifiersState> emit,
  ) async {
    final result = await _modifiersRepository.unlinkModifierFromProduct(
      productId: event.productId,
      modifierId: event.modifierId,
    );

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emit(
          ModifiersState.error(
            message: 'Failed to unlink modifier: ${error.toString()}',
            previousState: state is ModifiersLoaded
                ? state as ModifiersLoaded
                : null,
          ),
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

extension ModifiersBlocExtension on BuildContext {
  ModifiersBloc get modifiersBloc => read<ModifiersBloc>();
  ModifiersBloc get watchModifiersBloc => watch<ModifiersBloc>();
}
