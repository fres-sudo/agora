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
    this.publicMenuApiBaseUrl = '',
    required this.wsBaseUrl,
    required this.bootstrapMode,
    required this.tierName,
    required this.enableLogging,
    required this.enableInspector,
    this.sumUpAffiliateKey = '',
  });

  /// The build flavor.
  final AppFlavor flavor;

  /// Human-readable app name.
  final String appName;

  /// REST API base URL. Empty string when [bootstrapMode] is local.
  final String apiBaseUrl;

  /// REST API base URL for the public-menu publisher. This is intentionally
  /// separate from [apiBaseUrl]: the publisher never receives POS data other
  /// than an explicit safe catalog snapshot.
  final String publicMenuApiBaseUrl;

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

  /// Affiliate key for the SumUp Reader SDK. Empty means unconfigured.
  final String sumUpAffiliateKey;

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
    const publicMenuApiBaseUrl = String.fromEnvironment(
      ConfigKeys.publicMenuApiBaseUrl,
    );
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
    const sumUpAffiliateKey = String.fromEnvironment(
      ConfigKeys.sumUpAffiliateKey,
    );

    return AppConfig(
      flavor: AppFlavor.fromName(flavorName),
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      publicMenuApiBaseUrl: publicMenuApiBaseUrl,
      wsBaseUrl: wsBaseUrl,
      bootstrapMode: BootstrapMode.fromName(bootstrapModeName),
      tierName: tierName,
      enableLogging: enableLogging,
      enableInspector: enableInspector,
      sumUpAffiliateKey: sumUpAffiliateKey,
    );
  }

  /// The single, lazily-evaluated configuration for this build.
  static final AppConfig current = AppConfig.fromEnvironment();

  /// Whether the app has a usable REST API base URL configured.
  bool get hasApiBaseUrl => apiBaseUrl.isNotEmpty;

  /// Whether the public-menu publisher is configured for this build.
  bool get hasPublicMenuApiBaseUrl => publicMenuApiBaseUrl.isNotEmpty;

  /// Whether the app has a usable websocket base URL configured.
  bool get hasWsBaseUrl => wsBaseUrl.isNotEmpty;

  bool get hasSumUpAffiliateKey => sumUpAffiliateKey.trim().isNotEmpty;

  AppConfig copyWith({
    AppFlavor? flavor,
    String? appName,
    String? apiBaseUrl,
    String? publicMenuApiBaseUrl,
    String? wsBaseUrl,
    BootstrapMode? bootstrapMode,
    String? tierName,
    bool? enableLogging,
    bool? enableInspector,
    String? sumUpAffiliateKey,
  }) {
    return AppConfig(
      flavor: flavor ?? this.flavor,
      appName: appName ?? this.appName,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      publicMenuApiBaseUrl: publicMenuApiBaseUrl ?? this.publicMenuApiBaseUrl,
      wsBaseUrl: wsBaseUrl ?? this.wsBaseUrl,
      bootstrapMode: bootstrapMode ?? this.bootstrapMode,
      tierName: tierName ?? this.tierName,
      enableLogging: enableLogging ?? this.enableLogging,
      enableInspector: enableInspector ?? this.enableInspector,
      sumUpAffiliateKey: sumUpAffiliateKey ?? this.sumUpAffiliateKey,
    );
  }

  @override
  String toString() =>
      'AppConfig(flavor: ${flavor.name}, appName: $appName, '
      'bootstrapMode: ${bootstrapMode.name}, tier: $tierName, '
      'apiBaseUrl: ${apiBaseUrl.isEmpty ? '<none>' : apiBaseUrl}, '
      'publicMenuApiBaseUrl: ${publicMenuApiBaseUrl.isEmpty ? '<none>' : publicMenuApiBaseUrl}, '
      'wsBaseUrl: ${wsBaseUrl.isEmpty ? '<none>' : wsBaseUrl}, '
      'sumUp: ${hasSumUpAffiliateKey ? '<configured>' : '<none>'}, '
      'enableLogging: $enableLogging, enableInspector: $enableInspector)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfig &&
          runtimeType == other.runtimeType &&
          flavor == other.flavor &&
          appName == other.appName &&
          apiBaseUrl == other.apiBaseUrl &&
          publicMenuApiBaseUrl == other.publicMenuApiBaseUrl &&
          wsBaseUrl == other.wsBaseUrl &&
          bootstrapMode == other.bootstrapMode &&
          tierName == other.tierName &&
          enableLogging == other.enableLogging &&
          enableInspector == other.enableInspector &&
          sumUpAffiliateKey == other.sumUpAffiliateKey;

  @override
  int get hashCode => Object.hash(
    flavor,
    appName,
    apiBaseUrl,
    publicMenuApiBaseUrl,
    wsBaseUrl,
    bootstrapMode,
    tierName,
    enableLogging,
    enableInspector,
    sumUpAffiliateKey,
  );
}
