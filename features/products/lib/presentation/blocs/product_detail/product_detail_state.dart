part of 'product_detail_cubit.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = _Initial;
  const factory ProductDetailState.loading() = _Loading;
  const factory ProductDetailState.loaded({
    required Product product,
    required List<ModifierGroup> modifiers,
  }) = ProductDetailLoaded;
  const factory ProductDetailState.creating() = _Creating;
  const factory ProductDetailState.saving({required Product product}) = _Saving;
  const factory ProductDetailState.saved({required Product product}) = _Saved;
  const factory ProductDetailState.deleting({required Product product}) =
      _Deleting;
  const factory ProductDetailState.deleted() = _Deleted;
}
