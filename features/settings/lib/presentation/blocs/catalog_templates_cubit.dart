import 'dart:async';

import 'package:catalog/models/catalog_template.dart';
import 'package:catalog/repositories/catalog_templates_repository.dart';
import 'package:result/result.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'catalog_templates_cubit.freezed.dart';
part 'catalog_templates_state.dart';

/// Cubit backing Settings -> Catalog Templates
/// (docs/features/06-season-to-season-catalog-reuse.md). Save/restore/delete
/// are exposed as plain `Future<Result<T>>` methods rather than
/// events/effects — the widget awaits the call directly and reacts to its
/// `Result` (e.g. a snackbar on error), while [load] keeps the list itself
/// live via the repository's watch stream.
class CatalogTemplatesCubit extends Cubit<CatalogTemplatesState> {
  CatalogTemplatesCubit({
    required CatalogTemplatesRepository catalogTemplatesRepository,
  }) : _repository = catalogTemplatesRepository,
       super(const CatalogTemplatesState.loading());

  final CatalogTemplatesRepository _repository;
  StreamSubscription<List<CatalogTemplate>>? _subscription;

  void load() {
    emit(const CatalogTemplatesState.loading());

    unawaited(_subscription?.cancel());
    _subscription = _repository.watchAllTemplates().listen(
      (templates) {
        if (!isClosed) {
          emit(CatalogTemplatesState.loaded(templates: templates));
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(CatalogTemplatesState.error(message: error.toString()));
        }
      },
    );
  }

  Future<Result<CatalogTemplate>> saveCurrentAsTemplate(String name) {
    return _repository.saveCurrentAsTemplate(name);
  }

  Future<Result<void>> restoreTemplate(
    int templateId, {
    required bool replaceExisting,
  }) {
    return _repository.restoreTemplate(
      templateId,
      replaceExisting: replaceExisting,
    );
  }

  Future<Result<int>> deleteTemplate(int id) {
    return _repository.deleteTemplate(id);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
