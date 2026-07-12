import 'dart:async';

import 'package:result/result.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

import 'package:catalog/models/category.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/products_repository.dart';

part 'products_bloc.freezed.dart';
part 'products_event.dart';
part 'products_state.dart';

sealed class ProductsEffect {
  const ProductsEffect();
}

final class ProductsShowError extends ProductsEffect {
  const ProductsShowError(this.message);
  final String message;
}

/// BLoC for managing the products list with real-time updates.
///
/// Uses streams from the repository for reactive data binding.
/// Products are automatically updated when the underlying database changes.
class ProductsBloc
    extends EffectBloc<ProductsEvent, ProductsState, ProductsEffect> {
  ProductsBloc({
    required ProductsRepository productsRepository,
    required CategoriesRepository categoriesRepository,
    int maxCategoryRetryAttempts = 5,
    Duration categoryRetryBaseDelay = const Duration(milliseconds: 500),
    Duration categoryRetryMaxDelay = const Duration(seconds: 8),
  }) : _productsRepository = productsRepository,
       _categoriesRepository = categoriesRepository,
       _maxCategoryRetryAttempts = maxCategoryRetryAttempts,
       _categoryRetryBaseDelay = categoryRetryBaseDelay,
       _categoryRetryMaxDelay = categoryRetryMaxDelay,
       super(const ProductsState.initial()) {
    on<_Started>(_onStarted);
    on<_Refresh>(_onRefresh);
    on<_Deleted>(_onDeleted);
    on<_CategoryFilterChanged>(_onCategoryFilterChanged);
    on<_SearchChanged>(_onSearchChanged);
  }

  final ProductsRepository _productsRepository;
  final CategoriesRepository _categoriesRepository;

  // Bounded retry-with-backoff configuration for the categories stream.
  // Without this, a persistently erroring stream (e.g. genuine DB
  // corruption) would retry immediately and forever, burning CPU/battery on
  // a POS device with no circuit breaker and no user-visible error state.
  final int _maxCategoryRetryAttempts;
  final Duration _categoryRetryBaseDelay;
  final Duration _categoryRetryMaxDelay;

  StreamSubscription<List<Product>>? _productsSubscription;
  StreamSubscription<List<Category>>? _categoriesSubscription;
  Timer? _categoryRetryTimer;
  int _categoryRetryAttempt = 0;

  // Current filter state
  int? _selectedCategoryId;
  String _searchQuery = '';
  List<Product> _allProducts = [];
  List<Category> _categories = [];

  // Products and categories are independent streams subscribed together in
  // _onStarted. Without these, whichever stream's first value lands first
  // triggers an intermediate `loaded` state with the other list still at its
  // stale/empty default — a visible flicker (e.g. "no products" for a beat
  // before the real list appears). Suppress emission until both streams have
  // delivered at least one value; after that, either stream updating emits
  // normally.
  bool _hasInitialProducts = false;
  bool _hasInitialCategories = false;

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<ProductsState> emit) async {
    emit(const ProductsState.loading());

    await _productsSubscription?.cancel();
    await _categoriesSubscription?.cancel();
    _categoryRetryTimer?.cancel();
    _categoryRetryAttempt = 0;
    _hasInitialProducts = false;
    _hasInitialCategories = false;

    _subscribeToCategories();

    // Subscribe to products stream
    _productsSubscription = _productsRepository.watchAllProducts().listen(
      (products) {
        _allProducts = products;
        _hasInitialProducts = true;
        if (_hasInitialCategories) _emitLoaded();
      },
      onError: (error) {
        emit(
          ProductsState.error(
            message: error.toString(),
            previousState: state is ProductsLoaded
                ? state as ProductsLoaded
                : null,
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(_Refresh event, Emitter<ProductsState> emit) async {
    // Re-trigger the started event to refresh subscriptions
    add(const ProductsEvent.started());
  }

  Future<void> _onDeleted(_Deleted event, Emitter<ProductsState> emit) async {
    final result = await _productsRepository.deleteProduct(event.id);

    result.when(
      success: (_) {
        // Stream will automatically update the list
      },
      error: (error) {
        emitEffect(
          ProductsShowError('Failed to delete product: ${error.toString()}'),
        );
      },
    );
  }

  Future<void> _onCategoryFilterChanged(
    _CategoryFilterChanged event,
    Emitter<ProductsState> emit,
  ) async {
    _selectedCategoryId = event.categoryId;
    _emitLoaded();
  }

  Future<void> _onSearchChanged(
    _SearchChanged event,
    Emitter<ProductsState> emit,
  ) async {
    _searchQuery = event.query.toLowerCase();
    _emitLoaded();
  }

  // ============================================================
  // HELPERS
  // ============================================================

  /// Subscribes to the categories stream, resetting the retry counter on
  /// every successful emission. On error, delegates to
  /// [_handleCategoriesError] instead of retrying immediately.
  void _subscribeToCategories() {
    _categoriesSubscription = _categoriesRepository.watchAllCategories().listen(
      (categories) {
        _categoryRetryAttempt = 0;
        _categoryRetryTimer?.cancel();
        _categories = categories.where((c) => c.isEnabled).toList();
        _hasInitialCategories = true;
        if (_hasInitialProducts) _emitLoaded();
      },
      onError: _handleCategoriesError,
    );
  }

  /// Handles a categories-stream error with a bounded, exponentially
  /// backed-off retry. Once [_maxCategoryRetryAttempts] is exhausted, a
  /// terminal error state is emitted instead of retrying again, so the UI
  /// can surface a persistent failure instead of looping silently forever.
  void _handleCategoriesError(Object error) {
    _categoryRetryAttempt++;

    if (_categoryRetryAttempt > _maxCategoryRetryAttempts) {
      if (!isClosed) {
        // Uses the bloc-level `emit` (safe to call outside an active event
        // handler), not the per-handler `Emitter` — see `_emitLoaded`.
        // ignore: invalid_use_of_visible_for_testing_member
        emit(
          ProductsState.error(
            message:
                'Failed to load categories after $_maxCategoryRetryAttempts '
                'attempts: $error',
            previousState: state is ProductsLoaded
                ? state as ProductsLoaded
                : null,
          ),
        );
      }
      return;
    }

    final delay = _backoffDelay(_categoryRetryAttempt);
    _categoryRetryTimer?.cancel();
    _categoryRetryTimer = Timer(delay, () {
      if (isClosed) return;
      unawaited(_categoriesSubscription?.cancel());
      _subscribeToCategories();
    });
  }

  /// Exponential backoff capped at [_categoryRetryMaxDelay].
  Duration _backoffDelay(int attempt) {
    final scaled = _categoryRetryBaseDelay * (1 << (attempt - 1));
    return scaled > _categoryRetryMaxDelay ? _categoryRetryMaxDelay : scaled;
  }

  void _emitLoaded() {
    var filteredProducts = _allProducts;

    // Apply category filter
    if (_selectedCategoryId != null) {
      filteredProducts = filteredProducts
          .where((p) => p.categoryId == _selectedCategoryId)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((p) {
        return p.name.toLowerCase().contains(_searchQuery) ||
            (p.sku?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }

    // Only emit if bloc is still active
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(
        ProductsState.loaded(
          products: filteredProducts,
          categories: _categories,
          selectedCategoryId: _selectedCategoryId,
          searchQuery: _searchQuery,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _categoryRetryTimer?.cancel();
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    return super.close();
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension ProductsBlocExtension on BuildContext {
  ProductsBloc get productsBloc => read<ProductsBloc>();
  ProductsBloc get watchProductsBloc => watch<ProductsBloc>();
}
