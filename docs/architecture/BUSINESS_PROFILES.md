# Agora — Business Profiles & Vertical Switching

> **Status:** design decision. The subscription-tier axis described here **exists**
> today in `packages/feature_flags`. The **business-profile axis** is **proposed**
> and not yet implemented — this doc specifies how it should be built.

## Purpose

Agora targets multiple hospitality verticals — festivals, bars, pubs, restaurants
— from **one Flutter codebase**. This document records *how a single app adapts to
each business type* and, crucially, why that adaptation is handled by **feature
flags / configuration**, not by separate apps or separate packages per vertical.

---

## 1. The decision, in one line

> **One POS app. A "business type" is a preset of feature flags plus a catalog
> template — never a separate app, a separate build, or a separate package.**

We explicitly rejected two tempting-but-wrong alternatives:

| Rejected approach | Why it fails for a solo dev |
|---|---|
| **One app per vertical** (`bar_app`, `restaurant_app`, …) | ~90% duplicated code; every bug fixed N times; combinatorial blow-up as verticals grow; a hybrid venue (gastropub = bar + kitchen) fits none of them. |
| **One app with `if (type == bar)` branches everywhere** | This is the "bloat" we're trying to avoid — vertical logic smeared across the UI, untestable, impossible to extend cleanly. |

The chosen middle path — **module composition gated by declarative flags** — gives
us a single binary *and* a lean, uncluttered UX per vertical.

---

## 2. Two separate axes — do not conflate them

The most important idea in this document: switching behaviour splits along **two
independent axes**. Almost every design mistake here comes from merging them.

### Axis A — Role / device (→ *separate apps*)

Different hardware, different users, different UX. These legitimately are different
Flutter apps (see `ECOSYSTEM.md`):

`apps/pos` · `apps/kitchen` · `apps/waiter` · `apps/totem` · `apps/client_app`

> Build a new app on this axis **only when a real paying customer needs it.** Do
> not pre-build all six.

### Axis B — Vertical / business type (→ *feature flags*)

Same device, same core workflow, different *configuration*. A bar and a restaurant
both do: catalog → cart → modifiers → payment → receipt → report. The differences
(tabs, table maps, coursing, drinks vs food catalogs) are **data and toggles, not
different software.**

`festival` · `bar` · `pub` · `restaurant` · *(future: food_truck, bakery, …)*

**This document is about Axis B.** Axis B is *never* a reason for a new app or a
new package.

---

## 3. The mechanism: two orthogonal flag axes

Gating is the **intersection of two questions**:

1. **Does my business _use_ this?** → the **business profile** (Axis B)
2. **Have I _paid_ for this?** → the **subscription tier** (already implemented)

A capability is shown only when **both** are true:

```
capability is active  ⇔  businessProfile.enables(capability)
                          AND  tier.unlocks(capability)
```

### 3a. Tier axis — already exists

`packages/feature_flags` today models entitlement by subscription tier only:

```dart
// packages/feature_flags/lib/src/models/subscription_tier.dart
enum SubscriptionTier { free, paidBasic, paidPro }

// packages/feature_flags/lib/src/models/feature.dart
enum Feature {
  kitchenSync(SubscriptionTier.paidBasic),
  multiTerminalSync(SubscriptionTier.paidBasic),
  cloudReports(SubscriptionTier.paidBasic),
  // … AI features …
}

// packages/feature_flags/lib/src/feature_flags.dart
bool isEnabled(Feature f) => tier.isAtLeast(f.minimumTier);
```

This answers *"have I paid for it?"* It says **nothing** about what kind of
business the operator runs — that is the gap the business-profile axis fills.

### 3b. Business-profile axis — proposed

Add a second enum and a preset that maps a business type to the set of
**vertical capabilities** it uses. A capability here is a business-shaped module
(tabs, tables, coursing…), distinct from the paid/cloud `Feature`s above.

```dart
/// The kind of venue the operator runs. Selected once at onboarding,
/// persisted locally, and (later) synced from the backend tenant record.
enum BusinessType { festival, bar, pub, restaurant }

/// A vertical capability — a business-shaped module some venues use and
/// others don't. Orthogonal to the paid `Feature` enum.
enum Capability {
  quickSale,   // one-tap sell, no table  → festival, bar
  tabs,        // open running tab         → bar, pub
  tables,      // floor map + sessions     → restaurant, (pub)
  coursing,    // fire courses             → restaurant
  reservations,// bookings                 → restaurant
}

/// A profile = the preset of capabilities a business type enables,
/// plus its default catalog template. This is the whole of "switching".
@immutable
class BusinessProfile {
  const BusinessProfile({required this.type, required this.capabilities});

  final BusinessType type;
  final Set<Capability> capabilities;

  bool enables(Capability c) => capabilities.contains(c);

  /// The presets. Adding a vertical = adding one entry here. Nothing else.
  static const presets = <BusinessType, BusinessProfile>{
    BusinessType.festival: BusinessProfile(
      type: BusinessType.festival,
      capabilities: {Capability.quickSale},
    ),
    BusinessType.bar: BusinessProfile(
      type: BusinessType.bar,
      capabilities: {Capability.quickSale, Capability.tabs},
    ),
    BusinessType.pub: BusinessProfile(
      type: BusinessType.pub,
      capabilities: {Capability.quickSale, Capability.tabs, Capability.tables},
    ),
    BusinessType.restaurant: BusinessProfile(
      type: BusinessType.restaurant,
      capabilities: {
        Capability.tables,
        Capability.coursing,
        Capability.reservations,
      },
    ),
  };
}
```

