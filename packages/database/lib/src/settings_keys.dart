/// Canonical keys for rows in `AppSettingsTable`.
///
/// Lives in `package:database` so both the settings feature (which reads them)
/// and the onboarding feature (which writes them on first-run) can share one
/// definition without depending on each other. The string values must stay in
/// sync with the constants historically declared on `AppSettingsDao`.
abstract class SettingsKeys {
  // Business identity (feeds the receipt header).
  static const String businessName = 'business_name';
  static const String businessAddress = 'business_address';
  static const String businessPhone = 'business_phone';
  static const String businessEmail = 'business_email';
  static const String businessCity = 'business_city';
  static const String businessCountry = 'business_country';

  // Fiscal / locale.
  static const String taxRate = 'tax_rate';
  static const String currencySymbol = 'currency_symbol';

  // Payment methods.
  static const String paymentMethodCashEnabled = 'payment_method_cash_enabled';
  static const String paymentMethodCardEnabled = 'payment_method_card_enabled';

  // Onboarding / profile mirror (source of truth for "done" is SharedPreferences).
  static const String businessType = 'business_type';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String singleUserMode = 'single_user_mode';
  static const String defaultOrderType = 'default_order_type';

  // LAN sync (docs/features/01-lan-sync.md). Lives here rather than on
  // AppSettingsDao because the app shell (device identity, at startup,
  // before feature_settings is necessarily relevant) and feature_settings
  // (the pairing/hosting UI) both need these without depending on
  // each other.
  static const String syncDeviceId = 'sync_device_id';
  static const String syncRole = 'sync_role'; // 'standalone'|'host'|'client'
  static const String syncHubAddress = 'sync_hub_address'; // "ip:port"
  static const String syncHubToken = 'sync_hub_token';
  static const String syncStationName = 'sync_station_name';
  static const String syncPairingPin = 'sync_pairing_pin';
}
