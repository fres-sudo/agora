# Agora — Backend Architecture

## Technology stack

| Concern | Choice | Rationale |
|---|---|---|
| Runtime | **Bun** | Fast startup, built-in SQLite for local dev, native WebSocket, TypeScript out of the box |
| Framework | **Hono** | Lightweight, edge-compatible, first-class WebSocket support, familiar to the team |
| Database | **PostgreSQL** | ACID transactions, row-level security, `LISTEN/NOTIFY` for pub/sub |
| ORM | **Drizzle** | TypeScript-first, zero-overhead query builder, pairs naturally with Hono/Bun |
| Auth | **Better Auth** | TypeScript-native, works with Hono middleware, handles JWT + sessions + roles |
| Real-time | **Hono WebSockets** | Native in Bun, no extra dependency, sufficient for the kitchen/POS use case |

The same codebase runs locally (festival paid tier) and deployed to a VPS or Cloudflare Workers (restaurant SaaS). No rewrite needed between environments.

---

## Architecture: modular monolith

The backend is a **single deployable process** divided into well-bounded modules. Microservices are not used.

**Why not microservices:** Order creation touches catalog (validate products), inventory (decrement stock), tables (update table state), and kitchen (push to queue) — all in one database transaction. Splitting these across services introduces distributed transactions, saga patterns, and network failure modes that add complexity without benefit at this scale.

**The escape hatch:** Each module has a clean public interface (exported functions/types only, no cross-module database queries). If a module like `reporting` needs independent scaling in the future, it can be extracted with surgical effort. That decision is deferred until there is evidence it is needed.

---

## Repository layout

```
backend/
├── src/
│   ├── index.ts                  ← Hono app entry point, route mounting
│   ├── middleware/
│   │   ├── auth.ts               ← JWT validation, session middleware
│   │   └── tenant.ts             ← resolves tenant from JWT, sets context
│   ├── modules/
│   │   ├── auth/                 ← signup, login, password reset, JWT
│   │   ├── tenants/              ← tenant + location management
│   │   ├── catalog/              ← products, categories, modifiers, pricing
│   │   ├── ordering/             ← orders, order items, order lifecycle
│   │   ├── inventory/            ← stock levels, depletion on order confirm
│   │   ├── tables/               ← table layout, sessions, reservations
│   │   ├── kitchen/              ← order queue, item status, station routing
│   │   ├── discounts/            ← promo codes, happy hour rules, loyalty
│   │   ├── payments/             ← payment recording (cash, card, split)
│   │   ├── reporting/            ← daily summaries, top products, revenue
│   │   └── realtime/             ← WebSocket hub, topic broadcasting
│   ├── db/
│   │   ├── schema.ts             ← Drizzle schema (all tables)
│   │   └── migrations/           ← SQL migration files
│   └── lib/
│       ├── errors.ts             ← typed error classes
│       └── result.ts             ← Result<T, E> pattern
├── package.json
├── bun.lockb
└── drizzle.config.ts
```

### Module structure

Each module follows the same internal layout:

```
modules/ordering/
├── router.ts       ← Hono routes for this module
├── service.ts      ← business logic (no HTTP, no DB)
├── repository.ts   ← Drizzle queries (no business logic)
├── schema.ts       ← Zod validation schemas for request/response
└── index.ts        ← public exports (router + any shared types)
```

The `service.ts` layer is the only place business rules live. Routers call services; services call repositories. Services never touch the HTTP layer; repositories never contain business logic.

---

## Multi-tenancy

**Strategy: row-level isolation with `tenant_id`**

Every table that holds tenant-specific data carries a `tenant_id` column. PostgreSQL Row Level Security (RLS) enforces this at the database level as a second line of defence.

```sql
-- example: orders table
CREATE TABLE orders (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id),
  location_id UUID NOT NULL REFERENCES locations(id),
  status      TEXT NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON orders
  USING (tenant_id = current_setting('app.current_tenant')::uuid);
```

The `tenant.ts` middleware resolves the tenant from the JWT on every request and sets `app.current_tenant` on the database connection. All downstream queries are automatically scoped — no manual `WHERE tenant_id = ?` is required in application code.

**Why row-level over schema-per-tenant:** Schema-per-tenant requires running migrations N times (once per tenant) and complicates connection pooling. At early scale, row-level with RLS is simpler to operate, easier to query across tenants for platform analytics, and sufficient for isolation.

**Tenant model:**

```
Tenant (restaurant group / festival organiser)
  └── Location (restaurant branch / festival stand)
        └── User
              └── Role: owner | manager | waiter | kitchen | customer
```

A JWT carries `tenantId`, `locationId`, and `role`. The middleware resolves all three before any route handler runs.

---

## Real-time

All real-time features use WebSockets via Hono's native WebSocket support (Bun's built-in `WebSocketHandler`).

**Topic structure:**

```
order:{locationId}          ← new orders, order status changes
table:{locationId}          ← table state changes
kitchen:{locationId}:{station}  ← per-station item updates
```

Clients subscribe to the topics they care about:

| Client | Subscribes to |
|---|---|
| Kitchen display | `kitchen:{locationId}:{station}` |
| POS terminal | `order:{locationId}`, `table:{locationId}` |
| Waiter app | `order:{locationId}`, `table:{locationId}` |
| Customer app | `order:{locationId}:{orderId}` (their order only) |

The `realtime/` module is the only place that manages WebSocket connections and broadcasts. Other modules emit domain events; the realtime module listens and routes them to connected clients.

---

## Auth

**Better Auth** handles authentication. It runs as Hono middleware.

**Roles and permissions:**

| Role | Scope | Can do |
|---|---|---|
| `owner` | tenant | everything including billing, user management |
| `manager` | location | configure catalog, view reports, manage staff |
| `waiter` | location | create/update orders, view table state |
| `kitchen` | location | update item status in kitchen queue |
| `customer` | — | view menu, place orders on their own table session |

Role is encoded in the JWT. Route handlers check it via middleware:

```typescript
// middleware check example
app.use('/api/reports/*', requireRole('manager', 'owner'))
```

---

## Deployment

**Festival paid tier (local):**
```bash
bun run start   # runs on organiser's MacBook/Pi on local network
```
- SQLite via Bun's built-in driver (no PostgreSQL setup needed for local-only events)
- POS tablets and kitchen display connect via local WiFi

**Restaurant SaaS (cloud):**
- Single VPS (e.g. Hetzner) running PostgreSQL + Bun process behind a reverse proxy
- Or Cloudflare Workers for the HTTP layer + Neon/Supabase for PostgreSQL
- No Docker required for the Bun process; PostgreSQL can be managed or self-hosted

The switch between local (SQLite) and cloud (PostgreSQL) is handled by a `DATABASE_URL` environment variable. Drizzle supports both dialects with minimal adapter changes.

---

## Build order

Modules should be built in dependency order:

1. `db/schema.ts` — define all tables, run initial migration
2. `auth/` — signup, login, JWT issuance
3. `tenants/` — tenant and location CRUD, role assignment
4. `catalog/` — products, categories, modifiers (no tenant needed to seed)
5. `ordering/` — core order lifecycle
6. `realtime/` — WebSocket hub wired to ordering events
7. `kitchen/` — order queue + item status, depends on ordering + realtime
8. `tables/` — table sessions and reservations
9. `inventory/` — stock depletion, depends on ordering
10. `discounts/` — promo logic, depends on ordering and catalog
11. `payments/` — payment recording, depends on ordering
12. `reporting/` — aggregations, depends on ordering, payments, inventory
