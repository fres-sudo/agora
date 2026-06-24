# Feature Package Template

Copy this reference when scaffolding a new feature. Replace `<feature>` with the snake_case feature name (e.g. `orders`, `inventory`) and `<Feature>` with the PascalCase equivalent.

---

## Directory scaffold

```
features/<feature>/
├── pubspec.yaml
├── analysis_options.yaml          ← inherit from root
└── lib/
    ├── data/
    │   ├── sources/
    │   │   ├── local/
    │   │   │   ├── daos/
    │   │   │   │   └── <feature>s_dao.dart
    │   │   │   └── tables/
    │   │   │       └── <feature>s_table.dart
    │   │   └── remote/                        ← add only if there's an API
    │   │       └── <feature>s_remote_data_source.dart
    │   ├── dto/                               ← add only if JSON DTOs are needed
    │   │   └── <feature>_dto.dart
    │   └── repositories/
    │       └── <feature>s_repository_impl.dart
    ├── domain/
    │   ├── models/
    │   │   └── <feature>.dart
    │   ├── repositories/
    │   │   └── <feature>s_repository.dart
    │   └── mappers/
    │       └── <feature>_mapper.dart
    ├── presentation/
    │   ├── blocs/
    │   │   └── <feature>s/
    │   │       ├── <feature>s_bloc.dart
    │   │       ├── <feature>s_event.dart
    │   │       └── <feature>s_state.dart
    │   ├── pages/
    │   │   └── <feature>s_page.dart
    │   ├── widgets/
    │   └── routes/
    │       └── <feature>_feature.dart         ← provider + route registration
    └── <feature>.dart                          ← barrel export
```

---

## pubspec.yaml

```yaml
name: feature_<feature>
description: <Feature> feature
publish_to: none

environment:
  sdk: '>=3.10.0 <4.0.0'
  flutter: '>=3.38.5'

dependencies:
  flutter:
    sdk: flutter

  # Shared packages (add only what's needed)
  database:
    path: ../../packages/database
  result:
    path: ../../packages/result
  errors:
    path: ../../packages/errors
  logger:
    path: ../../packages/logger
  bloc_exports:
    path: ../../packages/bloc
  ui_kit:
    path: ../../packages/ui_kit
  theme:
    path: ../../packages/theme
  utils:
    path: ../../packages/utils

  # Pub packages
  drift: ^2.30.0
  freezed_annotation: ^3.1.0
  auto_route: ^11.1.0
  provider: ^6.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  drift_dev: ^2.30.0
  freezed: ^3.2.3
  auto_route_generator: ^10.2.6
  mockito: ^5.5.0
  bloc_test: ^10.0.0
  data_fixture_dart: ^3.0.0
```

---

## File templates

### `domain/models/<feature>.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<feature>.freezed.dart';

@freezed
abstract class <Feature> with _$<Feature> {
  const factory <Feature>({
    required int id,
    required String name,
    // ... fields
  }) = _<Feature>;
}
```

### `domain/repositories/<feature>s_repository.dart`

```dart
import 'package:result/result.dart';
import 'package:feature_<feature>/domain/models/<feature>.dart';

abstract interface class <Feature>sRepository {
  Stream<List<<Feature>>> watchAll<Feature>s();
  Future<Result<<Feature>?>> get<Feature>ById(int id);
  Future<Result<<Feature>>> create<Feature>(<Feature> entity);
  Future<Result<<Feature>>> update<Feature>(<Feature> entity);
  Future<Result<int>> delete<Feature>(int id);
}
```

### `domain/mappers/<feature>_mapper.dart`

```dart
import 'package:database/database.dart';
import 'package:feature_<feature>/domain/models/<feature>.dart';

extension <Feature>EntityMapper on <Feature>Entity {
  <Feature> toModel() => <Feature>(
    id: id,
    name: name,
    // ... map fields
  );
}

extension <Feature>ModelMapper on <Feature> {
  <Feature>sTableCompanion toInsertCompanion() => <Feature>sTableCompanion.insert(
    name: name,
    // ... map fields
  );

  <Feature>sTableCompanion toUpdateCompanion() => <Feature>sTableCompanion(
    name: Value(name),
    // ... map fields
  );
}
```

### `data/sources/local/tables/<feature>s_table.dart`

```dart
import 'package:database/database.dart';
import 'package:drift/drift.dart';

@DataClassName('<Feature>Entity')
class <Feature>sTable extends Table with TableMixin {
  TextColumn get name => text()();
  // ... columns
}
```

### `data/sources/local/daos/<feature>s_dao.dart`

```dart
import 'package:database/database.dart';
import 'package:feature_<feature>/data/sources/local/tables/<feature>s_table.dart';
import 'package:drift/drift.dart';

part '<feature>s_dao.g.dart';

