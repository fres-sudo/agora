import 'package:bloc_exports/bloc_exports.dart';
import 'package:database/database.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feature_onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:feature_onboarding/domain/repositories/onboarding_repository.dart';
import 'package:feature_onboarding/presentation/blocs/onboarding_cubit.dart';
import 'package:talker/talker.dart';
import 'package:utils/utils.dart';

class OnboardingFeature {
  static List<SingleChildWidget> get providers => [
    RepositoryProvider<OnboardingRepository>(
      create: (ctx) => OnboardingRepositoryImpl(
        database: ctx.read<AgoraDatabase>(),
        persistenceService: ctx.read<PersistenceService>(),
        businessProfileRepository: ctx.read<BusinessProfileRepository>(),
        authRepository: ctx.read<AuthRepository>(),
        logger: ctx.read<Talker>(),
      ),
    ),
    BlocProvider<OnboardingCubit>(
      create: (ctx) =>
          OnboardingCubit(repository: ctx.read<OnboardingRepository>()),
    ),
  ];
}
