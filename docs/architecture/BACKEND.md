# Agora — Local Sync Hub

> Scope: this is **not** a cloud backend. There is no hosting, no multi-tenancy,
> no subscription gating, and no internet dependency anywhere in this design.
> It is a small local server one station runs on the event's own LAN so that
> 3–5 sagra stands can share a live order queue, stock count, and kitchen
> tickets — the #1 gap versus the desktop incumbents (see `ECOSYSTEM.md`).

## Why this exists

A single `apps/agora` install is already a complete, self-contained POS
against its own local Drift/SQLite database — no server required for one
station. The hub only exists to let **multiple stations at the same event**
see the same order queue and stock count in real time, without any internet
connection. Nothing else in the product needs a server.

## Technology stack

| Concern | Choice | Rationale |
|---|---|---|
| Runtime | **Bun** | Fast startup on modest hardware (a Pi or an old laptop), built-in SQLite, native WebSocket |
| Framework | **Hono** | Lightweight, first-class WebSocket support |
| Database | **SQLite** (Bun's built-in driver) | One event, one machine, no need for a managed database server |
| ORM | **Drizzle** | Same schema-definition style as a future cloud target, if ever needed |
| Real-time | **Hono WebSockets** | Native in Bun, sufficient for a handful of stations |

There is no PostgreSQL, no multi-tenant row-level security, and no auth
provider — the hub only needs to exist for the duration of one event, on one
local network, run by one organiser.

---

## Where it runs

The hub runs on **whichever machine the organiser designates** — typically a
laptop, or a Raspberry Pi brought specifically for this purpose — connected to
the same WiFi/LAN as the tablets running `apps/agora`. It is started once at
the beginning of the event and stopped at the end. There is no deployment, no
domain, no TLS certificate to manage — stations connect to it by local IP
address (or a broadcast/mDNS name) over plain LAN WebSocket.

```bash
bun run start   # runs on the organiser's laptop/Pi on the local WiFi
```

A single-station event needs no hub at all: the app works identically with
zero stations synced, one, or five. Pairing a station with the hub is a
one-time "connect to this event" action in the app (enter/scan the hub's LAN
address), not an account signup.

---

## Repository layout

```
sync_hub/
├── src/
│   ├── index.ts               ← Hono app entry point
│   ├── modules/
│   │   ├── catalog/           ← products, categories, modifiers (mirrors what stations sync)
│   │   ├── ordering/          ← orders, order items, order lifecycle
│   │   ├── inventory/         ← shared stock count across stations
│   │   ├── kitchen/           ← ticket queue, per-stand routing, item status
│   │   └── realtime/          ← WebSocket hub, topic broadcasting
│   ├── db/
│   │   ├── schema.ts          ← Drizzle schema
│   │   └── migrations/
│   └── lib/
│       ├── errors.ts
│       └── result.ts
├── package.json
├── bun.lockb
└── drizzle.config.ts
```

Each module follows the same internal layout as a Flutter feature: a router,
a service (business logic), a repository (Drizzle queries), and a schema
(Zod validation) — router calls service, service calls repository, no layer
skipping.

---

## No tenancy, no roles

There is exactly one event running on the hub at a time. Every station that
pairs with it is equivalent — there is no `owner`/`manager`/`waiter`/
`customer` role split, because there is no restaurant staff hierarchy to
model. Volunteer identity and shift accountability (PIN login, per-shift cash
reconciliation) are handled entirely client-side in `apps/agora`, not by the
hub — the hub only reconciles orders, stock, and kitchen tickets between
stations, it doesn't authenticate people.

A station is identified by a short-lived pairing token issued when it
connects, scoped to that one event's session on the hub. There is nothing to
log into and nothing that persists past the event unless the organiser
chooses to keep the hub's SQLite file (e.g. to seed next year's catalog —
see "season-to-season catalog reuse" in `ECOSYSTEM.md`).

---

## Real-time

All cross-station state uses WebSockets via Hono's native WebSocket support.

**Topic structure:**

```
orders            ← new orders, order status changes, from any station
stock             ← stock count changes, from any station
kitchen:{stand}   ← ticket queue for a given prep stand
```

Every paired station subscribes to `orders` and `stock`; a station acting as
a prep stand additionally subscribes to its `kitchen:{stand}` topic. The
`realtime` module is the only place that manages WebSocket connections and
broadcasts — other modules emit domain events and the realtime module routes
them to connected stations.

---

## Sync model

Each station keeps working against its own local Drift database even when
disconnected from the hub — this is not optional, it's the baseline (see
`packages/sync_engine`, already built: outbox queue + connectivity monitor +
managed WebSocket with reconnect). When paired:

1. A station action (new order, stock adjustment, ticket bumped) writes
   locally first, then enqueues to the outbox.
2. `sync_engine` pushes the outbox entry to the hub over the LAN WebSocket.
3. The hub applies it and broadcasts the resulting state to every other
   paired station on the relevant topic.
4. If the hub is unreachable, the outbox queue simply grows and drains once
   reconnected — no sale is ever lost or blocked on connectivity.

Conflict resolution is intentionally simple for this scope: orders are
append-only (no cross-station edit conflicts), and stock adjustments are
applied as deltas, not absolute writes, so concurrent decrements from two
stations both apply correctly.

---

## Build order

1. `db/schema.ts` — orders, order items, stock, kitchen tickets
2. `catalog/` — read-only mirror, seeded from whichever station starts the hub
3. `ordering/` — order lifecycle, append-only
4. `realtime/` — WebSocket hub wired to ordering events
5. `inventory/` — stock delta sync, depends on ordering
6. `kitchen/` — ticket queue + per-stand routing, depends on ordering + realtime

---

## Related docs

- [ECOSYSTEM.md](./ECOSYSTEM.md) — product scope and why LAN sync is the
  top-priority feature.
- `docs/FESTIVAL_POS_TASKS.md` — Phase 9 tracks the client-side wiring of
  `packages/sync_engine` against this hub.
