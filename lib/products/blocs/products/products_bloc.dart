import 'dart:async';

import 'package:agora/core/misc/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/products/models/category/category.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/repositories/categories_repository.dart';
import 'package:agora/products/repositories/products_repository.dart';

part 'products_bloc.freezed.dart';
part 'products_event.dart';
part 'products_state.dart';

/// BLoC for managing the products list with real-time updates.
///
/// Uses streams from the repository for reactive data binding.
/// Products are automatically updated when the underlying database changes.
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({
    required ProductsRepository productsRepository,
    required CategoriesRepository categoriesRepository,
  }) : _productsRepository = productsRepository,
       _categoriesRepository = categoriesRepository,
       super(const ProductsState.initial()) {
    on<_Started>(_onStarted);
    on<_Refresh>(_onRefresh);
    on<_Deleted>(_onDeleted);
    on<_CategoryFilterChanged>(_onCategoryFilterChanged);
    on<_SearchChanged>(_onSearchChanged);
  }

  final ProductsRepository _productsRepository;
  final CategoriesRepository _categoriesRepository;

  StreamSubscription<List<Product>>? _productsSubscription;
  StreamSubscription<List<Category>>? _categoriesSubscription;

  // Current filter state
  int? _selectedCategoryId;
  String _searchQuery = '';
  List<Product> _allProducts = [];
  List<Category> _categories = [];

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<ProductsState> emit) async {
    emit(const ProductsState.loading());

    await _productsSubscription?.cancel();
    await _categoriesSubscription?.cancel();

    // Subscribe to categories stream
    _categoriesSubscription = _categoriesRepository.watchAllCategories().listen(
      (categories) {
        _categories = categories.where((c) => c.isEnabled).toList();
        _emitLoaded();
      },
      onError: (error) {
        add(const ProductsEvent.refresh());
      },
    );

    // Subscribe to products stream
    _productsSubscription = _productsRepository.watchAllProducts().listen(
      (products) {
        _allProducts = products;
        _emitLoaded();
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
        emit(
          ProductsState.error(
            message: 'Failed to delete product: ${error.toString()}',
            previousState: state is ProductsLoaded
                ? state as ProductsLoaded
                : null,
          ),
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
