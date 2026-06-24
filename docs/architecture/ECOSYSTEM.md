# Agora — Product Ecosystem

## What Agora is

Agora is a hospitality management platform delivered as two distinct product lines that share one backend and one Flutter monorepo:

1. **Festival POS** — a lightweight, offline-first point-of-sale for events and festivals. Free tier works with zero internet. Paid tier connects to the cloud to unlock kitchen sync and multi-terminal sync.
2. **Restaurant SaaS** — a full-featured cloud platform for restaurants, covering POS, kitchen display, self-ordering totems, table reservations, and waiter assistance.

---

## Applications

| App | Target | Product line |
|---|---|---|
| `apps/festival_pos` | Event/festival operators | Festival POS |
| `apps/pos` | Restaurant staff | Restaurant SaaS |
| `apps/kitchen` | Kitchen staff | Restaurant SaaS |
| `apps/totem` | Customers at self-order kiosk | Restaurant SaaS |
| `apps/client_app` | Customers on their own device | Restaurant SaaS |
| `apps/waiter` | Waiting staff on handheld | Restaurant SaaS |

---

## Festival POS

### Free tier (fully local, no backend)

The free tier is a self-contained Flutter app with no network dependency:

- Products and categories configured locally on device
- Cart building with modifiers and quantities
- Receipt printing via Bluetooth/USB thermal printer
- Local Drift (SQLite) database for end-of-day sales summary
- Zero internet required — works at festivals with no connectivity

### Paid tier (cloud-connected)

When the operator subscribes, the same app connects to the Agora backend and unlocks:

- **Kitchen display sync** — orders appear on the kitchen screen in real-time over WebSocket
- **Multi-terminal sync** — multiple POS tablets share the same order queue
- **Cloud reports** — sales data synced to the cloud for post-event analysis

The paid tier does not replace the free tier — it extends it. Offline mode remains available as a fallback even when a subscription is active.

### Freemium boundary

```
Free  │  cart → local Drift DB → thermal printer
──────│──────────────────────────────────────────
Paid  │  cart → local Drift DB → thermal printer
      │               ↓
      │         sync to backend (LAN or internet)
      │               ↓
      │     kitchen display  /  other POS terminals
```

A festival operator is a regular tenant in the Agora backend. Their subscription plan determines which features are unlocked — no separate backend or codebase required.

---

## Restaurant SaaS

### Applications and their scope

**`apps/pos` — Restaurant POS**

Used by cashiers and waiters at the counter or tableside:
- Table session management (open, transfer, split)
- Order building with products, categories, modifiers
- Discount and promo code application
- Payment processing (cash, card, split)
- End-of-day Z-report
- Offline resilience: queues orders locally if connectivity drops

**`apps/kitchen` — Kitchen Display System**

Used by kitchen staff:
- Real-time order queue via WebSocket
- Per-station routing (grill, fryer, drinks)
- Item-level status (pending → in progress → ready)
- Order bump (mark complete, move to next)

**`apps/totem` — Self-Order Totem**

Used by customers at a kiosk:
- Browse menu by category
- Build and customise order
- Submit directly to kitchen
- QR/NFC table identification

**`apps/client_app` — Customer Mobile App**

Used by customers on their own device:
- Browse menu
- Place orders from table
- Track order status in real-time
- View and pay bill
- Make table reservations

**`apps/waiter` — Waiter Assistant**

Used by floor staff on a handheld device:
- View table status and floor map
- Take orders at table (sends to kitchen)
- Flag items ready for delivery
- May share features with the restaurant POS — to be decided

### Feature scope per app

| Feature | festival_pos | pos | kitchen | totem | client_app | waiter |
|---|---|---|---|---|---|---|
| Catalog browsing | free | ✓ | — | ✓ | ✓ | ✓ |
| Cart / order building | free | ✓ | — | ✓ | ✓ | ✓ |
| Thermal printer | free | ✓ | — | — | — | — |
| Kitchen queue (receive) | paid | — | ✓ | — | — | — |
| Kitchen queue (send) | paid | ✓ | — | ✓ | ✓ | ✓ |
| Multi-terminal sync | paid | ✓ | — | — | — | — |
| Table management | — | ✓ | — | — | — | ✓ |
| Reservations | — | ✓ | — | — | ✓ | — |
| Payment processing | — | ✓ | — | ✓ | ✓ | — |
| Discounts | — | ✓ | — | ✓ | — | ✓ |
| Reports | — | ✓ | — | — | — | — |
| Order status tracking | — | — | ✓ | ✓ | ✓ | ✓ |

---

## Shared backend

All paid features and all restaurant apps connect to the same Hono/Bun backend. See [BACKEND.md](./BACKEND.md) for the full backend specification.

A **tenant** is any subscribing customer — a festival organiser or a restaurant. The backend is agnostic to the type; subscription plan and feature flags determine what is available.

---

## Shared Flutter packages

Festival POS and restaurant apps share infrastructure packages but not feature packages:

| Package | Used by |
|---|---|
| `packages/ui_kit` | All apps |
| `packages/theme` | All apps |
| `packages/i18n` | All apps |
| `packages/database` | All apps (local Drift) |
| `packages/result` | All apps |
| `packages/errors` | All apps |
| `packages/logger` | All apps |
| `packages/sync_engine` | festival_pos (paid), pos |

Feature packages (`features/*`) are restaurant SaaS only. The festival POS is intentionally simple and does not import them.

---

## Build phases

### Phase 1 — Festival POS free tier

Scope: single Flutter app, no backend.

- Local Drift database with products, categories, modifiers
- Cart and order building
- Thermal printer integration (Bluetooth + USB)
- End-of-day local sales report

Deliverable: a working, shippable POS for festivals with zero infrastructure.

### Phase 2 — Restaurant SaaS backend foundation

Scope: Hono/Bun + PostgreSQL backend, no Flutter yet.

- Multi-tenant auth (signup, login, JWT, roles)
- Tenant and location management
- Catalog API (products, categories, modifiers)
- Orders API (create, update status)
- Real-time WebSocket hub (kitchen channel)

Deliverable: a running API that the next Flutter apps can connect to.

### Phase 3 — Kitchen Display + Restaurant POS

Scope: first two restaurant Flutter apps.

- `apps/kitchen` — connects to backend WebSocket, displays order queue
- `apps/pos` — full restaurant POS connecting to backend, offline-resilient

### Phase 4 — Festival POS paid tier

Scope: extend the existing festival POS app.

- Subscription check on startup
- Backend connection when paid
- Kitchen sync via WebSocket
- Multi-terminal order sync

No new backend work needed — the Phase 2 backend already supports this.

### Phase 5 — Customer-facing apps

Scope: totem, client app, waiter app.

- `apps/totem`
- `apps/client_app`
- `apps/waiter`
