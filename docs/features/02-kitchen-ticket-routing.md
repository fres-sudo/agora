# Feature 2 — Kitchen/stand order ticket routing

> Priority #2. Depends on feature 1 (LAN sync) for the cross-station case,
> but the single-station version (a ticket queue on the same device) is
> useful and buildable independently.

## Description

When an order is taken at a cash stand, the items that belong to a
different prep stand (grill, drinks, desserts) show up there as a ticket —
either printed or on a screen — instead of the cashier having to shout
across the tent.

## Why

This is table stakes for any multi-stand sagra with a cash register
separate from the grill/drinks stand, which is the normal setup. Right now
Agora has zero routing concept — an order is just a flat list of line
items with no notion of "where does this get made."

## What's in scope

- A **prep-station** concept on the catalog (assign a category or product to
  a station: grill, drinks, desserts, etc.).
- On order completion, each line item's ticket routes to its station's
  queue.
- A station-facing ticket view: pending → in progress → ready → bumped,
  matching the existing `ClockRecord`-style simplicity (no attempt at a full
  KDS with timers/anomaly detection — that was restaurant-SaaS scope, now
  dropped, see `docs/architecture/AI_INTEGRATION.md`'s deletion).
- Single-station mode: if there's only one station, tickets can just print
  immediately (reuses `packages/printing`, already built) — no LAN
  dependency required to get *some* value from this feature.

**Out of scope:** smart prioritisation/ML queue reordering (that was the
old `AI_INTEGRATION.md` Feature 3 — deleted, off-roadmap), anomaly
detection, per-item prep-time learning.

## Where

Confirmed **100% greenfield** — no scaffolding exists anywhere:

- `ls features/` → no `features/kitchen` package.
- No `station`/`prepStation`/`stand` column anywhere in
  `packages/database/lib/src/tables/` — not on `ProductsTable`,
  `OrdersTable`, or `OrderItemsTable`.
- No `station`/routing field on the domain models either —
  `packages/catalog/lib/models/product.dart` and
  `packages/order_management/lib/models/order_line_item.dart` both lack it.
- Three inert placeholders already exist and should be treated as the
  intended hook points, not built around:
  - `packages/feature_flags/lib/src/models/feature.dart` —
    `Feature.kitchenSync` enum value, currently unread by any code.
  - `packages/feature_flags/lib/src/models/capability.dart` —
    `Capability.kitchenRouting`, same — unread.
  - Both can be wired up as this feature's actual gate once built, or
    deleted if the flag/capability system doesn't apply to a single-vertical
    product anymore (see `project_sagra_scope_pivot` memory — `BusinessType`
    still has restaurant/bar/quickService variants left over from the old
    multi-vertical scope; that's a separate cleanup, not this feature's job).
- The only existing "kitchen" reference in the whole codebase is unrelated:
  a **kitchen receipt printer IP** setting
  (`features/settings/lib/presentation/widgets/printer_section.dart`,
  `app_settings_dao.dart` key `printer_ip_kitchen`) — a second physical
  printer, not order routing. Keep it; this feature is additive to it (a
  ticket for the kitchen station can print to that configured printer).

Given the current package pattern (shared domain → `packages/`,
feature-owned data+presentation → `features/`, established by
`packages/catalog`/`packages/order_management`/`packages/discounts`), a
station/ticket concept consumed by both `feature_products` (assigning a
station to a category) and `feature_orders`/`feature_pos` (routing on
checkout) and a new station display belongs the same way:

- **New shared package `packages/kitchen`** (mirrors `packages/discounts`
  in size/shape): `Ticket`/`TicketStatus`/`TicketItem` models, `TicketsRepository`
  interface, a `TicketsBloc` for shared read access.
- **New `features/kitchen`**: concrete `TicketsRepositoryImpl` + DAO, the
  station ticket-queue page, and `KitchenFeature` registration.

## How

### Step 1 — Schema

- Add `prepStationId` (nullable FK, or a plain string/enum column if
  stations are a fixed small set rather than a manageable table) to
  `ProductsTable` (`packages/database/lib/src/tables/products_table.dart`)
  — simplest v1: a station is just a label string on the product, not a
  separate manageable entity, since a sagra rarely has more than 3-4 prep
  stands and doesn't need a full CRUD screen for them. Reconsider a real
  `StationsTable` only if operators ask for renaming/reordering.
- Add a `TicketsTable`/`TicketItemsTable` (new tables) or, more simply,
  derive tickets from `OrderItemsTable` at read time by grouping on
  `product.prepStationId` and tracking a `ticketStatus` column added
  directly to `OrderItemsTable` — **prefer the derived approach**: it avoids
  a second source of truth for what was ordered, and order items already
  snapshot `productName`/`unitPrice` (`order_items_table.dart:9-23`), so
  adding `ticketStatus` (int, default 0=pending) and `prepStationId`
  (snapshotted at order time, same reasoning as `productName`) to that same
  table is the smallest correct change.
- Bump `schemaVersion` in `packages/database/lib/src/database.dart` (`4` →
  `5`) with an `onUpgrade` migration step — the project has migration
  precedent already (v4's partial-unique-index migration).

### Step 2 — Assign stations to categories/products

- `features/products` product form gains a "Prep station" picker (reuse the
  existing `variants_modifiers_step.dart` pattern — add a sibling step or a
  field on the main details step, whichever is less disruptive to the
  existing `ProductFormCubit` state shape).
- Default: if a product has no station assigned, its ticket goes to a
  default/"front" station (i.e., no behavior change for stands that don't
  use routing).

### Step 3 — Route on order completion

- `CheckoutCubit.confirm()` (`packages/order_management/lib/blocs/checkout/checkout_cubit.dart:103-164`)
  is the exact point orders become `completed` today — this is where ticket
  rows/status get initialized (mirrors how this same method already writes
  `paymentMethod`/marks the order complete in one place).
- Single-station: immediately print a ticket per station represented in the
  order (group `OrderLineItem`s by `prepStationId`, render via
  `packages/printing`'s existing `ReceiptRenderer`-style approach — a ticket
  is a simpler receipt variant).
- Multi-station (depends on feature 1): also push via the sync hub's
  `kitchen:{stand}` topic so a *different* station's screen updates without
  printing anything locally.

### Step 4 — Station ticket-queue page

- New `features/kitchen` page: a simple list of tickets for *this* station
  (filtered by whichever station this device is configured as, a new
  Settings toggle), each showing item/qty/order#, with a tap-to-advance
  status (pending → in progress → ready → bumped) — same interaction model
  as `ClockInCubit`'s simple state machine, nothing more elaborate.
- A station is just a device-local setting ("this tablet is the Grill
  station"), not a login/role — consistent with the product having no
  role hierarchy (see feature 4 — PIN login identifies *who*, not *which
  station*).

## Acceptance criteria

- A product assigned to "Grill" routes its ticket to the Grill station's
  queue (or prints to the configured kitchen printer) when an order
  completes; an unassigned product routes to the default station.
- Single-station setups see zero behavior change unless they explicitly
  configure stations.
- With feature 1 (LAN sync) paired, a ticket fired from the cash stand
  appears on a different physical tablet configured as the Grill station.

## Dependencies

- Full cross-station behavior needs feature 1 (LAN sync) — build the schema
  and single-station path first, they don't block on it.
- Sequencing recommendation: ship Steps 1–3 (schema + station assignment +
  single-station print) before wiring the LAN push, so the feature has
  standalone value even if LAN sync slips.
