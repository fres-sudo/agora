# Refactoring Guide — Monorepo Migration

This document describes the step-by-step migration from the current single-package Flutter app to the Melos monorepo described in [ARCHITECTURE.md](./ARCHITECTURE.md).

The migration is split into **five phases**. Each phase is independently releasable; the app should compile and run at the end of every phase.

---

## Current state (before migration)

```
lib/
├── core/          ← shared utilities, DB, theme, i18n
├── di/            ← global DependencyInjector
├── auth/
├── products/
├── orders/
├── inventory/
├── discounts/
├── settings/
├── pos/
└── reports/
```

All code is in one Dart package (`agora`). The DI is a monolithic `DependencyInjector` widget with four `part` files (`blocs.dart`, `providers.dart`, `repositories.dart`, `mappers.dart`).

---

## Phase 0 — Prepare the workspace

**Goal:** get Melos running without moving any code.

### Steps

1. **Install Melos globally**
   ```bash
   dart pub global activate melos
   ```

2. **Create `melos.yaml` at the repo root**
   ```yaml
   name: agora_workspace
   repository: https://github.com/your-org/agora

   packages:
     - apps/**
     - features/**
     - packages/**

   scripts:
     build:
       run: flutter pub run build_runner build --delete-conflicting-outputs
       exec:
         concurrency: 1
       description: Run code generation in all packages

     build:watch:
       run: flutter pub run build_runner watch --delete-conflicting-outputs
       description: Watch mode code generation

     test:
       run: flutter test
       exec:
         concurrency: 4
       description: Run tests in all packages

     lint:
       run: dart analyze .
       description: Analyze all packages

     clean:
       run: flutter clean
       description: Clean all packages
   ```

3. **Bootstrap the workspace**
   ```bash
   melos bootstrap
   ```
   This resolves dependencies across all packages (none yet, but confirms the tool works).

4. **Commit** `melos.yaml`.

---

## Phase 1 — Extract shared packages

**Goal:** carve out `lib/core/` into independent packages under `packages/`. No feature code moves yet. The existing `agora` app continues to import from `lib/core/` during this phase (or we switch the imports as each package stabilises).

### Extraction order (dependencies first)

| Step | Package to create | Source in `lib/core/` |
|---|---|---|
| 1a | `packages/result` | `lib/core/misc/result.dart`, `lib/core/misc/repository.dart` |
| 1b | `packages/errors` | `lib/core/exceptions/repository_exception.dart` |
| 1c | `packages/logger` | wraps `talker`; expose `AppLogger` |
| 1d | `packages/utils` | `lib/core/misc/extensions.dart`, `constants.dart`, `sp_keys.dart`, `enum_mapper.dart`, `enums/` |
| 1e | `packages/database` | `lib/core/database/` (Database, TableMixin, seeder, color_converter) |
| 1f | `packages/theme` | `lib/core/ui/theme.dart`, `device.dart`, `ui.dart`, ThemeCubit |
| 1g | `packages/ui_kit` | `lib/core/ui/widgets/` (DataTable, dialogs, layouts, DrawerMenu…) |
| 1h | `packages/bloc` | re-exports `flutter_bloc`, `bloc`, `freezed_annotation`, `provider`, `pine` |
| 1i | `packages/observer` | `AppBlocObserver` (to be created from Talker) |
| 1j | `packages/analytics` | abstract interface + no-op; no current source |
| 1k | `packages/notifications` | placeholder |
| 1l | `packages/permissions` | placeholder |
| 1m | `packages/sync_engine` | placeholder |

### Package scaffold

Each package follows this structure:

```
packages/result/
├── pubspec.yaml
├── lib/
│   ├── result.dart          ← barrel export
│   └── src/
│       ├── result.dart
│       └── repository.dart
└── test/
    └── result_test.dart
```

**pubspec.yaml template:**
```yaml
name: result
description: Result<T, E> pattern for Agora
publish_to: none

environment:
  sdk: '>=3.10.0 <4.0.0'

dependencies:
  # minimal deps here

dev_dependencies:
  test: ^1.24.0
```

### Updating imports

