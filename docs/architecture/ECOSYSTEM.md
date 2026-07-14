# Agora — Product Ecosystem

## What Agora is

Agora is an offline-first point-of-sale for **Italian sagre, village festivals,
and small pop-up events** — run by volunteer *pro-loco* associations and
organisers under the *legge 398/1991* non-commercial exemption, not by
commercial restaurants or ticketed venues. One Flutter app, no cloud
dependency, no subscription required to operate.

The segment is defined by what it explicitly excludes: large ticketed
commercial events (different league — needs RFID cashless hardware, out of
scope), and full restaurant/bar/café table-service venues (a different
product; see `docs/architecture/PAYMENTS_AND_FISCAL.md` for why fiscal
receipt/RT integration is parked rather than built for this segment).

The competitive gap is not missing features — incumbents (MisterPOS,
GestiFEST, Ge.Sa., Sagra Touch, Festa di Paese, Esagra) are established,
functional, and cover this market. The gap is that they are all dated Windows
desktop tools. Agora competes on UX and modernity: a tablet-native, offline,
dead-simple POS built for the way sagre actually run — several simultaneous
stands, seasonal volunteer staff, one treasurer buying the software once a
year.

---

## Applications

| App | Target |
|---|---|
| `apps/agora` | Sagra / festival stand operators |

There is exactly one app. It is fully self-contained: no network dependency
to take a sale, no separate kitchen/kiosk/customer/waiter apps. Multi-station
coordination (below) happens over the local network between instances of the
same app, not through separate installable products.

---

## Core features (MVP, priority order)

1. **Multi-station LAN sync, no cloud** — the biggest real gap versus
   incumbents. Sagre typically run 3–5 simultaneous registers (one per stand)
   that need to share a live order queue and stock count without any internet
   connection. See [BACKEND.md](./BACKEND.md) for the local sync hub design.
2. **Kitchen/stand order ticket routing** — an order taken at a cash stand
   routes to the right prep stand (grill, drinks, desserts) as a printed or
   displayed ticket, over the same LAN sync.
3. **Combo/modifier pricing** — bundle pricing for the classic sagra combo
   (panino + patatine + bibita), built on the existing modifier-group model.
4. **Volunteer shift accountability** — PIN login per volunteer plus
   per-shift cash reconciliation (declared vs. counted cash at handover).
5. **Outdoor-readable, dead-simple UI** — legible in direct sunlight, usable
   by non-technical seasonal volunteers with no training.
6. **Season-to-season catalog/pricing reuse** — a *pro-loco* runs largely the
   same menu every year; last year's catalog and prices should be one tap to
   restore, not manual re-entry.
7. **Single-provider Bluetooth card reader integration** — one payment
   provider (SumUp or Satispay — see `PAYMENTS_AND_FISCAL.md`), not a
   multi-acquirer abstraction. Optional add-on; cash remains the default.
8. **Flat one-time/seasonal pricing** — matches how a *pro-loco* treasurer
   actually buys software: a single purchase or seasonal licence, not a
   percentage-of-revenue or per-transaction cut.

Italian fiscal receipt (RT/PEM-PEL) integration is explicitly **not** in this
list — most volunteer sagre are legally exempt under legge 398/1991. It is
parked, not abandoned; revisit only if a commercial-fair segment that cannot
use the exemption becomes a target. See `PAYMENTS_AND_FISCAL.md`.

---

## Local sync (no cloud)

Multiple `apps/agora` instances on the same event's WiFi/LAN share one order
queue, one stock count, and route kitchen tickets — all without any internet
connection or hosted backend. One station (the organiser's laptop, a Raspberry
Pi, or simply the busiest tablet) runs a small local server that the other
stations connect to over the LAN. See [BACKEND.md](./BACKEND.md) for the full
design.

If the local hub is unreachable (not yet started, or a station drops off
Wi-Fi), each station keeps working standalone against its own local Drift
database and reconciles once reconnected. A single-station event needs no
hub at all — it is the same app, just never syncing.

---

## Shared Flutter packages

| Package | Purpose |
|---|---|
| `packages/ui_kit` | Shared widgets |
| `packages/theme` | Design tokens, theming |
| `packages/i18n` | Localisation (Italian + English) |
| `packages/database` | `AgoraDatabase` (local Drift/SQLite) |
| `packages/result` | `Result<T, E>` pattern |
| `packages/errors` | Typed exceptions |
| `packages/logger` | Talker wrapper |
| `packages/sync_engine` | LAN sync primitives (outbox, WebSocket, reconnect) |

`features/*` packages compose into the single `apps/agora` app — there is no
restaurant/bar/other-vertical variant to keep separate.

---

## Build phases

### Phase 1 — Standalone free POS (current focus)

Scope: single Flutter app, fully offline, no LAN sync yet.

- Local Drift database with products, categories, modifiers
- Cart and order building, checkout, stock decrement
- Thermal printer integration (Bluetooth + USB)
- End-of-day local sales report
- PIN login + per-shift cash reconciliation

Deliverable: a working, shippable single-station POS for a sagra stand with
zero infrastructure. Tracked in detail in `docs/FESTIVAL_POS_TASKS.md`.

### Phase 2 — Local LAN sync hub

Scope: the local server described in `BACKEND.md`, plus multi-station wiring
in the app via `packages/sync_engine`.

- Local hub process (runs on a laptop/Pi on the event's LAN)
- Shared order queue and stock count across stations
- Kitchen/stand ticket routing over the same LAN

Deliverable: 3–5 stations at one event sharing state with no internet
connection — the headline differentiator versus every desktop incumbent.

### Phase 3 — Card payment

Scope: one Bluetooth card reader integration (SumUp or Satispay).

- `PaymentProvider` abstraction with a single concrete implementation
- Cash remains the default and only requirement; card is additive

### Phase 4 — Season-to-season catalog reuse

Scope: catalog/pricing snapshot and restore, so a returning *pro-loco* can
relaunch last year's setup in minutes.

---

## Related docs

- [BACKEND.md](./BACKEND.md) — local LAN sync hub design.
- [PAYMENTS_AND_FISCAL.md](./PAYMENTS_AND_FISCAL.md) — card payment provider
  choice and why fiscal/RT integration is parked.
- [ARCHITECTURE.md](./ARCHITECTURE.md) — monorepo layout and feature-package
  rules.
- `docs/FESTIVAL_POS_TASKS.md` — the live implementation task plan.
