# Agora — Product Brief for Marketing Site

> Context doc for the agent building the marketing site. Not copy — a factual brief.
> Site itself: **Italian only**, built in **Astro**. Translate/localize everything below;
> don't ship this doc's English phrasing as final copy.

---

## 1. One-line pitch

Agora is an offline-first point-of-sale app for **Italian sagre, village
festivals, and small pop-up events** — built for *pro-loco* volunteers and
event organisers, not for restaurants or ticketed commercial venues.

## 2. The segment, precisely

- **Who it's for:** volunteer *pro-loco* associations and organisers running
  a sagra/festival food stand, typically operating under the *legge
  398/1991* non-commercial, cost-covering exemption.
- **Who it's explicitly not for:** full-service restaurants, bars/cafés, and
  large ticketed commercial events (those need different hardware — RFID
  cashless — and different fiscal obligations; out of scope for this
  product).
- **Why this is a real opening:** the incumbent tools in this exact segment
  (MisterPOS, GestiFEST, Ge.Sa., Sagra Touch, Festa di Paese, Esagra) are
  established, functional, and old Windows desktop software. The gap is UX
  and modernity, not missing features — Agora doesn't need to out-feature
  them, it needs to be the tablet-native, offline, dead-simple alternative.

## 3. What actually exists today vs. what's roadmap

**Be careful not to overclaim.** This matters for FAQ/pricing honesty.

**Shipped (real, in the repo today):**
- `apps/agora` — single Flutter app, offline-first, backed by a local Drift/SQLite
  database. No backend exists yet. Fully functional standalone.
- Features implemented: POS/cart, product catalog, orders, discounts, inventory
  tracking, workforce (staff + PIN login + clock-in/out), reports (sales, top
  products, end-of-day summary), settings, onboarding wizard, receipt printing
  (Bluetooth/USB thermal printers), auth.

**Roadmap / designed but not built (do not present as available now):**
- **Local LAN sync hub** (not a cloud backend) — lets multiple stands at the
  same event share a live order queue, stock count, and kitchen tickets, with
  no internet connection. This is the top-priority differentiator versus the
  desktop incumbents. See `docs/architecture/BACKEND.md`.
- Kitchen/stand order ticket routing — depends on the sync hub above.
- Combo/modifier pricing presets for the classic sagra combo (panino +
  patatine + bibita).
- Per-shift cash reconciliation for volunteer handovers.
- Season-to-season catalog/pricing reuse (one-tap restore of last year's
  setup).
- Card payment via **one** Bluetooth reader provider (SumUp or Satispay) —
  not built. Cash is, and will remain, the default.
- Italian software fiscal receipt (RT/PEM-PEL, "scontrino elettronico") —
  **parked, not on the roadmap.** Most volunteer sagre are legally exempt
  under legge 398/1991; do not present fiscal-receipt compliance as a
  feature, planned or otherwise, unless told this has changed.
- Flat one-time or seasonal pricing — not built; no live billing exists yet.

**Marketing site implication:** hero/product sections can describe the vision and
current capabilities honestly. Pricing section should either present "coming soon"
plans or a simple early-access/waitlist framing rather than live checkout, unless
told otherwise. Don't invent screenshots of features that don't exist (multi-station
sync view, kitchen ticket display, card reader flow).

## 4. Core features (today, real)

Group marketing feature copy around these — all shipped in the current single app:

- **Offline-first POS** — cart, catalog, categories, modifiers. Works with zero
  internet connection. Local SQLite database, nothing required from the cloud to
  operate day to day.
- **Receipt printing** — Bluetooth and USB thermal printer support (ESC/POS).
- **Orders** — order building, order management.
- **Discounts & promos** — discount and promo code application.
- **Inventory** — stock tracking.
- **Workforce** — multiple volunteer/staff accounts, PIN-based login,
  clock-in/clock-out time tracking.
- **Reports** — sales overview, top products, end-of-day summary, status
  breakdowns — all computed locally.
- **Onboarding wizard** — quick first-run setup; app configures itself (tax
  rate defaults, currency) automatically.
- **Settings** — event/stand configuration.

## 5. Positioning & differentiation (for hero/product copy)

Core narrative, drawn from the project's own strategy docs — use as the marketing
angle, not verbatim:

