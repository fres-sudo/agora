import 'package:result/result.dart';
import 'package:talker/talker.dart';
import '../models/remote_config/remote_config.dart';
import '../services/config_service.dart';

abstract interface class ConfigRepository {
  Future<Result<RemoteConfig>> fetch();
}

class ConfigRepositoryImpl extends Repository implements ConfigRepository {
  const ConfigRepositoryImpl({required this.service, required Talker logger})
    : super(logger);

  final ConfigService service;

  @override
  Future<Result<RemoteConfig>> fetch() => safe('fetch', () => service.fetch());
}
