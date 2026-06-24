part of 'categories_bloc.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const CategoriesState._();

  /// Initial state.
  const factory CategoriesState.initial() = _Initial;

  /// Loading categories.
  const factory CategoriesState.loading() = _Loading;

  /// Loaded with categories.
  const factory CategoriesState.loaded({
    required List<Category> categories,
  }) = CategoriesLoaded;

  /// Error state.
  const factory CategoriesState.error({
    required String message,
    CategoriesLoaded? previousState,
  }) = _Error;

  /// Returns the categories list if loaded.
  List<Category> get categories => maybeMap(
        loaded: (s) => s.categories,
        error: (s) => s.previousState?.categories ?? [],
        orElse: () => [],
      );
}
