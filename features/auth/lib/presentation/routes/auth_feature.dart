import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:feature_auth/presentation/blocs/session/session_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';

class AuthFeature {
  static List<SingleChildWidget> get providers => [
    RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
    BlocProvider<SessionCubit>(
      create: (ctx) => SessionCubit(ctx.read<AuthRepository>()),
    ),
  ];
}
