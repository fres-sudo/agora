import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:feature_auth/presentation/blocs/session/session_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:result/result.dart';

class AuthFeature {
  static List<SingleChildWidget> get providers => [
    RepositoryProvider<AuthRepository>(
      create: (_) => AuthRepositoryImpl(),
    ),
    BlocProvider<SessionCubit>(
      create: (ctx) => SessionCubit(ctx.read<AuthRepository>()),
    ),
  ];
}
