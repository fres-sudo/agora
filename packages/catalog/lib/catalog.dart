/// Shared product catalog domain — models, repository interfaces, and CRUD
/// blocs for products, categories, and modifiers.
///
/// Lives in `packages/` (rather than `features/products`) because it is
/// consumed by multiple features (`feature_orders`, `feature_pos`,
/// `feature_reports`, `feature_settings`) that must never import
/// `feature_products` directly. `feature_products` itself depends on this
/// package and supplies the concrete data-layer implementation
/// (`ProductsRepositoryImpl` etc.) plus catalog-only presentation (product
/// form, product detail).
library;

export 'models/category.dart';
export 'models/modifier_group.dart';
export 'models/modifier_option.dart';
export 'models/product.dart';
export 'models/product_status.dart';

export 'repositories/categories_repository.dart';
export 'repositories/modifiers_repository.dart';
export 'repositories/products_repository.dart';

export 'blocs/categories/categories_bloc.dart';
export 'blocs/modifiers/modifiers_bloc.dart';
export 'blocs/products/products_bloc.dart';
