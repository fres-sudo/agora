part of 'products_bloc.dart';

@freezed
sealed class ProductsEvent with _$ProductsEvent {
  /// Start watching products from the repository.
  const factory ProductsEvent.started() = _Started;

  /// Refresh the product list.
  const factory ProductsEvent.refresh() = _Refresh;

  /// Delete a product by ID.
  const factory ProductsEvent.deleted(int id) = _Deleted;

  /// Filter products by category.
  const factory ProductsEvent.categoryFilterChanged(int? categoryId) =
      _CategoryFilterChanged;

  /// Filter products by search query.
  const factory ProductsEvent.searchChanged(String query) = _SearchChanged;
}
