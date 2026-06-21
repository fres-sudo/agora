# AI Agent Guide for agora

## Purpose

This document tells AI agents how to add features and fix bugs in this codebase consistently.

## High-level rules

- Prefer small, focused changes with tests.
- Always run code generation when modifying models, DAOs, routes, or translations.
- Follow naming and placement conventions described in CODING_GUIDELINES.md.

## Common workflows

1. New feature that needs persistence (Drift):
   - Add tables and DAOs under feature/services/local/daos.
   - Add repository implementation in feature/repositories.
   - Register DAO and repository in `lib/di/dependency_injector.dart` (see providers.dart and repositories.dart parts).
   - Expose Bloc/Cubit in `lib/di/blocs.dart` if it should be global; otherwise provide via local providers in the feature widget tree.
   - Add migrations/seeders as needed and update `lib/core/database/seeder/data_seeder.dart`.
   - Run build_runner and drift codegen: `flutter pub run build_runner build --delete-conflicting-outputs`.

2. New UI route/page:
   - Create page under feature/pages and widgets under feature/widgets.
   - Add route entry using AutoRoute (see `lib/core/routes/app_router.dart` for examples).
   - If state is required, add Bloc/Cubit and register it (global or local as appropriate).

3. API client changes (Dio/Retrofit):
   - Update service interface and Retrofit annotations.
   - Run codegen for retrofit/json_serializable.
   - Update repository to consume new service.

## Pre-merge checklist for AI patches

- Code compiles and basic app runs (if feasible in CI).
- Unit tests for new logic are added and passing.
- Linting: run analyzer and fix issues (project uses `flutter_lints`).
- Code generation run and generated files included (or instructions added to CI).
- Update DI (`lib/di/...`) and seeds when adding persistent features.
- Update docs here when adding new global conventions.
