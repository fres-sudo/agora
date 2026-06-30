/// The build flavor the app was compiled with.
///
/// A flavor maps 1:1 to a native build configuration (distinct application id,
/// app name and icon). It is **not** the same thing as the subscription tier:
/// free vs paid is a runtime concern handled by `package:feature_flags`.
enum AppFlavor {
  /// Local development build. Points at a dev backend (or fully offline).
  dev,

  /// Pre-production / QA build against a staging backend.
  staging,

  /// Public production build.
  prod;

  /// Parses a flavor from its [name], falling back to [AppFlavor.dev] when the
  /// value is missing or unrecognised (e.g. when run without `--flavor`).
  static AppFlavor fromName(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'prod' || 'production' => AppFlavor.prod,
      'staging' || 'stg' => AppFlavor.staging,
      _ => AppFlavor.dev,
    };
  }

  bool get isDev => this == AppFlavor.dev;

  bool get isStaging => this == AppFlavor.staging;

  bool get isProd => this == AppFlavor.prod;

  /// Whether a non-production banner/affordance should be shown.
  bool get isNonProduction => this != AppFlavor.prod;
}
