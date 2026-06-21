# Architecture overview

## Project type

- Flutter application (Dart >=3.10)
- Core libraries: flutter_bloc, bloc, provider for DI and state management.
- Persistence: Drift (local SQLite) with DAOs and generated code.
- Routing: AutoRoute
- I18n: Slang

## High-level layers

- lib/core: shared utilities, database, services, cubits/blocs, theme, i18n
- lib/feature: domain features split by folders (products, orders, inventory, discounts, settings, auth, pos, reports)
- lib/di: dependency injection aggregator (DependencyInjector with parts: providers.dart, blocs.dart, repositories.dart, mappers.dart)
- lib/<feature>/local/daos: Drift DAOs and table definitions
- lib/<feature>/repositories: repository interfaces + implementations that bridge DAOs/services and Blocs
- lib/<feature>/blocs or cubits: state management units

## Dependencies & codegen

- Run generators after changing annotated code: build_runner, drift_dev, auto_route_generator, slang_build_runner, json_serializable, retrofit_generator, freezed.
- Typical command: `flutter pub run build_runner build --delete-conflicting-outputs`

## How features integrate

- DAOs are provided via ProxyProvider from the global AgoraDatabase in `di/providers.dart`.
- Repositories depend on DAOs and are registered in `di/repositories.dart` as RepositoryProvider.
- Blocs/Cubits consume Repositories and are declared in `di/blocs.dart` as BlocProvider.

## Notes for agents

- Modifying persistence requires: DAO/table edits, repository updates, DI registration, and codegen.
- Adding a globally available Bloc requires updating `di/blocs.dart` and `di/repositories.dart` if new dependencies are needed.
