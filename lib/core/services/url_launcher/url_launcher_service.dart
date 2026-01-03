import 'package:agora/core/enums/launch_mode.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:agora/core/misc/enum_mapper.dart';

abstract class UrlLauncherService {
  Future<bool> launchUrl(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  });
  Future<bool> canLaunchUrl(Uri uri);
}

class UrlLauncherServiceImpl implements UrlLauncherService {
  const UrlLauncherServiceImpl({required this.launchModeMapper});
  final EnumMapper<LaunchMode, url_launcher.LaunchMode> launchModeMapper;

  @override
  Future<bool> canLaunchUrl(Uri uri) async {
    return url_launcher.canLaunchUrl(uri);
  }

  @override
  Future<bool> launchUrl(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    return url_launcher.launchUrl(
      uri,
      mode:
          launchModeMapper.from(mode) ??
          url_launcher.LaunchMode.platformDefault,
    );
  }
}
