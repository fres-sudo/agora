part of 'version_checker_bloc.dart';

@freezed
class VersionCheckerState with _$VersionCheckerState {
  const factory VersionCheckerState.checkingVersion() =
      CheckingVersionVersionCheckerState;

  const factory VersionCheckerState.lockedVersion() =
      LockedVersionVersionCheckerState;

  const factory VersionCheckerState.deprecatedVersion() =
      DeprecatedVersionVersionCheckerState;

  const factory VersionCheckerState.activeVersion() =
      ActiveVersionVersionCheckerState;

  const factory VersionCheckerState.errorCheckingVersion() =
      ErrorCheckingVersionVersionCheckerState;

  const factory VersionCheckerState.gettingAppInfo() =
      GettingAppInfoVersionCheckerState;

  const factory VersionCheckerState.gotAppInfo({
    required String version,
    required String build,
    required String platform,
  }) = GotAppInfoVersionCheckerState;

  const factory VersionCheckerState.errorGettingAppInfo() =
      ErrorGettingAppInfoVersionCheckerState;
}
