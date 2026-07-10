import 'package:bloc_exports/bloc_exports.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:feature_reports/data/repositories/reports_repository_impl.dart';
import 'package:feature_reports/domain/repositories/reports_repository.dart';
import 'package:feature_reports/presentation/blocs/reports/reports_cubit.dart';
import 'package:talker/talker.dart';

/// Reports reads from the orders and products repositories registered by those
/// features, so [providers] must be composed **after** `OrdersFeature` and
/// `ProductsFeature` in the app shell.
class ReportsFeature extends AppFeature {
  const ReportsFeature();

  @override
  List<SingleChildWidget> get providers => [
    RepositoryProvider<ReportsRepository>(
      create: (ctx) => ReportsRepositoryImpl(
        ordersRepository: ctx.read<OrdersRepository>(),
        productsRepository: ctx.read<ProductsRepository>(),
        logger: ctx.read<Talker>(),
      ),
    ),
    BlocProvider<ReportsCubit>(
      create: (ctx) =>
          ReportsCubit(reportsRepository: ctx.read<ReportsRepository>())
            ..load(),
    ),
  ];
}
