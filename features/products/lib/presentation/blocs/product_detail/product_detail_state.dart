part of 'product_detail_cubit.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const ProductDetailState._();

  /// Initial state.
  const factory ProductDetailState.initial() = _Initial;

  /// Loading a product.
  const factory ProductDetailState.loading() = _Loading;

  /// Loaded with product and its modifiers.
  const factory ProductDetailState.loaded({
    required Product product,
    @Default([]) List<ModifierGroup> modifiers,
  }) = ProductDetailLoaded;

  /// Creating a new product (empty form).
  const factory ProductDetailState.creating() = _Creating;

  /// Saving the product.
  const factory ProductDetailState.saving({required Product product}) = _Saving;

  /// Successfully saved.
  const factory ProductDetailState.saved({required Product product}) = _Saved;

  /// Deleting the product.
  const factory ProductDetailState.deleting({required Product product}) =
      _Deleting;

  /// Successfully deleted.
  const factory ProductDetailState.deleted() = _Deleted;

  /// Error state with optional product for recovery.
  const factory ProductDetailState.error({
    required String message,
    Product? product,
  }) = _Error;

  /// Returns true if the state has a product.
  bool get hasProduct => maybeMap(
        loaded: (_) => true,
        saving: (_) => true,
        saved: (_) => true,
        deleting: (_) => true,
        error: (s) => s.product != null,
        orElse: () => false,
      );
}
