# Agora — AI Integration Strategy

## Guiding principle

The goal is **ambient intelligence**: AI that works silently in the background and surfaces the right information to the right person at the right moment. It is never a chatbot or a new screen to learn. For non-technical users — festival operators, kitchen staff, waiters, restaurant owners — the experience must feel like the app "knows" the business, not like a new tool they have to operate.

Every AI feature in this document satisfies the following test:

> *Could a non-technical user benefit from this without knowing AI is involved?*

If the answer is no, the feature should not be built.

---

## Who the users are

This is the most important constraint on every design decision.

| Role | Technical literacy | Context during use | What they care about |
|---|---|---|---|
| Festival operator | Low | Busy event, no IT support | Revenue, stock, zero downtime |
| Restaurant owner | Low–medium | Off-site or in-office, intermittent | Profit, staff performance, trends |
| Manager | Medium | On-site, multitasking | Service quality, kitchen speed |
| Waiter | Low | Moving constantly, hands occupied | Table status, what to say to guests |
| Kitchen staff | Very low | Noise, heat, speed | What to cook next, nothing else |
| Customer (totem) | Mixed | Rushed, unfamiliar with the venue | Quick, accurate, easy order |
| Customer (mobile) | Mixed | Relaxed, on their own device | Discovery, convenience |

AI must reduce decisions and reading, not add them.

---

## Architecture overview

AI capability is split between two layers:

```
Flutter apps  ←→  packages/ai_engine  ←→  Agora backend (modules/ai)  ←→  Claude API
                                       ↑
                               backend aggregates tenant data
                               before sending to Claude
```

- **`packages/ai_engine`** — thin Dart package. Wraps backend AI endpoints. No direct calls to Claude from Flutter; all inference goes through the backend so API keys never touch client devices and prompts can be audited per tenant.
- **`backend/src/modules/ai/`** — new backend module. Aggregates tenant data from the database, builds prompts, calls Claude, caches responses, returns structured results.
- **Local Drift data** is never sent to Claude raw. The backend only sends aggregated, anonymised summaries. A customer's order is never transmitted; total quantities per product over a time window are.

### Why inference through the backend

1. Claude API key never shipped in Flutter code.
2. Prompt construction requires joining multiple tables — easier server-side.
3. Responses can be cached per tenant (same question from two devices returns the cached answer).
4. Usage can be metered per subscription tier.
5. Prompts and responses can be logged for quality review.

---

## `packages/ai_engine` — Flutter package

This package is a lightweight HTTP client for the backend AI endpoints. It has no business logic. Features import it to display AI-generated content.

### Package structure

```
packages/ai_engine/
├── pubspec.yaml               (name: ai_engine)
└── lib/
    ├── ai_engine.dart         ← barrel export
    ├── src/
    │   ├── ai_client.dart     ← Retrofit/Dio client for /api/ai/* endpoints
    │   ├── models/
    │   │   ├── report_summary.dart      ← @freezed
    │   │   ├── demand_forecast.dart     ← @freezed
    │   │   ├── upsell_suggestion.dart   ← @freezed
    │   │   ├── queue_priority.dart      ← @freezed
    │   │   └── menu_filter_result.dart  ← @freezed
    │   └── ai_engine_provider.dart     ← SingleChildWidget provider
```

### Dependency

`ai_engine` depends only on `package:result`, `package:errors`, and `package:logger`. It has no dependency on any feature package. Features depend on `ai_engine`, never the reverse.

```
features/reports  →  ai_engine  →  (backend)
features/kitchen  →  ai_engine
features/orders   →  ai_engine
```

### Registration

```dart
// apps/pos/lib/app/app_providers.dart
RepositoryProvider<AiClient>(
  create: (_) => AiClient(dio: context.read()),
),
```

---

## `backend/src/modules/ai/` — Backend module

The AI module is a standard Hono module following the same layout as all other backend modules.

