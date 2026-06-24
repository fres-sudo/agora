import 'package:result/result.dart';
import 'package:utils/utils.dart';
import '../services/url_launcher_service.dart';

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
