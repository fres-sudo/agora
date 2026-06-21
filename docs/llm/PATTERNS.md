# Common code patterns and examples

## Dependency Injection

- Global injector: `DependencyInjector` composes `Provider`, `ProxyProvider`, `RepositoryProvider`, and `BlocProvider` lists from `lib/di/*.dart`.
- To add a DAO: provide `AgoraDatabase` and add a `ProxyProvider<AgoraDatabase, NewDao>` returning `db.newDao`.
- To add a repository: add `RepositoryProvider<NewRepository>(create: (c) => NewRepositoryImpl(...))`.

## Repository example

Create an interface and implementation in `lib/<feature>/repositories` that depends on DAOs and services, keeping business logic in the repository.

## Bloc/Cubit example

- Blocs live in `lib/<feature>/blocs` and are registered globally if needed.
- For local-only state, provide the Cubit/Bloc using `BlocProvider` in the page widget.

## Drift DAO example

- Use `@DriftAccessor(tables: [XTable])` and place DAO in `.../services/local/daos`.
- Keep SQL and query composition inside DAO; map to domain models in repository if required.

## Error handling

- Repositories should catch low-level errors and either return domain-specific failures or rethrow wrapped exceptions with context.
- Log unexpected errors using `Talker` where helpful.

## Translation (Slang)

- Source strings live under `lib/core/i18n` and use Slang generators. After editing translations run the slang build runner.

## Routing (AutoRoute)

- Routes are defined in the core router. Add page routes with generated route names (run generator to update router).
