import 'package:utils/utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class LaunchModeMapper extends EnumMapper<LaunchMode, url_launcher.LaunchMode> {
  LaunchModeMapper()
    : super({
        LaunchMode.externalApplication:
            url_launcher.LaunchMode.externalApplication,
        LaunchMode.externalNonBrowserApplication:
            url_launcher.LaunchMode.externalNonBrowserApplication,
        LaunchMode.inAppWebView: url_launcher.LaunchMode.inAppWebView,
        LaunchMode.platformDefault: url_launcher.LaunchMode.platformDefault,
      });
}
