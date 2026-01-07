import 'dart:async';

import 'package:agora/core/misc/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/products/models/modifier_group/modifier_group.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/repositories/modifiers_repository.dart';
import 'package:agora/products/repositories/products_repository.dart';

part 'product_detail_cubit.freezed.dart';
part 'product_detail_state.dart';

/// Cubit for managing a single product's detail view and edit operations.
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required ProductsRepository productsRepository,
    required ModifiersRepository modifiersRepository,
  }) : _productsRepository = productsRepository,
       _modifiersRepository = modifiersRepository,
       super(const ProductDetailState.initial());

  final ProductsRepository _productsRepository;
  final ModifiersRepository _modifiersRepository;

  StreamSubscription<Product?>? _productSubscription;
  StreamSubscription<List<ModifierGroup>>? _modifiersSubscription;

  Product? _product;
  List<ModifierGroup> _modifiers = [];

  // ============================================================
  // PUBLIC METHODS
  // ============================================================

  /// Load a product by ID with its modifiers.
  Future<void> load(int productId) async {
    emit(const ProductDetailState.loading());

    await _productSubscription?.cancel();
    await _modifiersSubscription?.cancel();

    _productSubscription = _productsRepository
        .watchProductById(productId)
        .listen(
          (product) {
            _product = product;
            _emitLoaded();
          },
          onError: (error) {
            emit(ProductDetailState.error(message: error.toString()));
          },
        );

    _modifiersSubscription = _modifiersRepository
        .watchModifiersByProductId(productId)
        .listen(
          (modifiers) {
            _modifiers = modifiers;
            _emitLoaded();
          },
          onError: (error) {
            // Modifiers error is non-fatal, continue with product only
          },
        );
  }

  /// Create a new product (start with empty state for form).
  void createNew() {
    emit(const ProductDetailState.creating());
  }

  /// Save the product (create or update).
  Future<void> save(Product product) async {
    final isNew = product.id == 0;
    emit(ProductDetailState.saving(product: product));

    final result = isNew
        ? await _productsRepository.createProduct(product)
        : await _productsRepository.updateProduct(product);

    result.when(
      success: (savedProduct) {
        emit(ProductDetailState.saved(product: savedProduct));
      },
      error: (error) {
        emit(
          ProductDetailState.error(
            message: 'Failed to save product: ${error.toString()}',
            product: product,
          ),
        );
      },
    );
  }

  /// Delete the current product.
  Future<void> delete() async {
    if (_product == null) return;

    emit(ProductDetailState.deleting(product: _product!));

    final result = await _productsRepository.deleteProduct(_product!.id);

    result.when(
      success: (_) {
        emit(const ProductDetailState.deleted());
      },
      error: (error) {
        emit(
          ProductDetailState.error(
            message: 'Failed to delete product: ${error.toString()}',
            product: _product,
          ),
        );
      },
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _emitLoaded() {
    if (_product != null && !isClosed) {
      emit(
        ProductDetailState.loaded(product: _product!, modifiers: _modifiers),
      );
    }
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    _modifiersSubscription?.cancel();
    return super.close();
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension ProductDetailCubitExtension on BuildContext {
  ProductDetailCubit get productDetailCubit => read<ProductDetailCubit>();
  ProductDetailCubit get watchProductDetailCubit => watch<ProductDetailCubit>();
}
