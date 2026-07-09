# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Flutter version

This project uses FVM. Always prefix `flutter` commands with `fvm`:

```bash
fvm flutter <command>
```

The pinned version is in `.fvmrc` (`3.38.5`).

## Commands

### Workspace bootstrap

```bash
melos bootstrap          # link all packages and run pub get
```

### Code generation

```bash
melos run build          # build_runner across all packages (one at a time)
melos run build:watch    # watch mode for active development

# Per-package (faster when working in a single feature):
cd features/products && fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Tests

```bash
melos run test           # all packages with a test/ dir
melos run test:features  # feature packages only
melos run test:packages  # shared packages only

# Single package:
cd features/products && fvm flutter test
# Single file:
cd features/products && fvm flutter test test/presentation/blocs/products_bloc_test.dart
```

### Lint / format

```bash
melos run lint           # dart analyze --fatal-infos across all packages
melos run format         # dart format with exit-if-changed
```

### Cleanup

```bash
melos run clean          # flutter clean in all packages
```

## Architecture

Agora is a **Melos-managed Flutter monorepo** with three scopes. See `docs/architecture/` for full specs.

### Current structure

```
apps/         ← Flutter entry points (no business logic) — currently only apps/agora
features/     ← Domain-isolated packages (restaurant SaaS only)
packages/     ← Cross-cutting infrastructure (all apps)
```

`apps/agora` is the only app that exists today, and it composes all features directly (see "Feature registration pattern" below). There is no `backend/` directory yet — the app is fully offline-first, backed by a local Drift/SQLite database (`package:database`).

### Planned (not yet built)

`docs/architecture/ECOSYSTEM.md` describes a roadmap that splits the current single app apart and adds a shared backend: a standalone `festival_pos` app plus additional restaurant-SaaS apps (`pos`, `kitchen`, `totem`, `client_app`, `waiter`) that would compose `features/*` selectively, all connecting to a `backend/` service. **None of this exists in the repo yet** — do not assume this structure, these directories, or these apps are present. Always check `apps/` and the repo root directly rather than relying on this file or ECOSYSTEM.md for what currently exists.

- `backend/` — planned as Hono + Bun + PostgreSQL + Drizzle; see `docs/architecture/BACKEND.md` for the full spec of the (not-yet-built) service.
- Additional Flutter apps beyond `apps/agora` — see `docs/architecture/ECOSYSTEM.md` for the full multi-app roadmap and build phases.

### Dependency direction

```
apps  →  features  →  packages
features  ↛  features    (no cross-feature imports)
packages  ↛  features    (no business logic in packages)
```

Violations are architecture bugs. If Feature A needs Feature B's model, move it to `packages/`.

### Feature package layout

Each `features/<name>/` is a self-contained Dart package with three strict layers:

```
lib/
├── data/
│   ├── sources/local/daos/     ← Drift DAOs (@DriftAccessor)
│   ├── sources/local/tables/   ← Drift table definitions
│   ├── sources/remote/         ← Retrofit/Dio remote sources
│   ├── dto/                    ← @freezed + @JsonSerializable DTOs
│   └── repositories/           ← concrete RepositoryImpl
├── domain/
│   ├── models/                 ← @freezed domain models (pure Dart)
│   ├── repositories/           ← abstract interface class
│   └── mappers/                ← DTO → domain model extensions
├── presentation/
│   ├── blocs/                  ← Bloc/Cubit
│   ├── pages/                  ← full-screen widgets
│   ├── widgets/                ← feature-scoped widgets
│   └── routes/<name>_feature.dart  ← provider + route registration
└── <name>.dart                 ← barrel export (public API only)
```

Import direction within a feature: `presentation → domain ← data`. Presentation never imports `data/`; it programs against the domain interface.

### Feature registration pattern

Each feature exposes a static class consumed by the app shell:

```dart
class ProductsFeature {
  static List<SingleChildWidget> get providers => [
    ProxyProvider<AgoraDatabase, ProductsDao>(update: (_, db, __) => db.productsDao),
    RepositoryProvider<ProductsRepository>(create: (ctx) => ProductsRepositoryImpl(...)),
    BlocProvider<ProductsBloc>(create: (ctx) => ProductsBloc(productsRepository: ctx.read())),
  ];
  static List<AutoRoute> get routes => [AutoRoute(page: ProductsRoute.page)];
}
```

The app (`apps/agora/lib/app/app_providers.dart`) assembles all features via `...FeatureX.providers`. Provider order matters — DAOs must be registered after `AgoraDatabase`.

### Shared packages

Key packages referenced across features:

| Package | Purpose |
|---|---|
| `package:database` | `AgoraDatabase` (Drift), central schema, `TableMixin` |
| `package:result` | `Result<T, E>` sealed class, `safe()` helper |
| `package:errors` | `AppException`, `RepositoryException` |
| `package:logger` | Talker wrapper |
| `package:sync_engine` | Offline-first sync primitives |
| `package:auth_session` | `SessionCubit`, `AuthRepository` interface |
| `package:bloc_exports` | Re-exports flutter_bloc + freezed_annotation |

### Adding a new feature

1. Create `features/<name>/` package with the layout above.
2. Add tables to `packages/database/lib/src/database.dart` (central Drift schema).
3. Register the feature in `apps/<app>/lib/app/app_providers.dart` and `app_router.dart`.
4. Run `melos bootstrap` then `melos run build`.

### Code generation triggers

| Change | Generator needed |
|---|---|
| Drift tables / DAOs | `drift_dev` |
| `@freezed` models / DTOs | `freezed` + `json_serializable` |
| Retrofit sources | `retrofit_generator` |
| AutoRoute pages | `auto_route_generator` |
| i18n strings | `slang_build_runner` |

Generated files (`.g.dart`, `.freezed.dart`, `.gr.dart`) are committed to the repo.

## Git hooks (lefthook)

- **pre-commit**: `fvm flutter format` + `fvm flutter analyze`
- **pre-push**: `fvm flutter test`

Do not bypass hooks with `--no-verify` unless explicitly asked.
