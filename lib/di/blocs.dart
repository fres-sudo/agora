part of 'dependency_injector.dart';

final List<BlocProvider> _blocs = [
  BlocProvider<ThemeCubit>(
    create: (context) =>
        ThemeCubit(persistenceService: context.read<PersistenceService>())
          ..load(),
  ),
  BlocProvider<VersionCheckerBloc>(
    create: (context) => VersionCheckerBloc(
      versionCheckerRepository: context.read<VersionCheckerRepository>(),
    ),
  ),
  BlocProvider<UrlLauncherBloc>(
    create: (context) => UrlLauncherBloc(
      urlLauncherRepository: context.read<UrlLauncherRepository>(),
    ),
  ),
  BlocProvider<SessionCubit>(
    create: (context) => SessionCubit(context.read<AuthRepository>()),
  ),
  BlocProvider<ConfigCubit>(
    create: (context) =>
        ConfigCubit(configRepository: context.read<ConfigRepository>()),
  ),
];