@DriftAccessor(tables: [<Feature>sTable])
class <Feature>sDao extends DatabaseAccessor<AgoraDatabase>
    with _$<Feature>sDaoMixin {
  <Feature>sDao(super.db);

  Stream<List<<Feature>Entity>> watchAll() {
    return (select(<feature>sTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<<Feature>Entity?> getById(int id) {
    return (select(<feature>sTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<int> insert(<Feature>sTableCompanion companion) {
    return into(<feature>sTable).insert(companion);
  }

  Future<bool> update(int id, <Feature>sTableCompanion companion) {
    return (update(<feature>sTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  Future<bool> softDelete(int id) {
    return (update(<feature>sTable)..where((t) => t.id.equals(id)))
        .write(<Feature>sTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }
}
```

### `data/repositories/<feature>s_repository_impl.dart`

```dart
import 'package:result/result.dart';
import 'package:logger/logger.dart';
import 'package:feature_<feature>/data/sources/local/daos/<feature>s_dao.dart';
import 'package:feature_<feature>/domain/mappers/<feature>_mapper.dart';
import 'package:feature_<feature>/domain/models/<feature>.dart';
import 'package:feature_<feature>/domain/repositories/<feature>s_repository.dart';

class <Feature>sRepositoryImpl extends Repository implements <Feature>sRepository {
  <Feature>sRepositoryImpl({
    required <Feature>sDao <feature>sDao,
    AppLogger? logger,
  }) : _<feature>sDao = <feature>sDao,
       super(logger);

  final <Feature>sDao _<feature>sDao;

  @override
  Stream<List<<Feature>>> watchAll<Feature>s() {
    return _<feature>sDao.watchAll().map((entities) => entities.map((e) => e.toModel()).toList()).safeCode(logger);
  }

  @override
  Future<Result<<Feature>?>> get<Feature>ById(int id) =>
      safe('get<Feature>ById($id)', () async {
        final entity = await _<feature>sDao.getById(id);
        return entity?.toModel();
      });

  @override
  Future<Result<<Feature>>> create<Feature>(<Feature> entity) =>
      safe('create<Feature>', () async {
        final id = await _<feature>sDao.insert(entity.toInsertCompanion());
        return entity.copyWith(id: id);
      });

  @override
  Future<Result<<Feature>>> update<Feature>(<Feature> entity) =>
      safe('update<Feature>(${entity.id})', () async {
        await _<feature>sDao.update(entity.id, entity.toUpdateCompanion());
        return entity;
      });

  @override
  Future<Result<int>> delete<Feature>(int id) =>
      safe('delete<Feature>($id)', () async {
        await _<feature>sDao.softDelete(id);
        return id;
      });
}
```

### `presentation/blocs/<feature>s/<feature>s_bloc.dart`

```dart
import 'package:bloc_exports/bloc_exports.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:feature_<feature>/domain/models/<feature>.dart';
import 'package:feature_<feature>/domain/repositories/<feature>s_repository.dart';

part '<feature>s_bloc.freezed.dart';
part '<feature>s_event.dart';
part '<feature>s_state.dart';

class <Feature>sBloc extends Bloc<<Feature>sEvent, <Feature>sState> {
  <Feature>sBloc({required <Feature>sRepository <feature>sRepository})
      : _<feature>sRepository = <feature>sRepository,
        super(const <Feature>sState.loading()) {
    on<<Feature>sStarted>(_onStarted);
  }

  final <Feature>sRepository _<feature>sRepository;

  Future<void> _onStarted(<Feature>sStarted event, Emitter<<Feature>sState> emit) async {
    await emit.forEach(
      _<feature>sRepository.watchAll<Feature>s(),
      onData: (items) => <Feature>sState.loaded(items: items),
      onError: (_, __) => const <Feature>sState.error(),
    );
  }
}
```

### `presentation/routes/<feature>_feature.dart`

```dart
import 'package:database/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:logger/logger.dart';

import 'package:feature_<feature>/data/sources/local/daos/<feature>s_dao.dart';
import 'package:feature_<feature>/data/repositories/<feature>s_repository_impl.dart';
import 'package:feature_<feature>/domain/repositories/<feature>s_repository.dart';
import 'package:feature_<feature>/presentation/blocs/<feature>s/<feature>s_bloc.dart';
import 'package:feature_<feature>/presentation/pages/<feature>s_page.dart';

class <Feature>Feature {
  static List<SingleChildWidget> get providers => [
    ProxyProvider<AgoraDatabase, <Feature>sDao>(
      update: (_, db, __) => db.<feature>sDao,
    ),
    RepositoryProvider<<Feature>sRepository>(
      create: (ctx) => <Feature>sRepositoryImpl(
        <feature>sDao: ctx.read(),
        logger: ctx.read(),
      ),
    ),
    BlocProvider<<Feature>sBloc>(
      create: (ctx) => <Feature>sBloc(<feature>sRepository: ctx.read())..add(const <Feature>sStarted()),
    ),
  ];

  static List<AutoRoute> get routes => [
    AutoRoute(page: <Feature>sRoute.page),
  ];
}
```

### `<feature>.dart` (barrel)

```dart
// Public API — only export what external consumers may use.
export 'domain/models/<feature>.dart';
export 'domain/repositories/<feature>s_repository.dart';
export 'presentation/routes/<feature>_feature.dart';
```

---

## Checklist for a new feature

- [ ] Create package directory and `pubspec.yaml`
- [ ] Define domain model (`@freezed`)
- [ ] Define repository interface (`abstract interface class`)
- [ ] Define Drift table and register it in `packages/database/lib/src/database.dart`
- [ ] Run `build_runner` inside `packages/database` to regenerate `database.g.dart`
- [ ] Implement DAO
- [ ] Implement mapper extensions
- [ ] Implement repository impl
- [ ] Implement BLoC/Cubit with event and state
- [ ] Implement pages and widgets
- [ ] Create `<Feature>Feature` registration class
- [ ] Add `...<Feature>Feature.providers` to `apps/agora/lib/app/app_providers.dart`
- [ ] Add `...<Feature>Feature.routes` to `apps/agora/lib/app/app_router.dart`
- [ ] Write tests (`test/data/`, `test/domain/`, `test/presentation/`)
- [ ] Export public barrel in `<feature>.dart`
- [ ] Run `melos run lint` and `melos run test`
