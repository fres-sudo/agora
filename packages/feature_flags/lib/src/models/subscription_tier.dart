/// The subscription tier a tenant is on.
///
/// Mirrors the tiers described in `docs/architecture/AI_INTEGRATION.md` and
/// `docs/architecture/ECOSYSTEM.md`:
///
/// | Tier        | Meaning                                              |
/// |-------------|------------------------------------------------------|
/// | [free]      | Festival free tier — fully local, no cloud features. |
/// | [paidBasic] | Paid basic — report/event summary, cloud reports.    |
/// | [paidPro]   | Paid pro / Restaurant SaaS — everything unlocked.    |
enum SubscriptionTier {
  free,
  paidBasic,
  paidPro;

  /// Parses a tier from a raw name (e.g. [AppConfig.tierName]).
  ///
  /// Accepts a few spellings for ergonomics and defaults to [free] so the app
  /// degrades safely to the offline tier when configuration is missing.
  static SubscriptionTier fromName(String? value) {
    return switch (value?.trim().toLowerCase().replaceAll('_', '')) {
      'paidpro' || 'pro' || 'saas' => SubscriptionTier.paidPro,
      'paidbasic' || 'basic' || 'paid' => SubscriptionTier.paidBasic,
      _ => SubscriptionTier.free,
    };
  }

  bool get isFree => this == SubscriptionTier.free;

  bool get isPaid => this != SubscriptionTier.free;

  /// Ordinal rank used for "at least this tier" comparisons.
  int get rank => switch (this) {
    SubscriptionTier.free => 0,
    SubscriptionTier.paidBasic => 1,
    SubscriptionTier.paidPro => 2,
  };

  /// Whether this tier is at least as high as [other].
  bool isAtLeast(SubscriptionTier other) => rank >= other.rank;
}
