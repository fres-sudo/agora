import 'package:flutter/foundation.dart';

import 'bootstrap_mode.dart';
import 'config_keys.dart';
import 'flavor.dart';

/// Immutable, compile-time application configuration.
///
/// Every value is resolved from `--dart-define` (typically supplied via
/// `--dart-define-from-file=config/<env>.json`). Reading from the environment
/// means the values are baked into the binary at build time: there is no async
/// I/O at startup and no secrets shipped inside the asset bundle.
///
/// Usage:
/// ```dart
/// final config = AppConfig.current;
/// if (config.bootstrapMode.isHybrid) {
///   dio.options.baseUrl = config.apiBaseUrl;
/// }
/// ```
@immutable
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.bootstrapMode,
    required this.tierName,
    required this.enableLogging,
    required this.enableInspector,
  });

  /// The build flavor.
  final AppFlavor flavor;

  /// Human-readable app name.
  final String appName;

  /// REST API base URL. Empty string when [bootstrapMode] is local.
  final String apiBaseUrl;

  /// Realtime websocket base URL. Empty string when [bootstrapMode] is local.
  final String wsBaseUrl;

  /// Whether the app runs fully offline or backend-connected.
  final BootstrapMode bootstrapMode;

  /// Raw default subscription tier name (`free` | `paidBasic` | `paidPro`).
  ///
  /// Kept as a [String] so `package:config` carries no entitlement logic and
  /// never depends on `package:feature_flags`. The feature-flags layer parses
  /// this into its own `SubscriptionTier` enum.
  final String tierName;

  /// Whether verbose logging is enabled.
  final bool enableLogging;

  /// Whether the in-app inspector / debug tooling is enabled.
  final bool enableInspector;

  /// Builds the config from the compile-time environment.
  ///
  /// Defaults are deliberately offline-and-safe so that launching without any
  /// `--dart-define-from-file` still yields a runnable, fully-local dev build.
  factory AppConfig.fromEnvironment() {
    const flavorName = String.fromEnvironment(ConfigKeys.flavor);
    const appName = String.fromEnvironment(
      ConfigKeys.appName,
      defaultValue: 'Agora',
    );
    const apiBaseUrl = String.fromEnvironment(ConfigKeys.apiBaseUrl);
    const wsBaseUrl = String.fromEnvironment(ConfigKeys.wsBaseUrl);
    const bootstrapModeName = String.fromEnvironment(ConfigKeys.bootstrapMode);
    const tierName = String.fromEnvironment(
      ConfigKeys.tier,
      defaultValue: 'free',
    );
    const enableLogging = bool.fromEnvironment(
      ConfigKeys.enableLogging,
      defaultValue: true,
    );
    const enableInspector = bool.fromEnvironment(ConfigKeys.enableInspector);

    return AppConfig(
      flavor: AppFlavor.fromName(flavorName),
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      wsBaseUrl: wsBaseUrl,
      bootstrapMode: BootstrapMode.fromName(bootstrapModeName),
      tierName: tierName,
      enableLogging: enableLogging,
      enableInspector: enableInspector,
    );
  }

  /// The single, lazily-evaluated configuration for this build.
  static final AppConfig current = AppConfig.fromEnvironment();

  /// Whether the app has a usable REST API base URL configured.
  bool get hasApiBaseUrl => apiBaseUrl.isNotEmpty;

  /// Whether the app has a usable websocket base URL configured.
  bool get hasWsBaseUrl => wsBaseUrl.isNotEmpty;

  AppConfig copyWith({
    AppFlavor? flavor,
    String? appName,
    String? apiBaseUrl,
    String? wsBaseUrl,
    BootstrapMode? bootstrapMode,
    String? tierName,
    bool? enableLogging,
    bool? enableInspector,
  }) {
    return AppConfig(
      flavor: flavor ?? this.flavor,
      appName: appName ?? this.appName,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      wsBaseUrl: wsBaseUrl ?? this.wsBaseUrl,
      bootstrapMode: bootstrapMode ?? this.bootstrapMode,
      tierName: tierName ?? this.tierName,
      enableLogging: enableLogging ?? this.enableLogging,
      enableInspector: enableInspector ?? this.enableInspector,
    );
  }

  @override
  String toString() =>
      'AppConfig(flavor: ${flavor.name}, appName: $appName, '
      'bootstrapMode: ${bootstrapMode.name}, tier: $tierName, '
      'apiBaseUrl: ${apiBaseUrl.isEmpty ? '<none>' : apiBaseUrl}, '
      'wsBaseUrl: ${wsBaseUrl.isEmpty ? '<none>' : wsBaseUrl}, '
      'enableLogging: $enableLogging, enableInspector: $enableInspector)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfig &&
          runtimeType == other.runtimeType &&
          flavor == other.flavor &&
          appName == other.appName &&
          apiBaseUrl == other.apiBaseUrl &&
          wsBaseUrl == other.wsBaseUrl &&
          bootstrapMode == other.bootstrapMode &&
          tierName == other.tierName &&
          enableLogging == other.enableLogging &&
          enableInspector == other.enableInspector;

  @override
  int get hashCode => Object.hash(
    flavor,
    appName,
    apiBaseUrl,
    wsBaseUrl,
    bootstrapMode,
    tierName,
    enableLogging,
    enableInspector,
  );
}
