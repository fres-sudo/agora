part of 'config_cubit.dart';

@freezed
sealed class ConfigState with _$ConfigState {
  const factory ConfigState.loading() = LoadingConfigState;

  const factory ConfigState.fetched(RemoteConfig config) = FetchedConfigState;

  const factory ConfigState.error(String message) = ErrorConfigState;
}
