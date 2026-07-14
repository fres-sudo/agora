# Architecture overview

> **Full architecture specification:** see [docs/architecture/ARCHITECTURE.md](../architecture/ARCHITECTURE.md)
> **Product ecosystem and app inventory:** see [docs/architecture/ECOSYSTEM.md](../architecture/ECOSYSTEM.md)
> **Backend architecture:** see [docs/architecture/BACKEND.md](../architecture/BACKEND.md)
> **Migration plan:** see [docs/architecture/REFACTORING_GUIDE.md](../architecture/REFACTORING_GUIDE.md)

## Project type

- **Melos monorepo** — one Flutter app + feature packages + shared packages, plus a planned local LAN sync hub (not a cloud backend)
- Core libraries: flutter_bloc, bloc, provider (pine) for DI and state management
- Persistence: Drift (local SQLite) with DAOs and generated code
- Routing: AutoRoute
- I18n: Slang
- Sync hub (planned, not built): Hono + Bun + local SQLite, run by the organiser on the event's own LAN — no cloud, no multi-tenancy (see BACKEND.md)

## Product scope

**Agora** (`apps/agora`): offline-first POS for Italian sagre, village festivals, and small pop-up events — not restaurants, bars, or ticketed commercial venues. No backend required to operate a single station. A planned local LAN sync hub lets multiple stands at one event share a live order queue, stock, and kitchen tickets, with no internet connection. See `docs/architecture/ECOSYSTEM.md`.

## Repository layout

```
agora/                     ← monorepo root (melos.yaml)
├── apps/
│   └── agora/              ← sagra/festival POS (offline, LAN sync — no cloud)
├── features/<name>/       ← Domain-isolated feature packages (sagra POS only)
└── packages/<name>/       ← Cross-cutting shared packages
```

`apps/agora` imports every `features/*` package directly — there is no per-app feature subset.

## Feature structure (`features/<name>/`)

Each feature is a self-contained Dart package named `feature_<name>` with three layers:

```
features/products/lib/
├── data/
│   ├── sources/local/daos/      ← Drift DAOs (@DriftAccessor)
│   ├── sources/local/tables/    ← Drift table definitions
│   ├── sources/remote/          ← Retrofit/Dio remote data sources
│   ├── dto/                     ← Data Transfer Objects
│   └── repositories/            ← Concrete repository implementations
├── domain/
│   ├── models/                  ← @freezed domain models (pure Dart)
│   ├── repositories/            ← abstract interface classes
│   └── mappers/                 ← extension-based DTO → domain mappers
├── presentation/
│   ├── blocs/                   ← Bloc/Cubit classes
│   ├── pages/                   ← Full-screen page widgets
│   ├── widgets/                 ← Feature-scoped reusable widgets
│   └── routes/
│       └── <name>_feature.dart  ← Feature registration (providers + routes)
└── <name>.dart                  ← Barrel export (public API)
```

## Shared packages (`packages/`)

| Package | Responsibility |
|---|---|
| `database` | AgoraDatabase (Drift), TableMixin, seeder |
| `result` | Result<T, E> pattern, safe() helper |
| `errors` | AppException, RepositoryException |
| `logger` | Talker wrapper |
| `observer` | AppBlocObserver |
| `theme` | AppTheme, ThemeCubit, device utils |
| `ui_kit` | DataTable, dialogs, layout scaffolds |
| `bloc` | Re-exports flutter_bloc + bloc + freezed_annotation |
| `utils` | Extensions, constants, EnumMapper, SpKeys |
| `analytics` | Abstract AnalyticsService |
| `notifications` | Push/local notification abstraction |
| `permissions` | PermissionService abstraction |
| `sync_engine` | Offline-first sync primitives |
| `auth_session` | SessionCubit, AuthRepository interface |

## Dependency rules

```
apps/agora  →  features/*  →  packages/*
features/*  ↛  features/*   (no cross-feature imports)
packages/*  ↛  features/*   (packages have no business logic)
```

## Feature registration pattern

Each feature exposes a static class:

```dart
// features/products/lib/presentation/routes/products_feature.dart
class ProductsFeature {
  static List<SingleChildWidget> get providers => [
    ProxyProvider<AgoraDatabase, ProductsDao>(update: (_, db, __) => db.productsDao),
    RepositoryProvider<ProductsRepository>(
      create: (ctx) => ProductsRepositoryImpl(productsDao: ctx.read(), logger: ctx.read()),
    ),
    BlocProvider<ProductsBloc>(create: (ctx) => ProductsBloc(productsRepository: ctx.read())),
  ];

  static List<AutoRoute> get routes => [
    AutoRoute(page: ProductsRoute.page),
  ];
}
```

The app shell assembles them:

```dart
// apps/agora/lib/app/app_providers.dart
providers: [
  ...CoreProviders.providers,
  ...ProductsFeature.providers,
  ...OrdersFeature.providers,
  // ...
]
```

## DI and codegen notes for agents

- Each feature runs `build_runner` independently: `cd features/<name> && flutter pub run build_runner build`
- Workspace-wide: `melos run build`
- Adding a new feature: create the package, add providers/routes to `apps/agora/lib/app/`, register tables in `packages/database`
- Adding a new shared package: create under `packages/`, add to dependents' `pubspec.yaml`, run `melos bootstrap`
- Table additions still require editing `packages/database/lib/src/database.dart` (central Drift schema)
