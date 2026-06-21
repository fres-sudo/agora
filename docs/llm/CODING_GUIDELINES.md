# Coding guidelines and conventions

## Formatting and linting

- Follow `flutter_lints` provided in dev_dependencies.
- Use `dart format` and fix analyzer warnings.

## File and folder organization

- Feature-first structure: `lib/<feature>/pages`, `.../widgets`, `.../repositories`, `.../blocs` or `cubits`, `.../services`.
- Shared code goes into `lib/core/`.

## Naming

- Blocs: `FeatureBloc`, events `FeatureEvent`, states `FeatureState`.
- Cubits: `FeatureCubit` with `FeatureState` subclasses when needed.
- Repositories: `FeatureRepository` interface and `FeatureRepositoryImpl` implementation.
- DAOs: `<Feature>Dao`, tables `<feature>_table.dart` if tables are separate.

## Patterns

- Use Repository pattern to abstract data sources.
- Use Drift DAOs for database access; keep SQL/queries inside DAO classes.
- Keep UI widgets dumb: fetch state from Bloc/Cubit and render.

## Code generation

- When adding models annotated for JSON/Freezed/Retrofit/Drift/AutoRoute/Slang, run generators.
- Generated files are checked into the repo in many cases (e.g. \*.g.dart) — verify git status.

## Testing

- Add unit tests for business logic using `bloc_test` and `mockito` or `http_mock_adapter` for network.
- Keep UI widget tests minimal and focus on integration where necessary.

## PR guidance for agents

- Keep PRs small and focused; one feature or bugfix per branch.
- Include changelog line and linked issue if present.
- Mention codegen commands that were run and any generated files added.
