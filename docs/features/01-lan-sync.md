# Feature 1 — Multi-station LAN sync, no cloud

> Priority #1. The single biggest gap versus every desktop incumbent
> (MisterPOS, GestiFEST, Ge.Sa., Sagra Touch, Festa di Paese, Esagra). Sagre
> routinely run 3–5 simultaneous registers that need to share one order
> queue and one stock count with zero internet connection.

## Description

Multiple `apps/agora` installs on the same event's WiFi/LAN share a live
order queue and stock count in real time. One station (organiser's laptop,
a Pi, or the busiest tablet) runs a small local server — the **sync hub**
(`sync_hub/`, spec in `docs/architecture/BACKEND.md`) — that the other
stations connect to over the local network. No internet connection, no
hosting, no account signup involved.

## Why

A sagra stand today runs each register as an island: stock at the drinks
stand can hit zero while the food stand's screen still shows it available,
and there's no way to see what other stands sold without walking over and
asking. This is the #1 differentiator called out in the product scope
(`docs/architecture/ECOSYSTEM.md`) — it's the reason to switch from a
desktop incumbent, not a nice-to-have.

## What's in scope

- Shared order feed across paired stations (new orders, status changes).
- Shared stock count across paired stations (delta-based, so concurrent
  decrements from two stations both apply correctly).
- Pairing a station to a hub by LAN address — no account, no signup.
- Graceful degradation: a station with no hub, or one that drops off WiFi
  mid-event, keeps working standalone against its own local Drift DB and
  reconciles once reconnected. This must never block a sale.

**Out of scope for this feature** (tracked separately):
- Kitchen/stand ticket routing — see `02-kitchen-ticket-routing.md`. It's
  built *on top of* this sync mechanism but is its own feature (adds a
  `kitchen:{stand}` topic and station-targeted tickets).
- Any cloud/hosted variant of the hub. There isn't one, ever, for this
  product — see `docs/architecture/BACKEND.md`.

## Where

Ground truth as of this plan (confirmed by reading the code, not the old
docs):

