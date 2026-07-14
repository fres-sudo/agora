# Agora — Monorepo Architecture

## Overview

Agora is structured as a **Melos-managed Dart monorepo** with three top-level scopes:

| Scope | Path | Purpose |
|---|---|---|
| Apps | `apps/<name>/` | Flutter entry points; `apps/agora` composes a subset of features and packages |
| Features | `features/<name>/` | Domain-isolated feature packages (sagra/festival POS only) |
| Packages | `packages/<name>/` | Cross-cutting shared packages (all apps) |

The guiding principle is **feature isolation**: each feature package contains everything it needs (data, domain, presentation) and communicates outward only through its domain interfaces. The app shell assembles them. Packages provide the building blocks but own no business logic.

For the full product scope and build phases see [ECOSYSTEM.md](./ECOSYSTEM.md).  
For the local LAN sync hub architecture see [BACKEND.md](./BACKEND.md).

---

## Repository layout

```
agora/                              ← monorepo root
├── melos.yaml                      ← melos workspace config
├── analysis_options.yaml           ← shared lint rules
├── apps/
│   └── agora/                      ← sagra/festival POS (offline, LAN sync — no cloud)
│       ├── pubspec.yaml
│       └── lib/
│           ├── main.dart           ← bootstrap (init, run)
│           └── app/
│               ├── app.dart        ← MaterialApp.router setup
│               ├── app_providers.dart   ← assembles all features
│               └── app_router.dart      ← assembles all routes
├── features/                       ← sagra/festival POS features
│   ├── auth/
│   ├── products/
│   ├── orders/
│   ├── inventory/
│   ├── discounts/
│   ├── settings/
│   ├── pos/
│   └── reports/
└── packages/                       ← shared infrastructure
    ├── ui_kit/
    ├── utils/
    ├── logger/
    ├── observer/
    ├── analytics/
    ├── notifications/
    ├── permissions/
    ├── sync_engine/
    ├── database/
    ├── bloc/
    ├── theme/
    ├── result/
    └── errors/
```

### Which apps use which features

`apps/agora` is the only app and imports every `features/*` package directly — there is no per-app feature subset to manage. See [ECOSYSTEM.md](./ECOSYSTEM.md) for the full product scope.

---

## App layer (`apps/agora/`)

The app is intentionally **virgin**: it contains no business logic, no domain models, no BLoCs of its own. Its sole jobs are:

1. **Bootstrap** (`main.dart`) — initialize services (DB seed, locale, native splash), then `runApp`.
2. **Assemble** (`app_providers.dart`) — collect providers from every feature and shared package into a single `MultiProvider`.
3. **Route** (`app_router.dart`) — collect `AutoRoute` entries from every feature into a single `AppRouter`.
4. **Render** (`app.dart`) — configure `MaterialApp.router` with the assembled router and theme.

```dart
// apps/agora/lib/app/app_providers.dart
class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    providers: [
      ...CoreProviders.providers,       // database, logger, Dio, etc.
      ...AuthFeature.providers,
      ...ProductsFeature.providers,
      ...OrdersFeature.providers,
      ...InventoryFeature.providers,
      ...DiscountsFeature.providers,
      ...SettingsFeature.providers,
    ],
    child: child,
  );
}
```

**Nothing in `apps/agora/lib/app/` should import from a feature's `data/` or `domain/` layer directly.** It may only reference each feature's public `FeatureX.providers` and `FeatureX.routes` entry points.

---

## Feature layer (`features/<name>/`)

Each feature is a **self-contained Dart package** named `feature_<name>`. It is structured in three layers:

