import 'package:database/database.dart';
import 'package:feature_settings/data/repositories/settings_repository_impl.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/repositories/settings_repository.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:talker/talker.dart';

class SettingsFeature extends AppFeature {
  const SettingsFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAO
    ProxyProvider<AgoraDatabase, AppSettingsDao>(
      update: (_, db, _) => AppSettingsDao(db),
    ),
    // Repository
    RepositoryProvider<SettingsRepository>(
      create: (ctx) => SettingsRepositoryImpl(
        logger: ctx.read<Talker>(),
        appSettingsDao: ctx.read(),
      ),
    ),
    // BLoC
    BlocProvider<SettingsCubit>(
      create: (ctx) => SettingsCubit(settingsRepository: ctx.read())..load(),
    ),
  ];
}
