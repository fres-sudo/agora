import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:database/database.dart';
import 'package:feature_workforce/data/repositories/workforce_repository_impl.dart';
import 'package:feature_workforce/data/sources/local/daos/clock_records_dao.dart';
import 'package:feature_workforce/data/sources/local/daos/employees_dao.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';
import 'package:feature_workforce/presentation/blocs/clock_in/clock_in_cubit.dart';
import 'package:feature_workforce/presentation/blocs/employees/employees_bloc.dart';
import 'package:feature_workforce/presentation/routes/workforce_router.dart';
import 'package:talker/talker.dart';

class WorkforceFeature extends AppFeature {
  const WorkforceFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, EmployeesDao>(
      update: (_, db, _) => EmployeesDao(db),
    ),
    ProxyProvider<AgoraDatabase, ClockRecordsDao>(
      update: (_, db, _) => ClockRecordsDao(db),
    ),
    // Repository
    RepositoryProvider<WorkforceRepository>(
      create: (ctx) => WorkforceRepositoryImpl(
        employeesDao: ctx.read(),
        clockRecordsDao: ctx.read(),
        logger: ctx.read<Talker>(),
      ),
    ),
    // BLoCs
    BlocProvider<EmployeesBloc>(
      create: (ctx) =>
          EmployeesBloc(workforceRepository: ctx.read<WorkforceRepository>()),
    ),
    BlocProvider<ClockInCubit>(
      create: (ctx) =>
          ClockInCubit(workforceRepository: ctx.read<WorkforceRepository>()),
    ),
  ];

  static List<AutoRoute> get routes => [
    AutoRoute(page: EmployeesRoute.page),
    AutoRoute(page: ClockRecordsRoute.page),
  ];
}
