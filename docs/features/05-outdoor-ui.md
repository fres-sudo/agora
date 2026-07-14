# Feature 5 — Outdoor-readable, dead-simple UI

> Priority #5. Not a new screen or flow — a cross-cutting adjustment to the
> existing design system so the app stays legible in direct sunlight and
> usable by a volunteer with zero training.

## Description

The app should be readable on a tablet screen in bright outdoor light, and
operable by someone who has never seen it before, with minimal onboarding.
This is a design-system-level change (contrast, type scale, touch targets),
not a feature with new business logic.

## Why

Sagre run in fields, courtyards, and piazzas at midday and evening, on
whatever tablet the *pro-loco* owns, operated by a volunteer who got five
minutes of explanation. A UI tuned for indoor office lighting and
mouse-precision taps fails this use case even if every feature above is
built correctly.

## What's in scope

- A larger, higher-contrast type/spacing mode usable across the whole app —
  not a one-off screen tweak.
- Bigger minimum touch targets on the highest-frequency screens (POS grid,
  checkout, PIN pad).
- An audit and, where needed, adjustment of the existing color tokens for
  outdoor contrast (WCAG-style ratios: ≥4.5:1 for body text, ≥3:1 for large
  text/icons — the current tokens have not been audited against these
  numbers, don't assume they already pass).

**Out of scope:** a full separate "outdoor app" or a runtime auto-detection
of ambient light (no sensor-driven adaptive brightness logic) — v1 is a
selectable mode, not an automatic one.

## Where

The design system is more consolidated than the old docs suggest —
`packages/theme` **no longer exists**; it was absorbed into
**`packages/ui_kit`** (confirmed: `find packages/theme` returns nothing;
tokens live at `packages/ui_kit/lib/src/theme/`). Current state:

- `AppTypography` (`packages/ui_kit/lib/src/theme/app_typography.dart`) —
  a `ThemeExtension`, single fixed Inter-based scale via
  `AppTypography.standard()` factory (body text is 14sp, `bodySm` 13sp,
  `caption` 12sp — on the small side for a sunlit tablet at arm's length).
  No second scale/variant exists today.
- `AppTokens` (`packages/ui_kit/lib/src/theme/app_tokens.dart`) — spacing/
  radii/icon-size `ThemeExtension`, one `light`/`dark` pair (icon sizes fixed
  at 16/20/24dp — `iconMd`/`iconLg` are the ones that matter for tap
  targets). No size-variant axis exists today, only the light/dark
  color-brightness axis.
- `AppColors` (`packages/ui_kit/lib/src/theme/app_colors.dart`) — shadcn-style
  semantic tokens (`background`/`foreground`/`card`/`primary`/`muted`/etc.),
  resolved per-brightness, not per-contrast-mode.
- `ThemeCubit` already exists and is wired
  (`apps/agora/lib/app/app_providers.dart`) — it's the natural place to add
  a second axis (today it almost certainly only toggles light/dark; check
  `packages/ui_kit`'s `ThemeCubit`/`ThemeState` before extending, don't
  assume its exact shape without reading it first when implementation
  starts).
- Both `AppTypography` and `AppTokens` already implement `lerp()` for smooth
  theme transitions — a new variant gets this for free (a mode toggle can
  animate the same way light/dark already does).

This is entirely a `packages/ui_kit` change — no feature package should
need to change to consume it, since screens already read type/spacing via
`context.typography`/`context.tokens`, not hardcoded values (per the
project's own design-system convention — see `project_design_system`
memory). If any screen turns out to hardcode a font size instead of using
`context.typography`, fix that screen as a side-effect of this feature
(it's a bug against the existing convention either way).

## How

### Step 1 — Contrast audit (do this before touching type/spacing)

- Compute the actual contrast ratio of every `AppColors` foreground/
  background pairing used in `light` and `dark` (a script or manual
  check against WCAG formulas is fine — this doesn't need new tooling).
  Flag any pairing under 4.5:1 for body text / 3:1 for large text or icons.
  Adjust the failing values in `AppPalette`
  (`packages/ui_kit/lib/src/theme/app_palette.dart`) — this file wasn't
  read in detail for this plan; open it first, since it's the actual color
  ramp `AppColors` maps from.

### Step 2 — Add an `AppTypography.outdoor()` (or renamed, e.g. `.large()`) factory

- Same structure as `.standard()`, scaled up — e.g. body 14→17sp,
  `bodySm`/`label` 13→15sp, headings scaled proportionally less (they're
  already large). Don't invent a third font family; keep Inter, this is a
  size/weight adjustment only.
- Consider bumping `FontWeight` slightly (e.g. body from w400 to w500) in
  the outdoor variant — weight affects legibility in bright light more than
  people expect, cheap to try.

### Step 3 — Add a matching `AppTokens` variant for touch targets

- The existing `light`/`dark` `AppTokens` pair differ only in shadow color,
  not size — add an outdoor variant (or a size axis orthogonal to
  brightness, matching how `AppColors` and `AppTypography` are both
  brightness-only today) that bumps `iconMd`/`iconLg` and `spaceMd`/`spaceLg`
  enough to grow tap targets on the POS grid and PIN pad without needing
  those screens to change their own layout code (they read tokens, not
  fixed dp values, so this should be transparent).

### Step 4 — Wire the mode into `ThemeCubit` + Settings

- Extend whatever `ThemeCubit`/`ThemeState` currently model (light/dark
  toggle, presumably a `ThemeMode` enum) with an orthogonal "outdoor mode"
  boolean/enum, persisted the same way the existing theme preference is
  persisted (check `ThemeCubit`'s current persistence mechanism before
  adding a second one).
- Settings UI: a single toggle, plain language — "Larger text & buttons"
  or similar, not "outdoor mode" (a volunteer doesn't think in those terms;
  describe the effect, not the intent), likely alongside the existing
  general/store settings section.

### Step 5 — Verify on the highest-frequency screens specifically

Don't just ship the token change and assume it's enough — walk through and
visually confirm on a real device in bright light (or at minimum a bright
outdoor-light simulation) for:
- POS product grid (`features/pos`) — the screen used hundreds of times/hour.
- Checkout sheet (`features/pos/lib/presentation/widgets/checkout/checkout_sheet.dart`).
- PIN login pad (`features/auth/lib/presentation/pages/pin_login_page.dart`).

## Acceptance criteria

- Toggling "Larger text & buttons" in Settings visibly increases text size
  and tap-target size across POS/checkout/PIN screens without layout
  breakage (no text overflow/clipping at the new scale — check the POS
  product grid especially, it's the most content-dense screen).
- All `AppColors` pairings used for body text and icons meet WCAG AA
  contrast ratios in both light and dark, with or without outdoor mode
  enabled (the contrast fix from Step 1 should hold regardless of the size
  toggle — they're separate concerns).
- No feature package needed a direct code change to benefit from the new
  scale (confirms the token-based convention held).

## Open questions

- Should outdoor mode be the **default**, given the target user always
  operates outdoors, rather than an opt-in toggle? Recommend defaulting it
  on for new installs (first-run/onboarding) and letting Settings turn it
  off, rather than defaulting off and hoping volunteers find the toggle.
