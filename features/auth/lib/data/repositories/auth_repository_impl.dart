import 'package:errors/errors.dart';
import 'package:feature_auth/data/sources/local/daos/auth_dao.dart';
import 'package:feature_auth/domain/models/session_employee.dart';
import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

const _kSessionKey = 'agora_session_employee_id';

class AuthRepositoryImpl extends Repository implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDao authDao,
    required FlutterSecureStorage secureStorage,
    Talker? logger,
  }) : _authDao = authDao,
       _secureStorage = secureStorage,
       super(logger);

  final AuthDao _authDao;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<List<SessionEmployee>> getActiveEmployees() async {
    try {
      final entities = await _authDao.getActiveEmployees();
      return entities
          .map((e) => SessionEmployee(id: e.id, name: e.name, role: e.role))
          .toList();
    } catch (e) {
      logger?.error('getActiveEmployees failed: $e');
      return [];
    }
  }

  @override
  Future<Result<SessionEmployee>> loginWithPin(int employeeId, String pin) =>
      safe('loginWithPin($employeeId)', () async {
        final entity = await _authDao.getEmployeeByPin(employeeId, pin);
        if (entity == null) {
          throw RepositoryException('Invalid PIN');
        }
        final employee = SessionEmployee(
          id: entity.id,
          name: entity.name,
          role: entity.role,
        );
        await _secureStorage.write(
          key: _kSessionKey,
          value: entity.id.toString(),
        );
        return employee;
      });

  @override
  Future<SessionEmployee?> startSession(int employeeId) async {
    try {
      final entity = await _authDao.getEmployeeById(employeeId);
      if (entity == null || !entity.isActive || entity.deletedAt != null) {
        return null;
      }
      await _secureStorage.write(
        key: _kSessionKey,
        value: entity.id.toString(),
      );
      return SessionEmployee(
        id: entity.id,
        name: entity.name,
        role: entity.role,
      );
    } catch (e) {
      logger?.error('startSession failed: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.delete(key: _kSessionKey);
  }

  @override
  Future<SessionEmployee?> loadSession() async {
    try {
      final raw = await _secureStorage.read(key: _kSessionKey);
      if (raw == null) return null;
      final id = int.tryParse(raw);
      if (id == null) return null;
      final entity = await _authDao.getEmployeeById(id);
      if (entity == null || !entity.isActive || entity.deletedAt != null) {
        await _secureStorage.delete(key: _kSessionKey);
        return null;
      }
      return SessionEmployee(
        id: entity.id,
        name: entity.name,
        role: entity.role,
      );
    } catch (e) {
      logger?.error('loadSession failed: $e');
      return null;
    }
  }
}
