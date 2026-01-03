part of 'dependency_injector.dart';

final List<RepositoryProvider<dynamic>> _repositories = [
  RepositoryProvider<VersionCheckerRepository>(
    create: (context) => VersionCheckerRepositoryImpl(
      versionCheckerService: context.read<VersionCheckerService>(),
    ),
  ),
  RepositoryProvider<UrlLauncherRepository>(
    create: (context) => UrlLauncherRepositoryImpl(
      urlLauncherService: context.read<UrlLauncherService>(),
    ),
  ),
  RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImpl()),
  RepositoryProvider<ConfigRepository>(
    create: (context) => ConfigRepositoryImpl(
      logger: context.read<Talker>(),
      service: context.read<ConfigService>(),
    ),
  ),
];
