import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/core/services/version_checker/version_checker_service.dart';

abstract class VersionCheckerRepository {
  Future<String> get currentVersion;
  Future<String> get currentBuild;
  Future<String> get currentPlatform;
}

class VersionCheckerRepositoryImpl extends Repository
    implements VersionCheckerRepository {
  const VersionCheckerRepositoryImpl({required this.versionCheckerService});
  final VersionCheckerService versionCheckerService;

  @override
  Future<String> get currentVersion =>
      safe(
        'currentVersion',
        () async => await versionCheckerService.currentVersion,
      ).unwrapAsync();

  @override
  Future<String> get currentBuild =>
      safe(
        'currentBuild',
        () async => await versionCheckerService.currentBuild,
      ).unwrapAsync();

  @override
  Future<String> get currentPlatform =>
      safe(
        'currentPlatform',
        () async => await versionCheckerService.currentPlatform,
      ).unwrapAsync();
}
