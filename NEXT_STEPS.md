# Monorepo Migration — Next Steps

The source code has been restructured into `apps/`, `features/`, and `packages/`. All imports have been rewritten. The steps below will get the project compiling.

---

## 1. Move Flutter platform files into `apps/agora/`

The platform bindings (android/, ios/, web/) are still at the repo root. They belong inside `apps/agora/` for a proper monorepo layout.

```bash
mv android  apps/agora/android
mv ios      apps/agora/ios
mv web      apps/agora/web
mv native_splash.yaml apps/agora/native_splash.yaml
```

Note: `lefthook.yaml` must stay at the repo root — lefthook only discovers its config there, so do not move it into `apps/agora/`.

Also move or update these root-level config files that reference the Flutter app:
- `analysis_options.yaml` — keep at root (shared), add `include:` in each package that needs it
- `devtools_options.yaml` — move to `apps/agora/`
- `flutter_launcher_icons.yaml` (if present) — move to `apps/agora/`

---

## 2. Install Melos

```bash
dart pub global activate melos
```

---

## 3. Bootstrap the workspace

From the **repo root** (where `melos.yaml` lives):

```bash
melos bootstrap
```

This resolves all `path:` dependencies between packages and runs `pub get` in each one. Fix any version conflicts before proceeding.

---

## 4. Run code generation

All `.g.dart` and `.freezed.dart` files were deleted during migration. Regenerate them:

```bash
# Database schema first (everything depends on AgoraDatabase)
cd packages/database && flutter pub run build_runner build --delete-conflicting-outputs && cd ../..

# Shared packages
cd packages/theme && flutter pub run build_runner build --delete-conflicting-outputs && cd ../..

# i18n strings
cd packages/i18n && flutter pub run build_runner build --delete-conflicting-outputs && cd ../..

# Each feature (order matters: inventory before products, products before orders)
for feature in auth inventory products orders discounts settings pos reports; do
  cd features/$feature && flutter pub run build_runner build --delete-conflicting-outputs && cd ../..
done

# App (router, gen assets, slang)
cd apps/agora && flutter pub run build_runner build --delete-conflicting-outputs && cd ../..
```

Or use the melos script (runs all packages, one at a time):

```bash
melos run build
```

---

## 5. Launch the app

```bash
cd apps/agora
flutter run
```

---

## Common errors after bootstrap

| Error | Fix |
|---|---|
| `Target of URI doesn't exist: 'package:X/...'` | Run `melos bootstrap` — packages aren't linked yet |
| `database.g.dart not generated` | Run build_runner inside `packages/database` first |
| `'AgoraDatabase' has no member 'productsDao'` | Expected — DAOs are no longer registered on the DB class; use `ProductsDao(db)` directly (already done in `*_feature.dart` files) |
| Freezed part file missing | Run build_runner in the relevant package |
| `slang` types not found | Run build_runner in `packages/i18n` |
| `auto_route` generated file missing | Run build_runner in `apps/agora` after all feature pages exist |

---

## Repository structure reference

```
agora/
├── melos.yaml
├── apps/
│   └── agora/              ← Flutter entry point (main.dart, platform files)
│       └── lib/
│           ├── main.dart
│           └── app/
│               ├── app.dart
│               ├── app_providers.dart   ← assembles all feature providers
│               └── app_router.dart      ← assembles all feature routes
├── features/
│   ├── auth/               ← feature_auth package
│   ├── products/           ← feature_products package
│   ├── orders/             ← feature_orders package
│   ├── inventory/          ← feature_inventory package
│   ├── discounts/          ← feature_discounts package
│   ├── settings/           ← feature_settings package
│   ├── pos/                ← feature_pos package
│   └── reports/            ← feature_reports package
└── packages/
    ├── result/             ← Result<T> + Repository base
    ├── errors/             ← AppException, RepositoryException
    ├── logger/             ← Talker re-export
    ├── observer/           ← AppBlocObserver
    ├── utils/              ← extensions, constants, PersistenceService
    ├── database/           ← AgoraDatabase, all tables, seeder
    ├── theme/              ← AppTheme, ThemeCubit, device utils
    ├── ui_kit/             ← shared widgets
    ├── bloc/               ← flutter_bloc + freezed_annotation re-exports
    ├── i18n/               ← slang-generated strings
    └── analytics/          ← placeholder
```

---

## What was NOT migrated (out of scope)

- `test/` directory — tests reference old `package:agora/...` imports. Run a global find-replace using the same mapping in `docs/architecture/REFACTORING_GUIDE.md` Phase 3.
- `copilot-instructions.md` — update to reference new paths
- `mason.yaml` / mason bricks — update brick templates to generate into `features/` structure
