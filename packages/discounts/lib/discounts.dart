/// Shared discount domain — model, repository interface, and CRUD/validation
/// blocs.
///
/// Lives in `packages/` because it is consumed by `feature_orders`,
/// `feature_pos`, and `feature_settings` in addition to `feature_discounts`
/// itself (which supplies the concrete `DiscountsRepositoryImpl`).
library;

export 'models/discount.dart';
export 'repositories/discounts_repository.dart';
export 'blocs/discounts/discounts_bloc.dart';
export 'blocs/discount_validation/discount_validation_cubit.dart';
