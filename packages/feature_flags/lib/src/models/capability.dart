/// A shape-defining capability that a [BusinessProfile] may enable.
///
/// Unlike a paid [Feature] (gated by [SubscriptionTier]), a capability is about
/// *whether this kind of business needs it at all*. The app shell and features
/// consult the active profile to decide which UI to show.
enum Capability {
  /// Tables / floor management (table numbers on orders).
  tables,

  /// Per-order cover count ("coperto").
  covers,

  /// Dine-in order type is available.
  dineIn,

  /// Takeaway order type is available.
  takeaway,

  /// Multiple staff with PIN login (vs. single-user, no login).
  staffLogin,

  /// Stock / inventory tracking.
  inventory,

  /// Sales reports.
  reports,

  /// Discounts / promo codes.
  discounts,

  /// Route orders to a kitchen display.
  kitchenRouting,
}
