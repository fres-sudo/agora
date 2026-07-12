# Agora — Product Brief for Marketing Site

> Context doc for the agent building the marketing site. Not copy — a factual brief.
> Site itself: **Italian only**, built in **Astro**. Translate/localize everything below;
> don't ship this doc's English phrasing as final copy.

---

## 1. One-line pitch

Agora is an offline-first point-of-sale and venue-management app for hospitality
businesses (restaurants, bars/cafés, quick-service counters, festival/event stalls) —
one app, one codebase, shaped per business type via configuration instead of
separate products.

## 2. What actually exists today vs. what's roadmap

**Be careful not to overclaim.** This matters for FAQ/pricing honesty.

**Shipped (real, in the repo today):**
- `apps/agora` — single Flutter app, offline-first, backed by a local Drift/SQLite
  database. No backend exists yet. Fully functional standalone.
- Business-type switching (see §3) — implemented today via `feature_flags` package.
- Features implemented: POS/cart, product catalog, orders, discounts, inventory
  tracking, workforce (staff + PIN login + clock-in/out), reports (sales, top
  products, end-of-day summary), settings, onboarding wizard, receipt printing
  (Bluetooth/USB thermal printers), auth.

**Roadmap / designed but not built (do not present as available now):**
- Cloud backend (Hono + Bun + PostgreSQL) — not built.
- Multi-app split: `apps/pos`, `apps/kitchen`, `apps/totem`, `apps/client_app`,
  `apps/waiter`, `apps/festival_pos` as separate installable apps — not built. Today
  it's all one app.
- Kitchen display sync, multi-terminal sync, cloud reports — require the backend;
  not built.
- Card payment acceptance (Stripe Terminal / SumUp / Satispay integration) — not
  built.
- Italian software fiscal receipt (RT/PEM-PEL, "scontrino elettronico") — not built.
- AI features (natural-language report summaries, demand forecast, dietary filter,
  upsell nudges, kitchen prioritisation) — not built; fully speculative design doc.
- Subscription tiers (free / paid basic / paid pro) — the *flag scaffolding* exists
  in code, but there is no live billing, no priced plan, no paid feature actually
  gated behind a working paywall yet.

**Marketing site implication:** hero/product sections can describe the vision and
current capabilities honestly. Pricing section should either present "coming soon"
plans or a simple early-access/waitlist framing rather than live checkout, unless
told otherwise. Don't invent screenshots of apps/features that don't exist (kitchen
display, totem, waiter app).

## 3. "Products" = business types (use-case sections)

The user wants each business type treated as a distinct product/use-case section,
even though it's the same app. These are the four real, implemented types
(`packages/feature_flags`, `BusinessType` enum) — use these exact four, not the
older/rougher "festival/bar/pub/restaurant" wording from early design docs:

| Business type | Who | What's on for them |
|---|---|---|
| **Restaurant** (`restaurant`) | Full table-service restaurants | Tables + covers, dine-in + takeaway, staff PIN login, inventory, reports, discounts. The richest profile — default. |
| **Bar / Café** (`barCafe`) | Fast counter service, drinks-oriented | Dine-in + takeaway, staff login, inventory, reports, discounts. No table/cover management. |
| **Quick service** (`quickService`) | Counter + takeaway only (no table service) | Dine-in + takeaway, inventory, reports, discounts. No staff login required (can run single-operator). |
| **Festival / Event** (`festival`) | Event/festival stalls, pop-ups | Takeaway only, inventory, reports. Cash-first (card off by default), 0% default tax rate, fully offline, single operator — built for zero-connectivity, high-throughput selling. |

Positioning line for this section: **"One app. Four ways of working. Pick your
venue type at setup, and the app shows you only what you need."** Each business
type should get its own short use-case pitch (a paragraph + a feature highlight
list), like separate "products," even though there's no separate download/SKU.

## 4. Core features (today, real)

Group marketing feature copy around these — all shipped in the current single app:

- **Offline-first POS** — cart, catalog, categories, modifiers. Works with zero
  internet connection. Local SQLite database, nothing required from the cloud to
  operate day to day.
- **Receipt printing** — Bluetooth and USB thermal printer support (ESC/POS).
- **Orders** — order building, order management.
- **Discounts & promos** — discount and promo code application.
- **Inventory** — stock tracking.
- **Workforce** — multiple staff accounts, PIN-based login, clock-in/clock-out
  time tracking.
- **Reports** — sales overview, top products, end-of-day summary, status
  breakdowns — all computed locally.
- **Onboarding wizard** — pick business type once at first run; app reconfigures
  itself (tax rate defaults, currency, which capabilities show up) automatically.