```
backend/src/modules/ai/
├── router.ts        ← Hono routes
├── service.ts       ← prompt construction, Claude calls, caching
├── aggregator.ts    ← queries other modules' repositories to build context
├── schema.ts        ← Zod schemas for all requests and responses
├── prompts/
│   ├── report_summary.ts
│   ├── demand_forecast.ts
│   ├── upsell.ts
│   ├── queue_priority.ts
│   └── dietary_filter.ts
└── index.ts
```

### Caching strategy

All AI responses are cached in PostgreSQL with a `(tenant_id, feature, cache_key, expires_at)` index:

| Feature | Cache key | TTL |
|---|---|---|
| Report summary | `report:{locationId}:{date}` | Until midnight |
| Demand forecast | `forecast:{locationId}:{target_date}` | 6 hours |
| Upsell suggestion | `upsell:{locationId}:{product_ids_hash}` | 1 hour |
| Queue priority | `queue:{locationId}` | Not cached (real-time) |
| Dietary filter | `diet:{locationId}:{query_hash}` | 24 hours |

If a cached response exists and is not expired, it is returned without calling Claude.

### Tenant isolation

The `ai/` module receives the tenant context from the `tenant.ts` middleware, identical to every other module. Data aggregated for prompt construction is always scoped by `tenant_id` and `location_id`. One tenant's data never appears in another tenant's prompt.

### Rate limiting and metering

| Subscription tier | AI calls per day | Features available |
|---|---|---|
| Free (festival) | 0 | None |
| Paid basic | 20 | Report summary only |
| Paid pro | 200 | All features |
| Restaurant SaaS | Unlimited (fair use) | All features |

Calls are counted in a `ai_usage` table. The router checks quota before calling Claude.

---

## Feature 1 — Natural language report summary

### What it does

After a service or event, the owner or manager can tap a single button to receive a plain-language paragraph summarising the day's performance. No dashboard to read, no numbers to interpret.

**Example output:**
> "Saturday was your best evening this month. Revenue was €2,840, up 18% on last Saturday. The burger and the house fries drove 40% of sales. The bar was the bottleneck — drinks orders averaged 14 minutes, twice your usual. You ran out of the salmon special at 8:45 pm."

### What feeds it

The `aggregator.ts` pulls from:

- `orders` table: count, revenue, average ticket, time distribution
- `order_items` table: per-product volumes and revenue share
- `kitchen` table: per-station average time, slowest items
- `inventory` table: items that hit zero stock during the service

No individual customer data is included. Only aggregated totals.

### Backend endpoint

```
POST /api/ai/report-summary
Body: { locationId, date }
Response: { summary: string, generatedAt: string }
```

### Flutter integration

Lives in `features/reports`. A `ReportSummaryWidget` calls the endpoint on demand (user taps "Get AI summary"). The result is a plain `Text` widget — no special UI needed.

```dart
// features/reports/lib/presentation/widgets/report_summary_widget.dart
BlocBuilder<ReportSummaryCubit, ReportSummaryState>(
  builder: (context, state) => switch (state) {
    ReportSummaryLoading() => const SkeletonText(lines: 4),
    ReportSummaryLoaded(:final summary) => Text(summary),
    ReportSummaryError() => const Text('Summary unavailable'),
  },
)
```

### Festival POS note

Available in the paid tier only. The festival app calls the same endpoint; the backend checks subscription before responding.

---

## Feature 2 — Demand forecast and prep guidance

### What it does

Before opening, the manager sees a forecast: expected covers and a prep list. Framed as actionable quantities, not percentages.

**Example output:**
> "Tonight: expect around 95 covers, about 20% more than a typical Thursday. Consider prepping 10 extra portions of the risotto and the chocolate cake — both sold out last Thursday. The terrace will likely fill first."

### What feeds it

- Historical `orders` aggregated by day of week and time of day
- Historical stock-outs from `inventory` events
- Configuration: seating capacity, table layout
- (Future) external calendar events via optional tenant configuration (e.g. local football match schedule)

