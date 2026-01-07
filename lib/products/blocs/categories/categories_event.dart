part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  /// Start watching categories.
  const factory CategoriesEvent.started() = _Started;

  /// Create a new category.
  const factory CategoriesEvent.created(Category category) = _Created;

  /// Update an existing category.
  const factory CategoriesEvent.updated(Category category) = _Updated;

  /// Delete a category by ID.
  const factory CategoriesEvent.deleted(int id) = _Deleted;
}
