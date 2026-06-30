import 'subscription_tier.dart';

/// A gateable capability in the app.
///
/// Each feature declares the [minimumTier] required to use it. The entitlement
/// table below is derived from the feature-to-tier matrices in
/// `docs/architecture/ECOSYSTEM.md` and `docs/architecture/AI_INTEGRATION.md`.
///
/// Features that are part of the always-available free tier (catalog, cart,
/// thermal printing, local reports, inventory) are intentionally NOT listed
/// here — they are never gated, so there is nothing to flag.
enum Feature {
  // ---------------------------------------------------------------------------
  // Cloud / sync capabilities (paid)
  // ---------------------------------------------------------------------------
  /// Push completed orders to the kitchen display over the websocket.
  kitchenSync(SubscriptionTier.paidBasic),

  /// Share a single order queue across multiple POS terminals.
  multiTerminalSync(SubscriptionTier.paidBasic),

  /// Sync sales data to the cloud for post-event analysis.
  cloudReports(SubscriptionTier.paidBasic),

  // ---------------------------------------------------------------------------
  // AI capabilities (paid) — see AI_INTEGRATION.md "Subscription gating"
  // ---------------------------------------------------------------------------
  /// Natural-language report / event wrap-up summary.
  aiReportSummary(SubscriptionTier.paidBasic),

  /// Natural-language dietary & allergy menu filter.
  aiDietaryFilter(SubscriptionTier.paidBasic),

  /// Contextual waiter upsell nudges.
  aiUpsellNudge(SubscriptionTier.paidPro),

  /// Waiting-time alerts for tables.
  aiWaitingTimeAlert(SubscriptionTier.paidPro),

  /// Smart kitchen-queue prioritisation.
  aiKitchenPrioritisation(SubscriptionTier.paidPro),

  /// Demand forecast & prep guidance.
  aiDemandForecast(SubscriptionTier.paidPro);

  const Feature(this.minimumTier);

  /// The lowest [SubscriptionTier] that unlocks this feature.
  final SubscriptionTier minimumTier;
}
