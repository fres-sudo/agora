import 'package:database/database.dart';
import 'package:feature_kitchen/data/repositories/tickets_repository_impl.dart';
import 'package:feature_kitchen/data/sources/local/daos/tickets_dao.dart';
import 'package:kitchen/kitchen.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

class KitchenFeature extends AppFeature {
  const KitchenFeature();

  @override
  List<SingleChildWidget> get providers => [
    ProxyProvider<AgoraDatabase, TicketsDao>(
      update: (_, db, _) => TicketsDao(db),
    ),
    RepositoryProvider<TicketsRepository>(
      create: (ctx) => TicketsRepositoryImpl(
        logger: ctx.read<Talker>(),
        ticketsDao: ctx.read(),
        syncManager: ctx.read<SyncManager>(),
        deviceId: ctx.read<DeviceId>(),
      ),
    ),
  ];
}