The first few weeks of use will produce lower-confidence forecasts. The prompt instructs Claude to reflect this honestly:
> "Based on 4 weeks of data, my confidence is moderate. With 8+ weeks the forecast will be more reliable."

### Backend endpoint

```
POST /api/ai/demand-forecast
Body: { locationId, targetDate }
Response: { narrative: string, expectedCovers: number, prepItems: PrepItem[], confidence: 'low' | 'medium' | 'high' }
```

### Flutter integration

Lives in `features/reports`. Shown on the manager's home screen the morning before service — a card with the narrative and a collapsible prep list. No interaction required; it loads on mount.

---

## Feature 3 — Kitchen queue smart prioritisation

### What it does

The kitchen display automatically reorders the ticket queue to minimise table wait times. The kitchen staff see a queue; they do not see or interact with any AI. The AI is invisible.

### How it works

This feature is the only one that does **not** call Claude in real-time. It uses a lightweight scoring model that runs server-side on every new order event:

```
priority_score = table_wait_time_minutes
               + (target_prep_time - elapsed_prep_time)
               - station_current_load_factor
```

`target_prep_time` per dish is learned from historical `kitchen` data: the median time between "received" and "bumped" for each `product_id` at each `station`. This improves over weeks of use.

Claude is used offline (nightly batch job) to:
1. Detect anomalous prep times and flag them for the manager.
2. Suggest station reassignments when one station is consistently overloaded.

### Backend endpoint (real-time scoring)

```
WS topic: kitchen:{locationId}:{station}
Payload now includes: { tickets: [...], suggestedOrder: string[] }
```

`suggestedOrder` is an array of `ticketId` values in priority order. The kitchen display renders them in this order. No additional UI change.

### Learning pipeline

```
Nightly cron (backend):
  1. SELECT all kitchen events for yesterday
  2. Compute median prep time per (product_id, station_id)
  3. UPSERT into kitchen_prep_baselines table
  4. If any item is >2× baseline: POST to ai/anomaly-report
```

The `anomaly-report` endpoint calls Claude to summarise the anomalies in one paragraph and stores it for the next manager report.

---

## Feature 4 — Waiter upsell nudge

### What it does

After the kitchen marks a table's main courses as ready, the waiter app shows a one-line contextual suggestion for that table. The waiter can dismiss it with one tap.

**Example nudge:**
> "Table 4 — tiramisu pairs well with their Barolo. Two of three guests haven't ordered dessert."

**Another example:**
> "Table 9 — they're on their third round. Tonight's cocktail special (Aperol Spritz) tends to land well at this stage."

This is shown as a small banner, not a blocking dialog. It appears once and disappears after 30 seconds if ignored.

### What feeds it

- What the table ordered (products, categories)
- Time elapsed since order
- Current bestsellers and specials from `catalog`
- Historical co-purchase patterns: "customers who ordered X also ordered Y at the same session" — computed from `order_items` data, no individual tracking

### Backend endpoint

```
POST /api/ai/upsell-suggestion
Body: { locationId, tableId, currentOrderItems: string[] }
Response: { suggestion: string | null }
```

`null` means no suggestion is appropriate — do not show anything.

### Flutter integration

Lives in `features/orders`, shown on the active order screen in the waiter app. A `UpsellNudgeBanner` widget sits at the bottom of the screen. It auto-dismisses and is logged (shown/dismissed/acted on) for quality improvement.

---

## Feature 5 — Waiting time alert

### What it does

When a table has been waiting significantly longer than usual for their order, the waiter app shows a silent alert so the waiter can proactively address it before the customer complains.

**Example alert:**
> "Table 12 — 38 min wait, usually 22 min for this order. Worth checking in."

This is not AI-generated text — it is a rule-based threshold using the learned prep baselines from Feature 3. Claude is not involved.

### Logic

```
if elapsed_time > (baseline_prep_time_for_order * 1.5):
  push alert to waiter's active device via WS
```

### Flutter integration

A persistent overlay in the waiter app, similar to a toast. Tapping it navigates to the table. It clears automatically when the order is bumped.

---