```
features/products/
├── pubspec.yaml              (name: feature_products)
└── lib/
    ├── data/
    │   ├── sources/
    │   │   ├── local/
    │   │   │   ├── daos/         ← Drift DAOs
    │   │   │   └── tables/       ← Drift table definitions
    │   │   └── remote/           ← Retrofit/Dio data sources (optional)
    │   ├── dto/                  ← Data Transfer Objects (JSON / DB entities)
    │   └── repositories/
    │       └── products_repository_impl.dart   ← concrete implementation
    ├── domain/
    │   ├── models/
    │   │   └── product.dart      ← Freezed domain model
    │   ├── repositories/
    │   │   └── products_repository.dart   ← abstract interface
    │   └── mappers/
    │       └── product_mapper.dart        ← extension on DTO → domain model
    ├── presentation/
    │   ├── blocs/
    │   │   └── products/
    │   │       ├── products_bloc.dart
    │   │       ├── products_event.dart
    │   │       └── products_state.dart
    │   ├── pages/
    │   │   └── products_page.dart
    │   ├── widgets/
    │   │   └── product_card.dart
    │   └── routes/
    │       └── products_feature.dart    ← provider + route registration
    └── products.dart                    ← barrel export (public API)
```

### Data layer responsibilities

| Artifact | Description |
|---|---|
| `tables/` | Drift `Table` subclasses with `@DataClassName` |
| `daos/` | `DatabaseAccessor` subclasses (`@DriftAccessor`) |
| `dto/` | JSON-serializable objects (`@freezed + @JsonSerializable`) or Drift-generated entities |
| `sources/remote/` | Retrofit interfaces / Dio-backed data sources |
| `repositories/*_impl.dart` | Concrete `RepositoryImpl` — depends on DAOs and remote sources |

### Domain layer responsibilities

| Artifact | Description |
|---|---|
| `models/` | Pure Dart `@freezed` domain models; no framework dependencies |
| `repositories/*.dart` | `abstract interface class` — the contract the presentation layer programs against |
| `mappers/` | Extensions on DTO/entity types to produce domain models (`extension ProductEntityMapper on ProductEntity`) |

**Mappers live in domain** because they define the translation contract from raw data to the domain language. They may import from `data/dto/` but never from `presentation/`.

### Presentation layer responsibilities

| Artifact | Description |
|---|---|
| `blocs/` | `Bloc` / `Cubit` classes; depend only on domain repositories |
| `pages/` | Full-screen `StatelessWidget` / `StatefulWidget` pages |
| `widgets/` | Reusable widgets scoped to this feature |
| `routes/products_feature.dart` | **Feature registration** — exposes `providers` and `routes` |

### Feature registration

Each feature exposes a static class that the app uses for assembly:

```dart
// features/products/lib/presentation/routes/products_feature.dart
class ProductsFeature {
  static List<SingleChildWidget> get providers => [
    // Data layer
    ProxyProvider<AgoraDatabase, ProductsDao>(
      update: (_, db, __) => db.productsDao,
    ),
    ProxyProvider<AgoraDatabase, StocksDao>(
      update: (_, db, __) => db.stocksDao,
    ),
    // Domain layer
    RepositoryProvider<ProductsRepository>(
      create: (ctx) => ProductsRepositoryImpl(
        productsDao: ctx.read(),
        stocksDao: ctx.read(),
        logger: ctx.read(),
      ),
    ),
    // Presentation layer
    BlocProvider<ProductsBloc>(
      create: (ctx) => ProductsBloc(productsRepository: ctx.read()),
    ),
    BlocProvider<CategoriesBloc>(
      create: (ctx) => CategoriesBloc(categoriesRepository: ctx.read()),
    ),
  ];

  static List<AutoRoute> get routes => [
    AutoRoute(page: ProductsRoute.page),
    AutoRoute(page: ProductDetailRoute.page),
  ];
}
```

### Public barrel export

`products.dart` (the package root) exports **only** what other packages are allowed to depend on — typically domain models and the feature registration class:

```dart
// features/products/lib/products.dart
export 'domain/models/product.dart';
export 'domain/repositories/products_repository.dart';
export 'presentation/routes/products_feature.dart';
// do NOT export data/ internals
```

---

## Packages layer (`packages/<name>/`)

Packages provide **infrastructure and cross-cutting concerns**. They contain no business logic and no feature-specific code.

