import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

abstract class VersionCheckerService {
  Future<String> get currentVersion;
  Future<String> get currentBuild;
  Future<String> get currentPlatform;
}

class VersionCheckerServiceImpl implements VersionCheckerService {
  const VersionCheckerServiceImpl();
  @override
  Future<String> get currentVersion async =>
      (await PackageInfo.fromPlatform()).version;

  @override
  Future<String> get currentBuild async =>
      (await PackageInfo.fromPlatform()).buildNumber;

  @override
  Future<String> get currentPlatform async => Platform.operatingSystem;
}
