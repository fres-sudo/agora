import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:feature_discounts/domain/models/discount.dart';
import 'package:feature_discounts/domain/repositories/discounts_repository.dart';
import 'package:result/result.dart';

part 'discounts_bloc.freezed.dart';
part 'discounts_event.dart';
part 'discounts_state.dart';

sealed class DiscountsEffect {
  const DiscountsEffect();
}

final class DiscountsShowError extends DiscountsEffect {
  const DiscountsShowError(this.message);
  final String message;
}

/// BLoC for managing discounts with real-time updates.
class DiscountsBloc extends EffectBloc<DiscountsEvent, DiscountsState, DiscountsEffect> {
  DiscountsBloc({
    required DiscountsRepository discountsRepository,
  })  : _discountsRepository = discountsRepository,
        super(const DiscountsState.initial()) {
    on<_Started>(_onStarted);
    on<_Created>(_onCreated);
    on<_Updated>(_onUpdated);
    on<_Toggled>(_onToggled);
    on<_Deleted>(_onDeleted);
    on<_FilterChanged>(_onFilterChanged);
  }

  final DiscountsRepository _discountsRepository;
  StreamSubscription<List<Discount>>? _subscription;

  // Filter state
  bool _showActiveOnly = false;

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(
    _Started event,
    Emitter<DiscountsState> emit,
  ) async {
    emit(const DiscountsState.loading());
    _subscribeToDiscounts();
  }

  Future<void> _onCreated(
    _Created event,
    Emitter<DiscountsState> emit,
  ) async {
    final result = await _discountsRepository.createDiscount(event.discount);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(DiscountsShowError('Failed to create discount: ${error.toString()}'));
      },
    );
  }

  Future<void> _onUpdated(
    _Updated event,
    Emitter<DiscountsState> emit,
  ) async {
    final result = await _discountsRepository.updateDiscount(event.discount);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(DiscountsShowError('Failed to update discount: ${error.toString()}'));
      },
    );
  }

  Future<void> _onToggled(
    _Toggled event,
    Emitter<DiscountsState> emit,
  ) async {
    final result = event.isActive
        ? await _discountsRepository.activateDiscount(event.id)
        : await _discountsRepository.deactivateDiscount(event.id);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(DiscountsShowError('Failed to toggle discount: ${error.toString()}'));
      },
    );
  }

  Future<void> _onDeleted(
    _Deleted event,
    Emitter<DiscountsState> emit,
  ) async {
    final result = await _discountsRepository.deleteDiscount(event.id);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(DiscountsShowError('Failed to delete discount: ${error.toString()}'));
      },
    );
  }

  Future<void> _onFilterChanged(
    _FilterChanged event,
    Emitter<DiscountsState> emit,
  ) async {
    _showActiveOnly = event.activeOnly;
    await _subscription?.cancel();
    _subscribeToDiscounts();
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _subscribeToDiscounts() {
    final stream = _showActiveOnly
        ? _discountsRepository.watchActiveDiscounts()
        : _discountsRepository.watchAllDiscounts();

    _subscription = stream.listen(
      (discounts) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(DiscountsState.loaded(
            discounts: discounts,
            showActiveOnly: _showActiveOnly,
          ));
        }
      },
      onError: (error) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(DiscountsState.error(
            message: error.toString(),
            previousState:
                state is DiscountsLoaded ? state as DiscountsLoaded : null,
          ));
        }
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

extension DiscountsBlocExtension on BuildContext {
  DiscountsBloc get discountsBloc => read<DiscountsBloc>();
  DiscountsBloc get watchDiscountsBloc => watch<DiscountsBloc>();
}
