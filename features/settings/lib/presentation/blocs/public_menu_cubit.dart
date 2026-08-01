import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/domain/models/public_menu_models.dart';
import 'package:feature_settings/domain/repositories/public_menu_repository.dart';
import 'package:result/result.dart';

sealed class PublicMenuState {
  const PublicMenuState();
}

class PublicMenuLoading extends PublicMenuState {
  const PublicMenuLoading();
}

class PublicMenuReady extends PublicMenuState {
  const PublicMenuReady(this.data, {this.isWorking = false});

  final PublicMenuData data;
  final bool isWorking;

  PublicMenuReady copyWith({PublicMenuData? data, bool? isWorking}) =>
      PublicMenuReady(
        data ?? this.data,
        isWorking: isWorking ?? this.isWorking,
      );
}

class PublicMenuFailure extends PublicMenuState {
  const PublicMenuFailure(this.message, {this.previous});

  final String message;
  final PublicMenuData? previous;
}

/// Settings -> Public Menu coordinator. Publishing is invoked explicitly from
/// the UI; this cubit never observes catalog changes or sends them in the
/// background.
class PublicMenuCubit extends Cubit<PublicMenuState> {
  PublicMenuCubit({required PublicMenuRepository publicMenuRepository})
    : _repository = publicMenuRepository,
      super(const PublicMenuLoading());

  final PublicMenuRepository _repository;

  Future<void> load() async {
    emit(const PublicMenuLoading());
    final result = await _repository.load();
    result.when(
      success: (data) => emit(PublicMenuReady(data)),
      error: (error) => emit(PublicMenuFailure(error.toString())),
    );
  }

  Future<Result<void>> refreshTemplates() async {
    final current = _readyData;
    if (current == null) {
      return const Result.error(
        PublicMenuCubitException('Menu is not loaded.'),
      );
    }
    emit(PublicMenuReady(current, isWorking: true));
    final result = await _repository.refreshTemplates();
    return switch (result) {
      Ok<List<MenuTemplate>>(:final value) => _replaceData(
        current.copyWith(templates: value),
      ),
      Error<List<MenuTemplate>>(:final error) => _fail(error, current),
    };
  }

  Future<Result<void>> saveConfiguration(
    PublicMenuConfiguration configuration,
  ) async {
    final current = _readyData;
    if (current == null) {
      return const Result.error(
        PublicMenuCubitException('Menu is not loaded.'),
      );
    }
    emit(PublicMenuReady(current, isWorking: true));
    final result = await _repository.saveConfiguration(configuration);
    return switch (result) {
      Ok<PublicMenuConfiguration>(:final value) => _replaceData(
        current.copyWith(configuration: value),
      ),
      Error<PublicMenuConfiguration>(:final error) => _fail(error, current),
    };
  }

  Future<Result<String>> preview(PublicMenuConfiguration configuration) =>
      _repository.preview(configuration);

  Future<Result<MenuPublication>> publish(
    PublicMenuConfiguration configuration,
  ) async {
    final current = _readyData;
    if (current == null) {
      return const Result.error(
        PublicMenuCubitException('Menu is not loaded.'),
      );
    }
    emit(PublicMenuReady(current, isWorking: true));
    final result = await _repository.publish(configuration);
    return switch (result) {
      Ok<MenuPublication>(:final value) => _publishSucceeded(
        value,
        configuration,
      ),
      Error<MenuPublication>(:final error) => _publishFailed(error, current),
    };
  }

  Future<Result<void>> unpublish() async {
    final current = _readyData;
    if (current == null) {
      return const Result.error(
        PublicMenuCubitException('Menu is not loaded.'),
      );
    }
    emit(PublicMenuReady(current, isWorking: true));
    final result = await _repository.unpublish();
    return switch (result) {
      Ok<void>() => _replaceData(
        current.copyWith(clearPublication: true, hasUpdate: false),
      ),
      Error<void>(:final error) => _fail(error, current),
    };
  }

  PublicMenuData? get _readyData => switch (state) {
    PublicMenuReady(:final data) => data,
    PublicMenuFailure(:final previous) => previous,
    _ => null,
  };

  Result<void> _replaceData(PublicMenuData data) {
    emit(PublicMenuReady(data));
    return const Result.ok(null);
  }

  Result<void> _fail(Exception error, PublicMenuData previous) {
    emit(PublicMenuFailure(error.toString(), previous: previous));
    return Result.error(error);
  }

  Result<MenuPublication> _publishSucceeded(
    MenuPublication publication,
    PublicMenuConfiguration configuration,
  ) {
    final current = _readyData!;
    emit(
      PublicMenuReady(
        current.copyWith(
          configuration: configuration,
          publication: publication,
          hasUpdate: false,
        ),
      ),
    );
    return Result.ok(publication);
  }

  Result<MenuPublication> _publishFailed(
    Exception error,
    PublicMenuData previous,
  ) {
    emit(PublicMenuFailure(error.toString(), previous: previous));
    return Result.error(error);
  }
}

extension on PublicMenuData {
  PublicMenuData copyWith({
    PublicMenuConfiguration? configuration,
    List<MenuTemplate>? templates,
    MenuPublication? publication,
    bool? hasUpdate,
    bool clearPublication = false,
  }) => PublicMenuData(
    configuration: configuration ?? this.configuration,
    templates: templates ?? this.templates,
    publication: clearPublication ? null : publication ?? this.publication,
    hasUpdate: hasUpdate ?? this.hasUpdate,
  );
}

class PublicMenuCubitException implements Exception {
  const PublicMenuCubitException(this.message);

  final String message;

  @override
  String toString() => message;
}
