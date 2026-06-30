/// How the app should bootstrap and which runtime services it wires.
///
/// This is orthogonal to [AppFlavor]: any flavor can run in either mode, though
/// in practice `dev`/`staging`/`prod` default to [hybrid] and the free festival
/// build runs [local].
enum BootstrapMode {
  /// Fully offline. No backend, no sync engine, no websocket. The app relies
  /// solely on the local Drift database. This is the free festival tier.
  local,

  /// Backend-connected. The app additionally configures the REST client base
  /// URL and starts the sync engine / websocket for real-time features.
  hybrid;

  /// Parses a mode from its [name], defaulting to [BootstrapMode.local] so the
  /// app is always safe to launch offline when configuration is absent.
  static BootstrapMode fromName(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'hybrid' || 'cloud' || 'online' => BootstrapMode.hybrid,
      _ => BootstrapMode.local,
    };
  }

  bool get isLocal => this == BootstrapMode.local;

  bool get isHybrid => this == BootstrapMode.hybrid;
}
