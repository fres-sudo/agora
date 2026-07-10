/// Shared auth-session domain — repository interface, [SessionEmployee]
/// model, and [SessionCubit].
///
/// Lives in `packages/` (as documented in the root `CLAUDE.md`) because
/// `feature_onboarding` needs `AuthRepository` (to start a session for
/// single-user businesses on wizard completion) without depending on
/// `feature_auth` directly. `feature_auth` supplies the concrete
/// `AuthRepositoryImpl` (backed by `AuthDao` + secure storage) plus its own
/// PIN-login UI.
library;

export 'models/session_employee.dart';
export 'repositories/auth_repository.dart';
export 'blocs/session_cubit.dart';
