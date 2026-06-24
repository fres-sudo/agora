part of 'url_launcher_bloc.dart';

@freezed
class UrlLauncherState with _$UrlLauncherState {
  const factory UrlLauncherState.checking() = _CheckingUrlLauncherState;

  const factory UrlLauncherState.launching() = _LaunchingUrlLauncherState;

  const factory UrlLauncherState.launched() = _LaunchedUrlLauncherState;

  const factory UrlLauncherState.error() = _ErrorUrlLauncherState;
}