After each package is extracted, do a project-wide find-replace:

```bash
# example: after extracting packages/result
find lib -name "*.dart" -exec sed -i '' \
  "s|import 'package:agora/core/misc/result.dart'|import 'package:result/result.dart'|g" {} \;
```

Run `flutter analyze` after each replacement.

---

## Phase 2 — Extract `packages/database`

Database needs special attention because Drift generates code that references table classes. Extract in this sub-order:

1. Move `lib/core/database/database.dart`, `color_converter.dart`, `database.g.dart` → `packages/database/lib/src/`
2. Move `lib/core/mixins/database_mixin.dart` → `packages/database/lib/src/`
3. Add `drift` and `drift_flutter` to `packages/database/pubspec.yaml`
4. Re-run `build_runner` inside `packages/database`
5. Update all `lib/<feature>/services/local/` imports

**Important:** All feature DAOs reference `AgoraDatabase`. After this move they will depend on `package:database`. Feature table definitions must also register with the central database. The `AgoraDatabase` class lists all tables; adding a new feature table still requires editing `packages/database`. This is an intentional coupling point — the database schema is a shared resource.

---

## Phase 3 — Convert features to packages

**Goal:** move each feature from `lib/<feature>/` to `features/<feature>/`, introducing the `data/domain/presentation` sub-structure.

### Feature migration order (fewest cross-dependencies first)

1. `auth`
2. `settings`
3. `products`
4. `inventory`
5. `discounts`
6. `orders`
7. `pos`
8. `reports`

### Per-feature migration steps

Given `lib/products/` as an example:

#### 3.1 Create the package scaffold

```
features/products/
├── pubspec.yaml           (name: feature_products)
└── lib/
    ├── data/
    ├── domain/
    ├── presentation/
    └── products.dart
```

**pubspec.yaml:**
```yaml
name: feature_products
description: Products feature — catalog, categories, modifiers
publish_to: none

environment:
  sdk: '>=3.10.0 <4.0.0'
  flutter: '>=3.38.5'

dependencies:
  flutter:
    sdk: flutter
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
  drift: ^2.30.0
  auto_route: ^11.1.0
  freezed_annotation: ^3.1.0
  provider: ^6.1.5

dev_dependencies:
  build_runner: ^2.4.7
  drift_dev: ^2.30.0
  freezed: ^3.2.3
  auto_route_generator: ^10.2.6
  flutter_test:
    sdk: flutter
  mockito: ^5.5.0
  bloc_test: ^10.0.0
```

#### 3.2 Move and restructure files

| Old path | New path |
|---|---|
| `lib/products/models/product/product.dart` | `features/products/lib/domain/models/product.dart` |
| `lib/products/models/category/category.dart` | `features/products/lib/domain/models/category.dart` |
| `lib/products/models/modifier_group/` | `features/products/lib/domain/models/modifier_group.dart` |
| `lib/products/repositories/products_repository.dart` | `features/products/lib/domain/repositories/products_repository.dart` |
| `lib/products/services/local/mappers/product_mapper.dart` | `features/products/lib/domain/mappers/product_mapper.dart` |
| `lib/products/services/local/tables/products_table.dart` | `features/products/lib/data/sources/local/tables/products_table.dart` |
| `lib/products/services/local/daos/products_dao.dart` | `features/products/lib/data/sources/local/daos/products_dao.dart` |
| `lib/products/repositories/products_repository.dart` (impl) | `features/products/lib/data/repositories/products_repository_impl.dart` |
| `lib/products/blocs/products/` | `features/products/lib/presentation/blocs/products/` |
| `lib/products/pages/` | `features/products/lib/presentation/pages/` |
| `lib/products/widgets/` | `features/products/lib/presentation/widgets/` |

#### 3.3 Add feature registration class

Create `features/products/lib/presentation/routes/products_feature.dart`:

