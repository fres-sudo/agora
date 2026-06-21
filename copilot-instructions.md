# Copilot instructions — agora

## Short purpose

This repository is a Flutter app with feature folders under `lib/` and Drift persistence. Use this file and `docs/AGENT_MANIFEST.json` to quickly locate entry points and common change paths.

## Where to look first

- Global DI: `lib/di/dependency_injector.dart` (parts in `lib/di/*.dart`) — register DAOs, repositories and Blocs here.
- Database & DAOs: `lib/core/database/database.dart` and per-feature DAOs under `lib/*/services/local/daos` or `lib/*/local/daos`.
- Routes: `lib/core/routes/app_router.dart` and generated `app_router.gr.dart`.
- I18n: `lib/core/i18n` (Slang) — regenerate translators when edited.
- Generators: run `flutter pub run build_runner build --delete-conflicting-outputs` after changing annotated code.

## How to modify code safely (checklist for Copilot suggestions)

1. Identify feature in `docs/AGENT_MANIFEST.json` (or search `lib/` for the feature).
2. If changing persistence: update table/DAO → repository → DI → run codegen → update seeders if needed.
3. If adding UI page: add page under `lib/<feature>/pages`, widgets under `lib/<feature>/widgets`, register route (AutoRoute), and add Bloc/Cubit only if needed.
4. Add unit tests using `bloc_test` and mock dependencies with `mockito` or `http_mock_adapter`.
5. Run formatters and lints (`dart format`, `flutter analyze`).

## Useful files

- `docs/AI_AGENT_GUIDE.md` — workflows and pre-merge checklist.
- `docs/ARCHITECTURE.md` — architecture and DI flow.
- `docs/CODING_GUIDELINES.md` — naming, file layout, and conventions.
- `docs/GENERATION_TEMPLATES.md` — generator commands and templates.

## Prompt tips for best results

- Ask Copilot to produce a minimal PR patch with one feature/bugfix and include the generator commands run.
- Request small diffs and unit tests in the same PR.
- Provide the feature name and desired change in one sentence, then ask for files to edit and a short commit message.
