/// Shared order-taking domain — models, repository interface, receipt
/// mapper, and the active-order/checkout blocs.
///
/// Lives in `packages/` because `feature_pos` (the order-taking screen) and
/// `feature_reports` need this without depending on `feature_orders`
/// directly. `feature_orders` supplies the concrete `OrdersRepositoryImpl`
/// plus its own internal `OrdersBloc`/`OrderDetailCubit` (used only by its
/// own order-list/order-detail pages, so those stay feature-local).
library;

export 'models/order.dart';
export 'models/order_line_item.dart';
export 'models/order_type.dart';
export 'models/payment_method.dart';
export 'models/selected_modifiers.dart';

export 'repositories/orders_repository.dart';

export 'mappers/order_receipt_mapper.dart';

export 'blocs/active_order/active_order_bloc.dart';
export 'blocs/checkout/checkout_cubit.dart';
