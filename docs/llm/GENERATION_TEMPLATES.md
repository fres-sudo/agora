# Code generation & templates

## Commands

- One-off: `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- For continuous generation in dev: `fvm flutter pub run build_runner watch`

## Generators used in this repo

- drift_dev (Drift tables/DAOs)
- auto_route_generator (router)
- slang_build_runner (i18n)
- json_serializable / retrofit_generator / freezed / build_runner

## File templates for new feature

- `lib/<feature>/models/<model>.dart` (@Freezed / @JsonSerializable)
- `lib/<feature>/services/local/daos/<feature>_dao.dart` (@DriftAccessor)
- `lib/<feature>/repositories/<feature>_repository.dart` (interface + impl)
- `lib/<feature>/blocs/<feature>_bloc.dart` or `cubits/<feature>_cubit.dart`
- `lib/<feature>/pages/<feature>_page.dart` and `widgets/`

## Example generator checklist (include in PR description)

1. List the generator commands run.
2. Attach or reference generated files added to the change.
3. Mention any `.g.dart` or `.freezed.dart` files added or modified.
