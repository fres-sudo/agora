part of 'session_cubit.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState.initial() = _Initial;
  const factory SessionState.loading() = _Loading;
  const factory SessionState.authenticated({
    required SessionEmployee employee,
  }) = Authenticated;
  const factory SessionState.unauthenticated() = Unauthenticated;
  const factory SessionState.error(String message) = SessionError;
}
