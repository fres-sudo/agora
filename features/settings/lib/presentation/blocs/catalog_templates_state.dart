part of 'catalog_templates_cubit.dart';

@freezed
class CatalogTemplatesState with _$CatalogTemplatesState {
  const CatalogTemplatesState._();

  /// Loading the template list.
  const factory CatalogTemplatesState.loading() = _Loading;

  /// Loaded with saved templates, newest first.
  const factory CatalogTemplatesState.loaded({
    required List<CatalogTemplate> templates,
  }) = CatalogTemplatesLoaded;

  /// Error state.
  const factory CatalogTemplatesState.error({required String message}) = _Error;

  /// Returns the templates list if loaded.
  List<CatalogTemplate> get templates =>
      maybeMap(loaded: (s) => s.templates, orElse: () => []);
}
