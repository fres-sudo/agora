# Feature implementation plans

One file per planned product feature. Items 1–7 mirror the MVP priority list
in `docs/architecture/ECOSYSTEM.md`; item 8 is a proposed opt-in cloud
publisher that is deliberately separate from the local LAN hub. Each file
covers description, why, what's in/out of scope, exactly where in the
codebase it lands, and how to build it — grounded in the actual current code,
not the older planning docs under `docs/` (several of which, e.g.
`docs/FESTIVAL_POS_TASKS.md`'s P7-5/P7-6 and P3-4, are now stale — this was
cross-checked against real code, not assumed from those docs).

1. [Multi-station LAN sync, no cloud](01-lan-sync.md)
2. [Kitchen/stand order ticket routing](02-kitchen-ticket-routing.md) — depends on #1 for cross-station push
3. [Combo/modifier pricing](03-combo-modifier-pricing.md)
4. [Volunteer shift accountability (PIN login + cash reconciliation)](04-volunteer-shift-accountability.md) — PIN login already built; cash reconciliation is new
5. [Outdoor-readable, dead-simple UI](05-outdoor-ui.md) — design-system change, cross-cutting
6. [Season-to-season catalog/pricing reuse](06-season-to-season-catalog-reuse.md)
7. [Single-provider Bluetooth card reader integration](07-card-reader-integration.md) — provider choice (SumUp vs. Satispay) still open
8. [Public menu QR publishing](08-public-menu-qr.md) — proposed opt-in cloud feature; server work is deferred

## A note on current architecture (relevant to every plan above)

While researching these plans, the real package layout turned out to have
drifted from what `CLAUDE.md`/`docs/architecture/ARCHITECTURE.md` describe.
`packages/catalog`, `packages/order_management`, and `packages/discounts`
now hold shared domain models, repository interfaces, **and** shared BLoCs
(e.g. `ProductsBloc`, `CheckoutCubit`) — not just cross-cutting infra — so
that two or more `features/*` packages can consume the same domain without
importing each other directly (`features ↛ features` is still upheld, just
via a new intermediate layer the docs don't mention). `packages/
inventory_contracts` is the one package still matching the old
"pure-contracts, no logic" description.

Every plan above follows this real pattern (e.g. `07-card-reader-
integration.md` proposes `packages/payment_contracts` mirroring
`inventory_contracts`). This is worth a documentation fix in
`docs/architecture/ARCHITECTURE.md`/`DEPENDENCY_RULES.md` at some point —
not done as part of this batch, flagging it here so it isn't lost.
