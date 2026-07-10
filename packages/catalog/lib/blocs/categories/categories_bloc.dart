import 'dart:async';

import 'package:result/result.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:catalog/models/category.dart';
import 'package:catalog/repositories/categories_repository.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

sealed class CategoriesEffect {
  const CategoriesEffect();
}

final class CategoriesShowError extends CategoriesEffect {
  const CategoriesShowError(this.message);
  final String message;
}

/// BLoC for managing categories with real-time updates.
class CategoriesBloc
    extends EffectBloc<CategoriesEvent, CategoriesState, CategoriesEffect> {
  CategoriesBloc({required CategoriesRepository categoriesRepository})
    : _categoriesRepository = categoriesRepository,
      super(const CategoriesState.initial()) {
    on<_Started>(_onStarted);
    on<_Created>(_onCreated);
    on<_Updated>(_onUpdated);
    on<_Deleted>(_onDeleted);
  }

  final CategoriesRepository _categoriesRepository;

  void fetch() => add(const CategoriesEvent.started());

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<CategoriesState> emit) async {
    emit(const CategoriesState.loading());

    await emit.forEach<List<Category>>(
      _categoriesRepository.watchAllCategories(),
      onData: (categories) => CategoriesState.loaded(categories: categories),
      onError: (error, stackTrace) => CategoriesState.error(
        message: error.toString(),
        previousState: state is CategoriesLoaded
            ? state as CategoriesLoaded
            : null,
      ),
    );
  }

  Future<void> _onCreated(_Created event, Emitter<CategoriesState> emit) async {
    final result = await _categoriesRepository.createCategory(event.category);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(
          CategoriesShowError('Failed to create category: ${error.toString()}'),
        );
      },
    );
  }

  Future<void> _onUpdated(_Updated event, Emitter<CategoriesState> emit) async {
    final result = await _categoriesRepository.updateCategory(event.category);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(
          CategoriesShowError('Failed to update category: ${error.toString()}'),
        );
      },
    );
  }

  Future<void> _onDeleted(_Deleted event, Emitter<CategoriesState> emit) async {
    final result = await _categoriesRepository.deleteCategory(event.id);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emitEffect(
          CategoriesShowError('Failed to delete category: ${error.toString()}'),
        );
      },
    );
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension CategoriesBlocExtension on BuildContext {
  CategoriesBloc get categoriesBloc => read<CategoriesBloc>();
  CategoriesBloc get watchCategoriesBloc => watch<CategoriesBloc>();
}