- **`packages/sync_engine`** already exists, is unit-tested, and is
  **currently wired into zero features** (`grep` for `SyncableRepository`/
  `package:sync_engine` outside the package itself returns no hits; no
  feature's `pubspec.yaml` even depends on it). It ships:
  - `SyncManager` (`lib/src/sync_manager.dart`) — the orchestrator: outbox
    drain loop (30s timer + drain-on-reconnect), `SyncStatus` stream
    (`SyncIdle`/`SyncInProgress`/`SyncPaused`/`SyncFailed`), `enqueue()`.
  - `OutboxQueue`/`OutboxDao` over `OutboxTable`
    (`packages/database/lib/src/tables/outbox_table.dart`) — already a real
    Drift table (`operationType`, `entityType`, `entityLocalId`, `remoteId`,
    JSON `payload`, `status`, `retryCount`).
  - `RetryBackoff` — exponential backoff, 30s→30min cap, fully unit-tested.
  - `ConnectivityMonitor` — thin `connectivity_plus` wrapper.
  - `SyncWebSocket` (`lib/src/websocket/sync_web_socket.dart`) — a **generic**
    JSON-over-WebSocket client (subscribe/unsubscribe/ping, auto-reconnect
    with backoff, auto-resubscribe). It connects to any `ws://`/`wss://` URL
    with a query-param auth token — it has **no LAN-specific logic**
    (no mDNS, no local discovery, no peer server), which is actually fine:
    a LAN WebSocket server is still just a WebSocket server, `ws://<hub-lan-ip>:<port>`
    works with this client unmodified.
  - Consumer contract is exactly two abstract types: `SyncableRepository`
    (wraps local write + `syncManager.enqueue(...)`) and `SyncHandler`
    (`String entityType` + `handle(OutboxEntry)`).
  - **Untested today:** `SyncWebSocket` itself, the real Drift-backed
    `OutboxDao` (only exercised via mocks), `ConnectivityMonitorImpl`,
    `SyncableRepository.safeSync`. Budget test-writing time for these before
    relying on them in production, not just the mocked `SyncManager` tests.
- **`sync_hub/`** does not exist yet. Full stack spec is in
  `docs/architecture/BACKEND.md` (Bun + Hono + local SQLite + Drizzle, no
  tenancy, no auth provider — a pairing-token model only). Build it as a
  separate Bun project, not a Dart package.
- **New pairing/config surface**, likely in `features/settings` (a "Sync"
  section next to `printer_section.dart`) plus a small new state holder —
  does not need a new `features/` package on its own.
- Repositories to make syncable: `features/orders` (`OrdersRepositoryImpl`
  — currently `extends Repository`, needs to become/compose
  `SyncableRepository`) and inventory (`features/inventory` /
  `packages/inventory_contracts`) for stock deltas.

## How

### Step 1 — Build `sync_hub/` (standalone Bun project, not in this Melos workspace's Dart graph)

Follow `docs/architecture/BACKEND.md` build order exactly:
1. `db/schema.ts` — orders (append-only), order items, stock deltas, kitchen
   tickets (add this table now even though ticket routing is feature 2 —
   cheaper to design the schema once).
2. `catalog/` module — read-only mirror, seeded from whichever station
   starts the hub (first station to pair pushes its current catalog).
3. `ordering/` module — accept new orders, broadcast.
4. `realtime/` module — the WebSocket hub itself: topics `orders`, `stock`,
   later `kitchen:{stand}`.
5. `inventory/` module — stock delta application (never absolute writes —
   two stations decrementing the same product concurrently must both land).
6. A pairing endpoint: station POSTs its device name → hub returns a
   short-lived session token scoped to this hub run. No persistent account.

### Step 2 — Wire `packages/sync_engine` into `OrdersRepositoryImpl`

- `features/orders/lib/data/repositories/orders_repository_impl.dart`
  currently `extends Repository implements OrdersRepository` (plain, no
  sync). Change to compose a `SyncManager` (injected) and call
  `safeSync(...)` instead of `safe(...)` on `createOrder`/`updateStatus`
  writes, per `SyncableRepository`'s existing pattern.
- Add `OrderSyncHandler implements SyncHandler` with `entityType = 'order'`,
  whose `handle(OutboxEntry entry)` POSTs the payload to the hub's
  `ordering/` endpoint (or pushes over the already-open `SyncWebSocket`,
  whichever the hub spec settles on — the outbox doesn't care, it just needs
  *a* handler that completes or throws).
- Register the handler: `syncManager.registerHandler(OrderSyncHandler(...))`
  in `apps/agora/lib/app/app_providers.dart`, after `OrdersFeature.providers`
  per the existing dependency-ordering convention in that file.

### Step 3 — Stock deltas

- `features/inventory`'s repository needs the same `SyncableRepository`
  treatment for `adjustStock`/`decrementForOrder` — but as **deltas**, not
  absolute `setStock` writes, so the outbox payload must carry a signed
  quantity change, not a target quantity. Check `InventoryRepository`
  (`packages/inventory_contracts`) — `setStock` vs `adjustStock` already
  exist as separate methods; only `adjustStock`'s delta form should ever go
  through sync. Don't sync `setStock` (an absolute correction) without
  additional conflict handling — flag this as a design decision, not
  auto-solved by the outbox pattern.

### Step 4 — Pairing UI

- New `SyncPairingService` (per the earlier task doc's `P9-1`, now framed as
  "standalone vs. paired," not "free vs. paid" — there's no tier gate here).
  Default: standalone, hub absent. Local default persisted via
  `SettingsRepository` (same key/value pattern as
  `AppSettingsDao.keyPaymentMethodCashEnabled` etc.).
- Settings UI: enter/scan the hub's LAN address (`192.168.x.x:port`), tap
  Connect. On success, `SyncManager.start(webSocketUrl: ..., authToken: ...)`.
  On failure, clear error, app keeps working standalone — this must never
  read as a hard failure to the volunteer at the register.

### Step 5 — Conflict model (design once, don't improvise per-entity)

- Orders: **append-only**. No station ever edits another station's order
  row — voids/refunds are new events, not mutations of history. This avoids
  the entire cross-station edit-conflict class.
- Stock: **delta-only** sync (Step 3). Absolute stock corrections
  (`setStock`) stay local-only or require an explicit "force" path that's
  out of scope for v1.
- Kitchen tickets: append-only status transitions (pending→in_progress→
  ready→bumped), same reasoning as orders. Covered in feature 2.

## Acceptance criteria

- A single station with no hub configured works identically to today — zero
  regression, zero required setup.
- Two paired stations: an order placed on station A appears in station B's
  order list within a few seconds; a stock decrement on A is reflected in
  B's product screen.
- Killing WiFi on station B mid-shift: B keeps taking orders locally; on
  WiFi restore, B's queued orders drain to the hub and appear on A.
- Killing the hub process entirely: every station keeps working standalone;
  no crash, no blocked checkout.

## Open questions (not yet decided — flag before building)

- Exact wire protocol between `SyncWebSocket` and the hub's `realtime/`
  module — `BACKEND.md` proposes topics (`orders`, `stock`,
  `kitchen:{stand}`) but the actual JSON message shape needs to be nailed
  down against `SyncMessage` (`packages/sync_engine/lib/src/websocket/sync_message.dart`)
  before both sides can be built in parallel.
- Whether the hub needs LAN service discovery (mDNS/Bonjour) so a volunteer
  doesn't have to type an IP address, or whether "type the address once at
  setup" is acceptable for v1. Recommend deferring discovery — ship the
  manual-address path first.
