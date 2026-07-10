/// Shared inventory/stock repository interface.
///
/// Lives in `packages/` because `feature_orders` and `feature_products` need
/// to read/adjust stock without depending on `feature_inventory` directly.
/// `feature_inventory` supplies the concrete `InventoryRepositoryImpl`.
library;

export 'repositories/inventory_repository.dart';
