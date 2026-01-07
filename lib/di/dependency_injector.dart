import 'package:agora/core/misc/constants.dart';
import 'package:dio/dio.dart';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pine/pine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

// Core
import 'package:agora/core/blocs/url_launcher/url_launcher_bloc.dart';
import 'package:agora/core/blocs/version_checker/version_checker_bloc.dart';
import 'package:agora/core/cubits/cubits.dart';
import 'package:agora/core/database/database.dart';
import 'package:agora/core/mappers/launch_mode_mapper.dart';
import 'package:agora/core/repositories/config_repository.dart';
import 'package:agora/core/repositories/url_launcher_repository.dart';
import 'package:agora/core/repositories/version_checker_repository.dart';
import 'package:agora/core/services/config/config_service.dart';
import 'package:agora/core/services/persistence/persistence_service.dart';
import 'package:agora/core/services/url_launcher/url_launcher_service.dart';
import 'package:agora/core/services/version_checker/version_checker_service.dart';

// Auth
import 'package:agora/auth/cubits/session/session_cubit.dart';
import 'package:agora/auth/repositories/auth_repository.dart';

// Products
import 'package:agora/products/blocs/categories/categories_bloc.dart';
import 'package:agora/products/blocs/modifiers/modifiers_bloc.dart';
// ProductDetailCubit not used in global injector
import 'package:agora/products/blocs/products/products_bloc.dart';
import 'package:agora/products/repositories/categories_repository.dart';
import 'package:agora/products/repositories/modifiers_repository.dart';
import 'package:agora/products/repositories/products_repository.dart';
import 'package:agora/products/services/local/daos/categories_dao.dart';
import 'package:agora/products/services/local/daos/modifiers_dao.dart';
import 'package:agora/products/services/local/daos/products_dao.dart';

// Orders
import 'package:agora/orders/blocs/active_order/active_order_bloc.dart';
// OrderDetailCubit not used in global injector
import 'package:agora/orders/blocs/orders/orders_bloc.dart';
import 'package:agora/orders/local/daos/order_items_dao.dart';
import 'package:agora/orders/local/daos/orders_dao.dart';
import 'package:agora/orders/repositories/order_items_repository.dart';
import 'package:agora/orders/repositories/orders_repository.dart';

// Inventory
import 'package:agora/inventory/blocs/inventory/inventory_bloc.dart';
// StockAdjustmentCubit used in providers.dart via ProxyProvider
import 'package:agora/inventory/repositories/inventory_repository.dart';
import 'package:agora/inventory/services/local/daos/stock_movements_dao.dart';
import 'package:agora/inventory/services/local/daos/stocks_dao.dart';

// Discounts
// DiscountValidationCubit not use in global injector
import 'package:agora/discounts/blocs/discounts/discounts_bloc.dart';
import 'package:agora/discounts/repositories/discounts_repository.dart';
import 'package:agora/discounts/services/local/daos/discounts_dao.dart';

// Settings
import 'package:agora/settings/blocs/settings/settings_cubit.dart';
import 'package:agora/settings/repositories/settings_repository.dart';
import 'package:agora/settings/services/local/daos/app_settings_dao.dart';

part 'blocs.dart';
part 'mappers.dart';
part 'providers.dart';
part 'repositories.dart';

class DependencyInjector extends StatelessWidget {
  const DependencyInjector({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    blocs: _blocs,
    mappers: _mappers,
    providers: _providers,
    repositories: _repositories,
    child: child,
  );
}
