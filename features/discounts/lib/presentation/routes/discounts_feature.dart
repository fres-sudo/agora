import 'package:database/database.dart';
import 'package:feature_discounts/data/repositories/discounts_repository_impl.dart';
import 'package:feature_discounts/data/sources/local/daos/discounts_dao.dart';
import 'package:discounts/repositories/discounts_repository.dart';
import 'package:discounts/blocs/discount_validation/discount_validation_cubit.dart';
import 'package:discounts/blocs/discounts/discounts_bloc.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:talker/talker.dart';

class DiscountsFeature extends AppFeature {
  const DiscountsFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAO
    ProxyProvider<AgoraDatabase, DiscountsDao>(
      update: (_, db, _) => DiscountsDao(db),
    ),
    // Repository
    RepositoryProvider<DiscountsRepository>(
      create: (ctx) => DiscountsRepositoryImpl(
        logger: ctx.read<Talker>(),
        discountsDao: ctx.read(),
      ),
    ),
    // BLoC
    BlocProvider<DiscountsBloc>(
      create: (ctx) => DiscountsBloc(discountsRepository: ctx.read()),
    ),
    // Cubit for validating discount codes at checkout.
    BlocProvider<DiscountValidationCubit>(
      create: (ctx) => DiscountValidationCubit(discountsRepository: ctx.read()),
    ),
  ];
}
