import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:result/result.dart';

import 'package:feature_products/domain/models/modifier_group.dart';
import 'package:feature_products/domain/models/product.dart';
import 'package:feature_products/domain/repositories/modifiers_repository.dart';
import 'package:feature_products/domain/repositories/products_repository.dart';

part 'product_detail_cubit.freezed.dart';
part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required ProductsRepository productsRepository,
    required ModifiersRepository modifiersRepository,
  }) : _productsRepository = productsRepository,
       _modifiersRepository = modifiersRepository,
       super(const ProductDetailState.initial());

  final ProductsRepository _productsRepository;
  final ModifiersRepository _modifiersRepository;

  StreamSubscription<Product?>? _productSub;
  StreamSubscription<List<ModifierGroup>>? _modifiersSub;
  Product? _cachedProduct;
  List<ModifierGroup>? _cachedModifiers;

  Future<void> load(int id) async {
    emit(const ProductDetailState.loading());
    await _productSub?.cancel();
    await _modifiersSub?.cancel();
    _cachedProduct = null;
    _cachedModifiers = null;

    _modifiersSub = _modifiersRepository.watchModifiersByProductId(id).listen(
      (mods) {
        _cachedModifiers = mods;
        final product = _cachedProduct;
        if (product != null && !isClosed) {
          emit(ProductDetailState.loaded(product: product, modifiers: mods));
        }
      },
    );

    _productSub = _productsRepository.watchProductById(id).listen(
      (product) {
        if (product == null) return;
        _cachedProduct = product;
        final mods = _cachedModifiers;
        if (mods != null && !isClosed) {
          emit(ProductDetailState.loaded(product: product, modifiers: mods));
        }
      },
    );
  }

  void createNew() {
    emit(const ProductDetailState.creating());
  }

  Future<void> save(Product product) async {
    emit(ProductDetailState.saving(product: product));
    final result = await _productsRepository.updateProduct(product);
    if (isClosed) return;
    switch (result) {
      case Ok<Product>(:final value):
        emit(ProductDetailState.saved(product: value));
      case Error<Product>():
        emit(
          ProductDetailState.loaded(
            product: product,
            modifiers: _cachedModifiers ?? [],
          ),
        );
    }
  }

  Future<void> delete() async {
    final loaded = state.mapOrNull(loaded: (s) => s);
    if (loaded == null) return;

    emit(ProductDetailState.deleting(product: loaded.product));
    final result = await _productsRepository.deleteProduct(loaded.product.id);
    if (isClosed) return;
    switch (result) {
      case Ok<int>():
        emit(const ProductDetailState.deleted());
      case Error<int>():
        emit(
          ProductDetailState.loaded(
            product: loaded.product,
            modifiers: _cachedModifiers ?? [],
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _productSub?.cancel();
    _modifiersSub?.cancel();
    return super.close();
  }
}
