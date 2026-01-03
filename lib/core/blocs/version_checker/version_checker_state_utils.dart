part of 'version_checker_bloc.dart';

String readVersion(VersionCheckerState state) => switch (state) {
  GotAppInfoVersionCheckerState() => state.version,
  _ => '-.-.-',
};
