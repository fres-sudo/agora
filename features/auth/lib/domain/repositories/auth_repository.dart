import 'package:feature_auth/domain/models/session_employee.dart';
import 'package:result/result.dart';

abstract interface class AuthRepository {
  /// Returns all active employees for the login screen.
  Future<List<SessionEmployee>> getActiveEmployees();

  /// Authenticates an employee by their ID + PIN.
  /// Returns the [SessionEmployee] on success, or an error.
  Future<Result<SessionEmployee>> loginWithPin(int employeeId, String pin);

  /// Persists a session for [employeeId] without a PIN check.
  ///
  /// Used for single-user businesses (e.g. quick-service / festival) where
  /// onboarding creates one operator and logs them in automatically, so the
  /// PIN screen never appears. Returns the resulting session, or null if the
  /// employee does not exist / is inactive.
  Future<SessionEmployee?> startSession(int employeeId);

  /// Clears the persisted session.
  Future<void> signOut();

  /// Loads the last persisted session from secure storage.
  /// Returns null if no session exists or the employee is gone.
  Future<SessionEmployee?> loadSession();
}
