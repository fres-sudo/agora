part of 'session_cubit.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState.initial() = _Initial;
  const factory SessionState.authenticated() = Authenticated;
  const factory SessionState.unauthenticated() = Unauthenticated;
}
