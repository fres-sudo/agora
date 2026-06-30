/// Canonical names of the `--dart-define` keys consumed by [AppConfig].
///
/// These MUST stay in sync with the JSON files under `config/*.json` that are
/// passed to the app via `--dart-define-from-file`. Keeping the key strings in
/// one place avoids silent drift between the Dart side and the env files.
abstract final class ConfigKeys {
  /// Build flavor name: `dev` | `staging` | `prod`.
  static const String flavor = 'FLAVOR';

  /// Human-readable application name (used for the window/app title).
  static const String appName = 'APP_NAME';

  /// Base URL of the REST API. Empty when running fully local.
  static const String apiBaseUrl = 'API_BASE_URL';

  /// Base URL of the realtime websocket. Empty when running fully local.
  static const String wsBaseUrl = 'WS_BASE_URL';

  /// Bootstrap mode: `local` | `hybrid`.
  static const String bootstrapMode = 'BOOTSTRAP_MODE';

  /// Default subscription tier: `free` | `paidBasic` | `paidPro`.
  ///
  /// This is the *initial* tier baked into the build. The actual entitlement at
  /// runtime is owned by `package:feature_flags` and may be overridden (e.g. by
  /// a backend subscription check or a developer toggle).
  static const String tier = 'TIER';

  /// Whether verbose logging is enabled.
  static const String enableLogging = 'ENABLE_LOGGING';

  /// Whether the in-app inspector / debug tooling is enabled.
  static const String enableInspector = 'ENABLE_INSPECTOR';
}
