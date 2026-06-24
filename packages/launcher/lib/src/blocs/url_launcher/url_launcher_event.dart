part of 'url_launcher_bloc.dart';

@freezed
sealed class UrlLauncherEvent with _$UrlLauncherEvent {
  const factory UrlLauncherEvent.execute(
    Uri uri, {
    @Default(LaunchMode.platformDefault) LaunchMode mode,
  }) = ExecuteUrlLauncherEvent;
}
