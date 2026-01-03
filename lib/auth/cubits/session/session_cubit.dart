import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:agora/auth/repositories/auth_repository.dart';
import 'package:agora/core/misc/result.dart';

part 'session_state.dart';
part 'session_state_utils.dart';

part 'session_cubit.freezed.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._authRepository) : super(const SessionState.initial()) {
    // _authSubscription = _authRepository.userStream.listen((user) {
    //   if (user != null) {
    //     emit(SessionState.authenticated(user: user));
    //   } else {
    //     emit(const SessionState.unauthenticated());
    //   }
    // });
  }

  final AuthRepository _authRepository;
  // late final StreamSubscription<AppUser?> _authSubscription;

  // Future<void> signOut() async => await _authRepository.signOut().unwrapAsync();

  @override
  Future<void> close() {
    // _authSubscription.cancel();
    return super.close();
  }
}

extension SessionCubitExtension on BuildContext {
  SessionCubit get sessionCubit => read<SessionCubit>();

  SessionCubit get watchSessionCubit => watch<SessionCubit>();
}