## Feature 6 — Dietary and allergy filter (totem and client app)

### What it does

The customer types or speaks a natural language description of their needs. The menu filters instantly.

**Example input:** "I'm vegan and I have a nut allergy"
**Result:** Menu shows only items tagged as vegan with no nut allergens. Incompatible items are greyed out, not hidden, so the customer doesn't feel lost.

**Example input:** "gluten free options"
**Result:** Filters to gluten-free items.

This replaces the current pattern of a multi-tap filter UI that non-technical customers find confusing.

### How it works

Claude maps the free-text input to a set of structured filter criteria (`vegan: true`, `allergens: { excludes: ['nuts'] }`). This mapping is stateless — it is the same for every customer. The result is cached by query hash (Feature 5 in the caching table above).

After the mapping step, filtering is done locally in the Flutter app against the already-loaded catalog. No per-customer data is sent anywhere.

### Backend endpoint

```
POST /api/ai/dietary-filter
Body: { query: string, locationId: string }
Response: { filters: DietaryFilters }

// DietaryFilters shape:
{
  vegan?: boolean,
  vegetarian?: boolean,
  glutenFree?: boolean,
  allergenExclusions?: string[],   // e.g. ['nuts', 'dairy', 'gluten']
  keywords?: string[]              // e.g. ['light', 'salad'] for semantic fallback
}
```

### Flutter integration

Lives in `features/products`. A `DietarySearchBar` replaces the existing filter chip row on the totem and client app catalog screens. The user types freely; after a 600 ms debounce, the query is sent to the backend. The returned `DietaryFilters` object is applied to the local product list via a `ProductsBloc` event.

```
DietarySearchBar
  → DietaryFilterRequested event (after debounce)
  → ProductsBloc calls AiClient.getDietaryFilters(query)
  → DietaryFiltersReceived event updates the active filter set
  → product list re-renders
```

The existing filter chip row remains as a manual fallback.

---

## Feature 7 — End-of-event summary (festival POS)

### What it does

At the end of a festival event, the operator taps "Wrap up this event" and receives a one-screen summary with a plain-language paragraph and three key numbers. No export, no spreadsheet, no learning required.

**Example output:**
> "Good event. You processed 412 orders and took €8,340 in revenue over 6 hours. The craft beer and the pulled pork bun drove half your sales. You ran out of the veggie wrap at hour 4 — consider stocking 30% more next time. Peak hour was 7–8 pm."
>
> Total revenue: **€8,340**
> Orders: **412**
> Average ticket: **€20.24**

### What feeds it

Same aggregator as Feature 1, scoped to a festival session (start/end timestamps) rather than a calendar date.

### Flutter integration

`apps/festival_pos` specific. A dedicated `EventWrapUpPage` that is locked behind the paid tier check. The free tier shows the raw numbers only (no narrative).

---

## Data flows and privacy

```
User action (e.g. order placed)
  → stored in local Drift DB
  → (paid/cloud) synced to Agora backend PostgreSQL
  → aggregated server-side (totals, medians, counts — no PII)
  → prompt constructed with aggregated data only
  → sent to Claude API
  → structured response returned
  → cached per tenant
  → served to Flutter app
```

**What is never sent to Claude:**
- Individual customer names or contact details
- Payment card data
- Individual order IDs
- Staff names