| Package | Pub name | Responsibility |
|---|---|---|
| `ui_kit` | `package:ui_kit` | Shared widgets: DataTable, dialogs, layouts, section scaffolds, skeletons |
| `theme` | `package:theme` | `AppTheme`, `ThemeCubit`, device utils |
| `bloc` | `package:bloc_exports` | Re-exports `flutter_bloc`, `bloc`, and `freezed_annotation` for uniform versions |
| `result` | `package:result` | `Result<T, E>` sealed class and `safe()` / `safeCode()` helpers |
| `errors` | `package:errors` | `AppException`, `RepositoryException`, error codes |
| `logger` | `package:logger` | `Talker` wrapper, structured log categories |
| `observer` | `package:observer` | `AppBlocObserver` (Talker-backed) |
| `analytics` | `package:analytics` | Abstract `AnalyticsService` interface + no-op impl |
| `notifications` | `package:notifications` | Push / local notification abstraction |
| `permissions` | `package:permissions` | `PermissionService` abstraction over `permission_handler` |
| `sync_engine` | `package:sync_engine` | Offline-first sync primitives (queue, conflict resolution) |
| `database` | `package:database` | `AgoraDatabase` (Drift), `TableMixin`, seeder, color converter |
| `utils` | `package:utils` | Extensions, constants, `EnumMapper`, `SpKeys` |
| `auth_session` | `package:auth_session` | `SessionCubit`, `AuthRepository` interface (used by multiple features) |

### Package-level pubspec pattern

```yaml
# packages/result/pubspec.yaml
name: result
description: Result<T, E> pattern for Agora
publish_to: none
environment:
  sdk: '>=3.10.0 <4.0.0'
# no flutter dependency unless truly needed
```

---

## Dependency rules

```
apps/agora  →  features/*  →  packages/*
                              packages/*  →  packages/*  (no cycles)
               features/*  ↛  features/*  (no cross-feature imports)
```

Enforced constraints:

1. **Features never import other features.** Cross-feature data flows through shared domain interfaces in `packages/auth_session` or via app-level provider composition.
2. **Data layer never imports presentation.** Import direction within a feature: `presentation → domain ← data`.
3. **Domain models are pure Dart.** No Flutter SDK imports, no framework annotations (Freezed is allowed).
4. **Packages never import features.**

---

## Dependency injection pattern

DI follows the **provider tree** pattern using `pine` + `provider`:

- **Packages** provide leaf services (`Talker`, `Dio`, `AgoraDatabase`).
- **Features** provide their DAOs, repositories, and BLoCs via `ProxyProvider` / `RepositoryProvider` / `BlocProvider`.
- **App** assembles everything in order: packages → features.

Provider ordering matters — a feature's DAO `ProxyProvider` must come after `AgoraDatabase` is registered.

---

## Routing pattern

Each feature declares its routes statically. The app router merges them:

```dart
// apps/agora/lib/app/app_router.dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    ...AuthFeature.routes,
    ...ProductsFeature.routes,
    ...OrdersFeature.routes,
    // ...
  ];
}
```

---

## Code generation

Each package/feature that uses generators runs `build_runner` independently via melos:

```bash
melos run build          # runs build_runner across all packages in parallel
melos run build:watch    # watch mode for active development
```

Generators used per layer:

| Layer | Generator |
|---|---|
| `data/tables/` + `data/daos/` | `drift_dev` |
| `domain/models/` | `freezed` |
| `data/dto/` | `freezed` + `json_serializable` |
| `data/sources/remote/` | `retrofit_generator` |
| `presentation/routes/` | `auto_route_generator` |
| i18n (app-level) | `slang_build_runner` |

---

## Testing strategy

| Scope | Location | What to test |
|---|---|---|
| Domain models | `features/<name>/test/domain/` | Pure logic, no mocks needed |
| Repositories | `features/<name>/test/data/` | Mock DAOs/data-sources with `mockito` |
| BLoCs/Cubits | `features/<name>/test/presentation/` | `bloc_test`, mock repositories |
| Widgets | `features/<name>/test/presentation/` | `flutter_test`, mock BLoCs |
| Integration | `apps/agora/test/` | Full provider tree, real Drift in-memory DB |

Each feature's `test/` directory mirrors its `lib/` structure (`test/data/`, `test/domain/`, `test/presentation/`).