- **Offline-first is the whole point, not a fallback.** Sagre run in
  fairgrounds, courtyards, and village squares with unreliable or no
  connectivity. Agora is built to work with zero internet from the start —
  it never assumes a connection like SumUp/Toast/Square-style apps do.
- **Multi-stand sync without the cloud (roadmap).** A sagra typically runs
  3–5 simultaneous registers. The planned local LAN sync hub (organiser's
  laptop or a small Pi on the event's own WiFi) shares a live order queue,
  stock count, and kitchen tickets across stands — no internet connection
  required, no hosted service to depend on.
- **One dead-simple app, not a bloated suite.** Built for non-technical
  seasonal volunteers who get five minutes of training. Outdoor-readable,
  no clutter, no features that don't apply to a festival stand.
- **Priced how a treasurer actually buys software.** Planned flat
  one-time-or-seasonal price, not a percentage of revenue and not a
  per-transaction cut — matches how a *pro-loco* budgets, unlike
  payment-company-owned POS apps.
- **Modern where the incumbents are dated.** The competing products in this
  exact niche are old Windows desktop tools. Agora's edge is being
  tablet-native and easy, not a longer feature list.
- **Built by a lean/solo team.** No need to overstate company size; the product story
  is "simple, focused software for a real, specific need" rather than an enterprise platform.

## 6. Target audience

- *Pro-loco* volunteer associations and independent organisers running a
  sagra or village festival food/drink stand — no IT support, seasonal
  volunteer staff, needing something that works instantly with zero setup
  and zero connectivity. Non-technical.
- Small pop-up event operators (fairs, markets, one-off community events)
  with similar needs: temporary setup, no dedicated staff, cash-first.
- Market: Italy, specifically the *sagra*/village-festival circuit.

## 7. Required marketing site sections (per user request) — mapped to content source

1. **Hero** — the one-line pitch (§1) + offline-first / built-for-sagre angle
   (§5). No specific screenshots needed yet — focus on message.
2. **Product / Use case section** — one section describing the sagra/festival
   stand use case (§2, §4, §5). This is a single-product site — no per-vertical
   sub-sections.
3. **Blog section** — placeholder/empty-state scaffold is fine; no existing posts.
   Likely future topics (don't write these as if published): running a
   sagra without internet, multi-stand coordination at a village festival,
   what legge 398/1991 means for your sagra's software choices, etc.
4. **Pricing section** — no live prices exist yet. Present as indicative /
   "contact us" / waitlist rather than a checkout, framed around the intended
   flat one-time-or-seasonal price (not a subscription-tier grid), unless
   told otherwise.
5. **Contact section** — standard contact form; no CRM/backend integration exists,
   so this likely needs to point at an email or a simple form service (e.g.
   mailto or a form provider) rather than a custom backend.
6. **Help / FAQ section** — anticipate questions like: "Does it work without
   internet?" (yes, that's the core design), "Can multiple stands share the same
   order/stock list?" (roadmap — local LAN sync hub, not cloud), "Is it compliant
   with Italian fiscal law?" (most sagre are exempt under legge 398/1991; fiscal
   receipt integration is not on the roadmap), "Does it support card payments?"
   (roadmap, one provider), "What devices does it run on?" (Flutter app —
   Android/iOS/tablet presumably; confirm before claiming a platform list you're
   not sure of).
7. **Documentation / user manual section** — no end-user docs exist in the repo
   yet (`docs/` is all internal engineering architecture docs). This section
   will need net-new content written for end users (how to onboard, how to set
   up a stand, how to use POS/inventory/reports/workforce) — treat as a
   content-authoring task, not something to source from `docs/architecture/*`
   (those are written for engineers, not organisers).

## 8. Tone notes

- Plain language, non-technical audience (event organisers/volunteers, not developers).
- Avoid overselling unbuilt features as current. Where the roadmap is genuinely
  compelling (multi-stand LAN sync, card payment), it's fine to tease as "coming"
  rather than omit entirely — just don't imply it ships today.
- Do not mention fiscal receipt/RT compliance as a feature or future feature —
  it's explicitly off the roadmap for this segment.
- Site language: Italian only, per instruction. This brief is in English only to
  brief the build agent efficiently — translate all resulting copy to Italian.
