import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_auth/domain/models/session_employee.dart';
import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:result/result.dart';

part 'session_state.dart';
part 'session_state_utils.dart';
part 'session_cubit.freezed.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(AuthRepository authRepository)
      : _authRepository = authRepository,
        super(const SessionState.initial());

  final AuthRepository _authRepository;

  /// Called once at startup to restore any persisted session.
  Future<void> init() async {
    emit(const SessionState.loading());
    final employee = await _authRepository.loadSession();
    if (employee != null) {
      emit(SessionState.authenticated(employee: employee));
    } else {
      emit(const SessionState.unauthenticated());
    }
  }

  Future<void> loginWithPin(int employeeId, String pin) async {
    emit(const SessionState.loading());
    final result = await _authRepository.loginWithPin(employeeId, pin);
    result.when(
      success: (employee) =>
          emit(SessionState.authenticated(employee: employee)),
      error: (e) => emit(SessionState.error(e.toString())),
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const SessionState.unauthenticated());
  }

  SessionEmployee? get currentEmployee => switch (state) {
    Authenticated(:final employee) => employee,
    _ => null,
  };
}

extension SessionCubitExtension on BuildContext {
  SessionCubit get sessionCubit => read<SessionCubit>();
  SessionCubit get watchSessionCubit => watch<SessionCubit>();
}
