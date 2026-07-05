/// The kind of business the operator runs.
///
/// Chosen once during onboarding, this is the pivotal decision that drives the
/// active [BusinessProfile] — which capabilities and navigation tabs the app
/// exposes, and the defaults onboarding pre-fills.
///
/// It is an orthogonal axis to [SubscriptionTier]: the tier controls *paid*
/// entitlements, the business type controls *shape*. See
/// `docs/architecture/ECOSYSTEM.md`.
enum BusinessType {
  /// Full table service — dine-in with tables/covers, staff, coursing.
  restaurant,

  /// Fast counter service — tabs, drinks-oriented, lighter table use.
  barCafe,

  /// Counter + takeaway only — no tables, minimal staff, fast checkout.
  quickService,

  /// Event/festival stall — fully offline, cash-first, single operator.
  festival;

  /// Parses a type from a raw name (e.g. a persisted value). Defaults to
  /// [restaurant] — the richest profile — when the value is missing/unknown.
  static BusinessType fromName(String? value) {
    return switch (value?.trim().toLowerCase().replaceAll('_', '')) {
      'barcafe' || 'bar' || 'cafe' => BusinessType.barCafe,
      'quickservice' || 'quick' || 'takeaway' => BusinessType.quickService,
      'festival' || 'event' => BusinessType.festival,
      _ => BusinessType.restaurant,
    };
  }

  /// A short, human-friendly label for the type.
  String get label => switch (this) {
    BusinessType.restaurant => 'Restaurant',
    BusinessType.barCafe => 'Bar / Café',
    BusinessType.quickService => 'Quick service',
    BusinessType.festival => 'Festival / Event',
  };
}
