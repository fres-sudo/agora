import 'package:talker/talker.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/core/models/remote_config/remote_config.dart';
import 'package:agora/core/services/config/config_service.dart';
import 'package:agora/core/misc/repository.dart';

abstract interface class ConfigRepository {
  Future<Result<RemoteConfig>> fetch();
}

class ConfigRepositoryImpl extends Repository implements ConfigRepository {
  const ConfigRepositoryImpl({required this.service, required Talker logger})
    : super(logger);

  final ConfigService service;

  @override
  Future<Result<RemoteConfig>> fetch() =>
      safe('fetch', () async => await service.fetch());
}
