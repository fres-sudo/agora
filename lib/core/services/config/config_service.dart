import 'package:agora/core/models/remote_config/remote_config.dart';

abstract interface class ConfigService {
  Future<RemoteConfig> fetch();
}

class ConfigServiceImpl extends ConfigService {
  @override
  Future<RemoteConfig> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }
}
