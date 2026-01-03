import 'package:agora/core/enums/launch_mode.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/services/url_launcher/url_launcher_service.dart';

abstract class UrlLauncherRepository {
  Future<Result<bool>> launchUrl(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  });
  Future<Result<bool>> canLaunchUrl(Uri uri);
}

class UrlLauncherRepositoryImpl extends Repository
    implements UrlLauncherRepository {
  const UrlLauncherRepositoryImpl({required this.urlLauncherService});
  final UrlLauncherService urlLauncherService;

  @override
  Future<Result<bool>> canLaunchUrl(Uri uri) => safe(
    'canLaunchUrl',
    () async => await urlLauncherService.canLaunchUrl(uri),
  );

  @override
  Future<Result<bool>> launchUrl(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) => safe(
    'launchUrl',
    () async => await urlLauncherService.launchUrl(uri, mode: mode),
  );
}
