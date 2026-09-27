import 'dart:async';
import 'dart:math' as math;

import 'package:database/database.dart' show PinHasher;
import 'package:errors/errors.dart';
import 'package:feature_auth/data/sources/local/daos/auth_dao.dart';
import 'package:auth_session/models/session_employee.dart';
import 'package:auth_session/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

const _kSessionKey = 'agora_session_employee_id';
const _kPinAttemptPrefix = 'agora_pin_attempts_';
const _maxAttemptsBeforeLockout = 5;
const _initialLockout = Duration(seconds: 30);
const _maxLockout = Duration(minutes: 15);

typedef _PinAttemptState = ({int failures, DateTime? lockedUntil});

class AuthRepositoryImpl extends Repository implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDao authDao,
    required FlutterSecureStorage secureStorage,
    DateTime Function()? now,
    Talker? logger,
  }) : _authDao = authDao,
       _secureStorage = secureStorage,
       _now = now ?? DateTime.now,
       super(logger);

  final AuthDao _authDao;
  final FlutterSecureStorage _secureStorage;
  final DateTime Function() _now;
  Future<void> _loginTail = Future.value();

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
  Future<Result<SessionEmployee>> loginWithPin(
    int employeeId,
    String pin,
  ) async {
    // Serialize attempts so concurrent calls cannot all read the same failure
    // count and bypass the lockout by racing secure-storage updates.
    final previous = _loginTail;
    final release = Completer<void>();
    _loginTail = release.future;
    await previous;
    try {
      return await _loginWithPin(employeeId, pin);
    } finally {
      release.complete();
    }
  }

  Future<Result<SessionEmployee>> _loginWithPin(int employeeId, String pin) =>
      safe('loginWithPin($employeeId)', () async {
        final attempts = await _readPinAttempts(employeeId);
        final lockedUntil = attempts.lockedUntil;
        if (lockedUntil != null && _now().isBefore(lockedUntil)) {
          throw RepositoryException(_lockoutMessage(lockedUntil));
        }

        if (!PinHasher.isValid(pin)) {
          throw RepositoryException('Invalid PIN');
        }

        final entity = await _authDao.getActiveEmployeeForLogin(employeeId);
        if (entity == null) {
          final lockedUntil = await _recordFailedAttempt(employeeId, attempts);
          if (lockedUntil != null) {
            throw RepositoryException(_lockoutMessage(lockedUntil));
          }
          throw RepositoryException('Invalid PIN');
        }

        final stored = entity.pinHash;
        final isHashed = PinHasher.looksHashed(stored);
        final matches = isHashed
            ? PinHasher.verify(pin, stored)
            // Legacy row created before PINs were hashed: fall back to a
            // constant-time plaintext comparison so existing employees can
            // still log in, then transparently upgrade the stored value to
            // a bcrypt hash on this successful login.
            : PinHasher.constantTimeEquals(stored, pin);
        if (!matches) {
          final lockedUntil = await _recordFailedAttempt(employeeId, attempts);
          if (lockedUntil != null) {
            throw RepositoryException(_lockoutMessage(lockedUntil));
          }
          throw RepositoryException('Invalid PIN');
        }
        if (!isHashed || PinHasher.needsRehash(stored)) {
          await _authDao.updatePinHash(entity.id, PinHasher.hash(pin));
        }

        await _clearPinAttempts(employeeId);

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

  String _pinAttemptKey(int employeeId) => '$_kPinAttemptPrefix$employeeId';

  Future<_PinAttemptState> _readPinAttempts(int employeeId) async {
    final raw = await _secureStorage.read(key: _pinAttemptKey(employeeId));
    if (raw == null) return (failures: 0, lockedUntil: null);

    final parts = raw.split(':');
    if (parts.length != 2) return (failures: 0, lockedUntil: null);
    final failures = int.tryParse(parts[0]);
    final lockedUntilMs = int.tryParse(parts[1]);
    if (failures == null || failures < 0 || lockedUntilMs == null) {
      return (failures: 0, lockedUntil: null);
    }
    return (
      failures: failures,
      lockedUntil: lockedUntilMs == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lockedUntilMs),
    );
  }

  Future<DateTime?> _recordFailedAttempt(
    int employeeId,
    _PinAttemptState current,
  ) async {
    final failures = current.failures + 1;
    DateTime? lockedUntil;
    if (failures >= _maxAttemptsBeforeLockout) {
      final exponent = math.min(failures - _maxAttemptsBeforeLockout, 5);
      final seconds = math.min(
        _initialLockout.inSeconds * (1 << exponent),
        _maxLockout.inSeconds,
      );
      lockedUntil = _now().add(Duration(seconds: seconds));
    }

    await _secureStorage.write(
      key: _pinAttemptKey(employeeId),
      value: '$failures:${lockedUntil?.millisecondsSinceEpoch ?? 0}',
    );
    return lockedUntil;
  }

  Future<void> _clearPinAttempts(int employeeId) =>
      _secureStorage.delete(key: _pinAttemptKey(employeeId));

  String _lockoutMessage(DateTime lockedUntil) {
    final remainingMs = lockedUntil.difference(_now()).inMilliseconds;
    final seconds = math.max(1, (remainingMs + 999) ~/ 1000);
    return 'Too many incorrect attempts. Try again in $seconds seconds.';
  }

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
