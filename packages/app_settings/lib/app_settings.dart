/// Shared app-settings domain — repository interface, cubit, and the
/// receipt-config builder derived from settings.
///
/// Lives in `packages/` because `feature_orders` and `feature_pos` read
/// settings (currency symbol, tax rate, enabled payment methods, receipt
/// header/footer) reactively without depending on `feature_settings`
/// directly. `feature_settings` supplies the concrete
/// `SettingsRepositoryImpl` (backed by `AppSettingsDao`).
library;

export 'repositories/settings_repository.dart';
export 'blocs/settings_cubit.dart';
export 'receipt_config_builder.dart';
