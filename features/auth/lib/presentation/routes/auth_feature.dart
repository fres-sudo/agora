import 'package:database/database.dart';
import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:feature_auth/data/sources/local/daos/auth_dao.dart';
import 'package:auth_session/repositories/auth_repository.dart';
import 'package:auth_session/blocs/session_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker/talker.dart';

class AuthFeature extends AppFeature {
  const AuthFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAO
    ProxyProvider<AgoraDatabase, AuthDao>(update: (_, db, _) => AuthDao(db)),
    // Repository
    RepositoryProvider<AuthRepository>(
      create: (ctx) => AuthRepositoryImpl(
        authDao: ctx.read<AuthDao>(),
        secureStorage: ctx.read<FlutterSecureStorage>(),
        logger: ctx.read<Talker>(),
      ),
    ),
    // Session cubit — initialized at startup by the app shell
    BlocProvider<SessionCubit>(
      create: (ctx) => SessionCubit(ctx.read<AuthRepository>()),
    ),
  ];
}