**What is sent to Claude:**
- Aggregated counts and revenue figures
- Product names and categories
- Time-bucketed demand distributions
- Text entered by the customer into the dietary filter bar (this is by design — it is the user's explicit input for this purpose)

---

## Rollout phases

### Phase A — Report summary (build first)

**Why first:** Highest impact for owners, zero new UX for staff, no real-time requirements. A single backend endpoint and a one-paragraph text widget. Proves the value of AI in the product without building infrastructure.

**Scope:**
- `backend/src/modules/ai/` skeleton + `report_summary.ts` prompt
- `packages/ai_engine` package with `AiClient`
- `features/reports` gains `ReportSummaryCubit` and `ReportSummaryWidget`
- Festival paid tier gets `EventWrapUpPage`

### Phase B — Dietary filter (totem + client app)

**Why second:** Visible to customers, differentiates from every competing totem on the market. Self-contained — no kitchen or order data needed. Cache hit rate is very high (same restaurant, same queries repeat daily).

**Scope:**
- `backend/src/modules/ai/` adds `dietary_filter.ts` prompt
- `features/products` gains `DietarySearchBar` and `DietaryFilterRequested` event

### Phase C — Kitchen queue learning + waiter alerts

**Why third:** Requires 2–4 weeks of operational data before it becomes useful. Start the data collection (logging actual prep times) from day one even before the feature is surfaced to users.

**Scope:**
- `backend`: nightly `kitchen_prep_baselines` computation job
- `backend/src/modules/realtime/`: add `suggestedOrder` to kitchen WS payload
- `features/kitchen`: renders tickets in `suggestedOrder`
- `features/orders`: `UpsellNudgeBanner` and waiting time alert overlay

### Phase D — Demand forecast

**Why last:** Requires the most historical data to be useful. A forecast based on two weeks of data is not reliable enough to show to operators — it will erode trust. Wait until tenants have 6–8 weeks of history before enabling this feature for them.

**Scope:**
- `backend/src/modules/ai/` adds `demand_forecast.ts` prompt
- `features/reports` gains a forecast card on the manager home screen

---

## Adding a new AI feature — checklist

1. Add a `prompts/<feature>.ts` file in `backend/src/modules/ai/prompts/`.
2. Add an aggregation query in `aggregator.ts` scoped by `tenant_id`.
3. Add a Zod schema for the response in `schema.ts`.
4. Add the route in `router.ts` with quota check middleware.
5. Add a `@freezed` response model to `packages/ai_engine/src/models/`.
6. Add the endpoint to `AiClient` in `packages/ai_engine/src/ai_client.dart`.
7. Create a Cubit in the relevant feature under `presentation/blocs/`.
8. Wire the widget — keep it to a single `Text`, `Banner`, or card. No new screens.

---

## Claude API usage guidelines

All prompts follow these rules to keep outputs consistent and safe for non-technical users:

1. **Always request structured output.** Prompts ask Claude to return a JSON object that matches the Zod schema, wrapped in a plain narrative field. Never ask for free-form Markdown.
2. **Calibrate confidence explicitly.** For forecasts, the prompt instructs Claude to reflect data volume in its language ("based on 3 weeks of data" vs. "based on 6 months").
3. **Keep narratives short.** Prompt constraint: "Reply in no more than 4 sentences. Plain language, no jargon."
4. **No hallucination of specific numbers.** Prompts provide all numbers explicitly; Claude is instructed only to interpret and narrate them, not to invent figures.
5. **Graceful degradation.** If aggregated data is insufficient (e.g. fewer than 3 days of history), the endpoint returns `{ available: false, reason: 'insufficient_data' }` and the Flutter widget shows nothing rather than a low-quality response.

```typescript
// backend/src/modules/ai/service.ts
const MIN_DATA_DAYS: Record<AiFeature, number> = {
  report_summary: 0,       // works from day one
  dietary_filter: 0,       // stateless, works immediately
  upsell: 7,               // needs 1 week of co-purchase data
  queue_priority: 14,      // needs 2 weeks of prep time data
  demand_forecast: 42,     // needs 6 weeks of history
};
```

---

## Subscription gating

| Feature | Free | Paid basic | Paid pro / SaaS |
|---|---|---|---|
| Report / event summary | — | ✓ | ✓ |
| Dietary filter | — | ✓ | ✓ |
| Waiter upsell nudge | — | — | ✓ |
| Waiting time alert | — | — | ✓ |
| Kitchen queue prioritisation | — | — | ✓ |
| Demand forecast | — | — | ✓ |

The backend `quota-check` middleware enforces this. Flutter never decides what is available; it always renders what the backend returns and shows nothing if the endpoint returns `403`.
