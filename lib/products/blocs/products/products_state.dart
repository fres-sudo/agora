part of 'products_bloc.dart';

@freezed
class ProductsState with _$ProductsState {
  const ProductsState._();

  /// Initial state before any data is loaded.
  const factory ProductsState.initial() = _Initial;

  /// Loading state while fetching products.
  const factory ProductsState.loading() = _Loading;

  /// Loaded state with products and optional filter.
  const factory ProductsState.loaded({
    required List<Product> products,
    required List<Category> categories,
    @Default(null) int? selectedCategoryId,
    @Default('') String searchQuery,
  }) = ProductsLoaded;

  /// Error state with an optional previous state for recovery.
  const factory ProductsState.error({
    required String message,
    ProductsLoaded? previousState,
  }) = _Error;

  /// Returns true if the state has products loaded.
  bool get hasData => this is ProductsLoaded;

  /// Returns the products list if loaded, otherwise empty.
  List<Product> get products => maybeMap(
        loaded: (s) => s.products,
        error: (s) => s.previousState?.products ?? [],
        orElse: () => [],
      );

  /// Returns the categories list if loaded, otherwise empty.
  List<Category> get categories => maybeMap(
        loaded: (s) => s.categories,
        error: (s) => s.previousState?.categories ?? [],
        orElse: () => [],
      );
}
