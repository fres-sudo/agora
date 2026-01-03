part of 'version_checker_bloc.dart';

@freezed
class VersionCheckerEvent with _$VersionCheckerEvent {
  
  const factory VersionCheckerEvent.checkVersion() = CheckVersionVersionCheckerEvent;

  const factory VersionCheckerEvent.getAppInfo() = GetAppInfoVersionCheckerEvent;

}