- **Settings** — venue configuration.

## 5. Positioning & differentiation (for hero/product copy)

Core narrative, drawn from the project's own strategy docs — use as the marketing
angle, not verbatim:

- **Offline-first is the wedge.** Most competitors (SumUp, Toast, Square-style
  apps) assume constant connectivity. Agora is built to work with zero internet —
  proven use case: festivals and events with no reliable connectivity — and stays
  useful for brick-and-mortar venues when Wi-Fi drops.
- **One app, not a bloated suite.** Rather than a separate app per venue type or
  a UI cluttered with toggles for features you don't use, the app reconfigures
  itself around the business type chosen at onboarding. A festival stall operator
  never sees table management; a restaurant owner never sees "quick sale" mode.
- **Payment-agnostic positioning (future).** Planned strategy: no forced payment
  processor lock-in and no per-transaction cut baked into the software price —
  bring your own card acquirer (Stripe/SumUp/Satispay) later. Flat subscription
  model is the intended pricing shape, not a % of revenue. (This is strategy, not
  yet built — phrase future-tense.)
- **Italian market fit (future).** Planned: Italian electronic fiscal receipt
  compliance (software RT) built in-app rather than requiring separate certified
  hardware. Relevant future selling point for Italian venues once shipped — do not
  claim compliance today.
- **Built by a lean/solo team.** No need to overstate company size; the product story
  is "simple, focused software for real venues" rather than an enterprise platform.

## 6. Target audience

- Festival and event operators running temporary stalls, no IT support, needing
  something that works instantly with zero setup and zero connectivity.
  Non-technical.
- Independent restaurant owners/managers — low-to-medium technical literacy,
  want table management, staff accounts, and reporting without an enterprise POS
  price tag or complexity.
  Non-technical.
- Bar/café owners — fast counter service, drinks-forward, want speed over table
  management.
- Quick-service / takeaway counter operators — simplest possible flow, minimal
  or no staff accounts.
- Market: primarily Italy (fiscal compliance angle), hospitality/food-and-beverage
  vertical broadly.

## 7. Required marketing site sections (per user request) — mapped to content source

1. **Hero** — the one-line pitch (§1) + offline-first / one-app-many-venues angle
   (§5). No specific screenshots needed yet — focus on message.
2. **Product / Use case section** — one sub-section per business type from §3
   (Restaurant, Bar/Café, Quick Service, Festival/Event). Treat each like a
   distinct "product" card/page even though it's one app.
3. **Blog section** — placeholder/empty-state scaffold is fine; no existing posts.
   Likely future topics (don't write these as if published): Italian fiscal
   receipt changes (2026 POS↔RT link law), offline-first hospitality tech,
   running a festival stall without internet, etc. — topical to the docs in
   `docs/architecture/PAYMENTS_AND_FISCAL.md`.
4. **Pricing section** — no live prices exist yet. Structure it around the
   tier shape already designed (free / paid basic / paid pro — see
   `packages/feature_flags` `SubscriptionTier`), but present as indicative /
   "contact us" / waitlist rather than a checkout, unless told otherwise.
5. **Contact section** — standard contact form; no CRM/backend integration exists,
   so this likely needs to point at an email or a simple form service (e.g.
   mailto or a form provider) rather than a custom backend.
6. **Help / FAQ section** — anticipate questions like: "Does it work without
   internet?" (yes, that's the core design), "What if I run a bar and not a
   restaurant?" (§3 — pick type at setup), "Is it compliant with Italian fiscal
   law?" (roadmap, not yet — phrase carefully), "Does it support card payments?"
   (roadmap), "What devices does it run on?" (Flutter app — Android/iOS/tablet
   presumably; confirm before claiming a platform list you're not sure of).
7. **Documentation / user manual section** — no end-user docs exist in the repo
   yet (`docs/` is all internal engineering architecture docs). This section
   will need net-new content written for end users (how to onboard, how to pick
   a business type, how to use POS/inventory/reports/workforce) — treat as a
   content-authoring task, not something to source from `docs/architecture/*`
   (those are written for engineers, not merchants).

## 8. Tone notes

- Plain language, non-technical audience (venue owners/operators, not developers).
- Avoid overselling unbuilt features as current. Where the roadmap is genuinely
  compelling (Italian fiscal compliance, AI features, multi-terminal sync), it's
  fine to tease as "coming" rather than omit entirely — just don't imply it ships
  today.
- Site language: Italian only, per instruction. This brief is in English only to
  brief the build agent efficiently — translate all resulting copy to Italian.