### 3c. Combining the two axes

Extend the existing `FeatureFlags` value object to carry **both** the tier and the
profile, so the widget tree consults a single source of truth:

```dart
@immutable
class FeatureFlags {
  const FeatureFlags({required this.tier, required this.profile});

  final SubscriptionTier tier;
  final BusinessProfile profile;

  /// Paid/cloud feature: gated by tier only (unchanged behaviour).
  bool isEnabled(Feature f) => tier.isAtLeast(f.minimumTier);

  /// Vertical capability: gated by the business profile.
  bool has(Capability c) => profile.enables(c);
}
```

`FeatureFlagsCubit` already exposes `setTier(...)` for runtime override; add a
parallel `setBusinessType(...)` that swaps in `BusinessProfile.presets[type]`.
Both are persisted by `FeatureFlagsRepository` and, later, hydrated from the
backend tenant record.

---

## 4. How switching shows up in the app

The vertical never appears as a branch on `BusinessType`. Widgets and feature
registration ask about a **capability**, and the profile answers:

```dart
// Presentation — gate UI on a capability, not on the vertical.
BlocBuilder<FeatureFlagsCubit, FeatureFlags>(
  builder: (context, flags) => flags.has(Capability.tables)
      ? const FloorMapButton()
      : const SizedBox.shrink(),
);
```

```dart
// Feature registration — mount a module only when the profile uses it.
class TablesFeature {
  static List<SingleChildWidget> providers(FeatureFlags flags) =>
      flags.has(Capability.tables) ? [/* …tables providers… */] : const [];
}
```

There is **no `if (businessType == bar)` anywhere in feature code.** The only place
that knows about concrete business types is the preset table in
`BusinessProfile.presets` and the onboarding screen.

---

## 5. Packages: split by *capability*, never by *vertical*

The corollary that governs package layout:

> **Split a package when the _code/behaviour_ differs. Use configuration/data when
> only the _values or defaults_ differ.**

Run "bar vs restaurant products" through the test: the model, DAO, repository, and
CRUD flow are identical; only the seeded catalog and a few optional attributes
differ. That is *data*, so it stays in **one `products` package**.

- ❌ `bar_products`, `festival_products`, `restaurant_products`
- ❌ `if (businessType == bar)` inside `products`
- ✅ one `products` package; vertical variation expressed as **optional model
  traits** that are simply absent when unused:

```dart
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required Money price,
    required CategoryId categoryId,
    @Default([]) List<ModifierGroup> modifiers,
    // Optional capabilities — populated by the catalog template, not by a branch.
    ServingSize? servingSize, // drinks: 0.2L / pint  → bar/pub
    PrepStation? prepStation, // kitchen routing       → restaurant
    CourseGroup? course,      // coursing              → restaurant
    bool? ageRestricted,      // alcohol
  }) = _Product;
}
```

A separate package is justified **only when a new _capability_ appears** (e.g.
`tables`, `tabs`, `coursing`) — and it is named after the capability, not the
industry. A bar *enables* `tabs`; there is no "bar package". This also respects
the monorepo rule `features ↛ features`: `pos` depends on `products` once, never
on three vertical variants.

---

## 6. Onboarding flow (where a vertical is chosen)

1. On first run, the operator picks a business type (Festival / Bar / Pub /
   Restaurant) — a single wizard screen.
2. The app loads `BusinessProfile.presets[type]`, persists it, and seeds the
   matching **catalog template** (drinks list for a bar, food menu for a
   restaurant — swappable seed data, not hardcoded in `products`).
3. From then on the UI reflects only the enabled capabilities. The choice can be
   changed later in settings (it re-runs the preset; it does not re-fork the app).

The operator sees a lean, venue-shaped app. Capabilities they didn't enable — and
paid features they didn't buy — are never rendered.

---

## 7. Extensibility rules of thumb

| Situation | Right move |
|---|---|
| New venue kind (food truck, bakery) | Add one `BusinessType` + one `BusinessProfile.presets` entry. Nothing else. |
| New behaviour some venues need (tabs, coursing) | New `Capability` + a `features/<capability>` package, gated by the profile. |
| Only default values/catalog differ | Catalog template (data). No code, no branch. |
| New paid/cloud/AI feature | New `Feature(minimumTier)` entry — tier axis, unchanged. |
| New device/role workflow (KDS, waiter) | New `apps/*` — Axis A — and only when a customer needs it. |

---

## 8. Why this is the right strategy for a solo dev

- **One codebase** → fix a bug once. Scarce time goes to the product, not to N forks.
- **Config-driven verticals** → adding "pub" or "food truck" is a data change, not
  an engineering project.
- **Clean UX per vertical** → capability gating keeps each venue's screen lean;
  no bloat, no dead buttons.
- **Composes with the existing tier gate** → "what you paid for" (tier) and "what
  your business needs" (profile) stack cleanly without special-casing.

This mirrors how the incumbents (Toast, Square, Lightspeed, SumUp) actually work:
one platform, verticals expressed as module presets — never a separate binary per
industry. We copy the boring, proven structure so the scarce effort goes into the
real wedge (offline-first reliability, flat/no-per-transaction pricing, anti-bloat
simplicity) rather than into maintaining parallel apps.

---

## Related docs

- `ECOSYSTEM.md` — product lines, app list, tier/feature matrix (Axis A).
- `AI_INTEGRATION.md` — AI features and their subscription gating.
- `ARCHITECTURE.md` / `DEPENDENCY_RULES.md` — monorepo layers and `features ↛ features`.