```dart
import 'package:database/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_products/data/sources/local/daos/products_dao.dart';
import 'package:feature_products/data/repositories/products_repository_impl.dart';
import 'package:feature_products/domain/repositories/products_repository.dart';
import 'package:feature_products/presentation/blocs/products/products_bloc.dart';
// ... other imports

class ProductsFeature {
  static List<SingleChildWidget> get providers => [
    ProxyProvider<AgoraDatabase, ProductsDao>(
      update: (_, db, __) => db.productsDao,
    ),
    ProxyProvider<AgoraDatabase, StocksDao>(
      update: (_, db, __) => db.stocksDao,
    ),
    RepositoryProvider<ProductsRepository>(
      create: (ctx) => ProductsRepositoryImpl(
        productsDao: ctx.read(),
        stocksDao: ctx.read(),
        logger: ctx.read(),
      ),
    ),
    BlocProvider<ProductsBloc>(
      create: (ctx) => ProductsBloc(productsRepository: ctx.read()),
    ),
    BlocProvider<CategoriesBloc>(
      create: (ctx) => CategoriesBloc(categoriesRepository: ctx.read()),
    ),
    BlocProvider<ModifiersBloc>(
      create: (ctx) => ModifiersBloc(modifiersRepository: ctx.read()),
    ),
  ];

  static List<AutoRoute> get routes => [
    AutoRoute(page: ProductsRoute.page),
  ];
}
```

#### 3.4 Update DI in the app

Remove the feature's entries from `lib/di/{providers,repositories,blocs}.dart` and replace with:

```dart
// apps/agora/lib/app/app_providers.dart
...ProductsFeature.providers,
```

#### 3.5 Run codegen and tests

```bash
cd features/products && flutter pub run build_runner build --delete-conflicting-outputs
cd features/products && flutter test
```

---

## Phase 4 — Migrate the app shell

**Goal:** move `lib/main.dart` and `lib/di/` into `apps/agora/` and clean up what remains.

### Steps

1. Create `apps/agora/` as a Flutter app package:
   ```bash
   flutter create --project-name agora_app apps/agora
   ```

2. Copy/move:
   - `lib/main.dart` → `apps/agora/lib/main.dart`
   - `lib/core/routes/app_router.dart` → `apps/agora/lib/app/app_router.dart`
   - `lib/di/` → replaced by `apps/agora/lib/app/app_providers.dart`

3. Update `apps/agora/pubspec.yaml` to depend on all feature packages and shared packages.

4. Delete `lib/di/` from the old location.

5. The original `lib/` folder will now only contain legacy code that hasn't been migrated yet — clean it out feature by feature until it is empty, then remove it.

---

## Phase 5 — Polish and enforce rules

1. **Add import guards** via `analysis_options.yaml` or a custom lint rule to prevent cross-feature imports.
2. **CI matrix** — add a melos-based CI step that runs `melos run test` and `melos run lint` per package.
3. **Validate barrel exports** — ensure `features/<name>/lib/<name>.dart` only exports domain-safe symbols.
4. **Remove legacy `lib/core/`** — all code should now live in packages.
5. **Add `pubspec_lock` to `.gitignore`** for inner packages; only the root app lock is committed.

---

## Decision log

### Why Melos over `path` deps only?

Melos gives cross-package script running, versioning, and CI tooling. Without it, running `build_runner` across 15+ packages is manual. Melos' `exec` command handles it.

### Why move mappers to domain?

Mappers translate data layer entities to domain models. The translation *contract* belongs to domain — domain defines what the model should look like, so it should own the mapper. The mapper may *read* from a DTO type in `data/`, but the mapping logic is a domain concern.

### Why is `AgoraDatabase` in a shared package?

Drift requires all tables to be registered in one central database class. Splitting databases per feature would require complex cross-database joins or duplication. The shared `database` package is the only legitimate place where feature tables are registered — this is a deliberate, load-bearing coupling point.

### Why not route-based lazy loading?

AutoRoute supports deferred loading but it adds complexity not yet needed. All features are registered upfront; lazy loading can be introduced per feature when startup performance becomes a concern.

### Why does each feature own its providers?

Centralised DI (the current `lib/di/` approach) becomes a merge conflict hotspot as the team grows. When a feature owns its providers, adding a feature means adding one line to `app_providers.dart` rather than editing four files.
