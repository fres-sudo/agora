import 'package:feature_auth/domain/models/session_employee.dart';
import 'package:result/result.dart';

abstract interface class AuthRepository {
  /// Returns all active employees for the login screen.
  Future<List<SessionEmployee>> getActiveEmployees();

  /// Authenticates an employee by their ID + PIN.
  /// Returns the [SessionEmployee] on success, or an error.
  Future<Result<SessionEmployee>> loginWithPin(int employeeId, String pin);

  /// Clears the persisted session.
  Future<void> signOut();

  /// Loads the last persisted session from secure storage.
  /// Returns null if no session exists or the employee is gone.
  Future<SessionEmployee?> loadSession();
}
