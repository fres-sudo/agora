# Feature 7 — Single-provider Bluetooth card reader integration

> Priority #7. Optional add-on, not a legal requirement for most sagre —
> cash stays the default. One provider, thin integration, no multi-acquirer
> abstraction. Full strategy in `docs/architecture/PAYMENTS_AND_FISCAL.md`.

## Description

Let an operator accept card payment via one Bluetooth card reader provider
(SumUp or Satispay — undecided, see open question) at checkout, as an
alternative to cash.

## Why

Card acceptance is a convenience add-on for this segment (most sagre are
under no legal obligation to accept it), but it's increasingly expected by
festival-goers and cheap to add well behind a thin integration. Per
`PAYMENTS_AND_FISCAL.md`, this is deliberately **not** a payment-agnostic
multi-provider abstraction — that complexity isn't justified until a second
provider is actually demanded by a real organiser.

## What's in scope

- Real charge processing for the existing "Card" payment method — today it
  does not exist (see below).
- Decline/cancel handling at checkout — today there is none.
- Cash remains fully functional with zero dependency on this feature.

**Out of scope:** a `PaymentProvider` abstraction spanning multiple
acquirers, any fiscal/RT linkage (explicitly parked, see
`PAYMENTS_AND_FISCAL.md` §2), online/e-commerce payment.

## Where — the surprise finding

Confirmed by reading the code: **"Card" already exists as a selectable
payment method today, but it does nothing.**

- `packages/order_management/lib/models/payment_method.dart` — the
  `PaymentMethod` enum already has exactly two values, `cash` and `card`
  (doc comment on the file literally says *"Phase 1 ships a fixed set (cash
  + card). Phase 4 (P4-5) will let operators configure/label the available
  methods"* — so this enum does **not** need a new variant, contrary to
  what you might expect; it needs its existing `card` variant to actually
  charge something).
- `features/pos/lib/presentation/widgets/checkout/checkout_sheet.dart` —
  the checkout button already reads `'Charge Card'` when `PaymentMethod.card`
  is selected (line ~139) and calls `cubit.confirm()` — visually complete,
  functionally a no-op.
- **`CheckoutCubit.confirm()`**
  (`packages/order_management/lib/blocs/checkout/checkout_cubit.dart:103-164`)
  — this is the exact and only integration point. Today, for *both* cash
  and card, it does the same thing: mark the order `completed`, set
  `paymentMethod: method.label` (lines 112-115), persist via
  `_ordersRepository.createOrder` (line 126). **No charge/authorization
  call happens for "Card" today** — clicking the button just records the
  sale as paid. There is also no decline/failure path in this method beyond
  a generic DB-write failure (`CheckoutState.failure`, lines 153-162) — a
  real card decline needs its own distinct failure state.
- `packages/database/lib/src/tables/orders_table.dart` —
  `paymentMethod` is a free-text nullable column, not a constrained enum at
  the DB level, so no migration is needed to record a real charge's
  provider/transaction id if desired (see Step 3).
- Confirmed via repo-wide `pubspec.yaml` grep: **no payment SDK dependency
  exists anywhere** (`mek_stripe_terminal`, `sumup`, `satispay`, etc. all
  return zero matches) — this is a from-scratch SDK integration, not
  wiring up something half-present.

Per the shared-domain-package convention, and because `CheckoutCubit` (the
call site) already lives in `packages/order_management`: define the
abstract charge contract as a **new pure-contract package**,
`packages/payment_contracts`, mirroring `packages/inventory_contracts`
exactly (interface + value types, zero implementation, zero SDK
dependency) — this keeps `packages/order_management` free of any
Bluetooth/platform-channel/SDK code while still letting `CheckoutCubit`
depend on the abstraction. The concrete SDK-backed implementation lives in
`features/pos` (the only feature that needs the real reader), wired in
`apps/agora/lib/app/app_providers.dart` like every other concrete service.

## How

### Step 1 — Decide the provider (blocks everything else)

Per `PAYMENTS_AND_FISCAL.md` §1.3, this is an **open decision**, not yet
made: SumUp (actual card acceptance, €79 physical Bluetooth reader, no
official Flutter SDK — needs a native Android/iOS SDK wrapped via
MethodChannel, or the Cloud API against a standalone Solo reader) vs.
Satispay (bank-to-bank via the customer's own phone app, zero hardware cost
to the organiser, but requires the customer to have Satispay installed).
Everything below assumes SumUp as a working example since it's the more
conventional "reader in the cashier's hand" model; swap accordingly if
Satispay is chosen — the contract in Step 2 is provider-agnostic by design.

### Step 2 — `packages/payment_contracts`

```dart
abstract interface class CardPaymentService {
  Future<CardChargeResult> charge({
    required Money amount,
    required String orderId, // ties the charge back to the order being completed
  });
}

@freezed
class CardChargeResult with _$CardChargeResult {
  const factory CardChargeResult.approved({required String transactionId}) = _Approved;
  const factory CardChargeResult.declined({String? reason}) = _Declined;
  const factory CardChargeResult.cancelled() = _Cancelled; // operator/customer backed out
}
```
No provider-specific types leak into this package — matches
`inventory_contracts`'s existing "contracts only, no logic" shape exactly.

### Step 3 — Concrete implementation in `features/pos`

- `SumUpCardPaymentService implements CardPaymentService` — wraps whichever
  integration path Step 1 settles on (Reader SDK via MethodChannel, or
  Cloud API + webhook against a Solo reader — see
  `PAYMENTS_AND_FISCAL.md` §3.1 for the three SumUp paths and their
  trade-offs; recommend the **Payment Switch (app-to-app)** path first if
  minimizing engineering effort matters more than staying fully in-app,
  since it needs no native SDK wrapping at all — revisit once real
  operator feedback exists on whether "jumps to the SumUp app and back" is
  acceptable UX).
- Register it in `apps/agora/lib/app/app_providers.dart` as a concrete
  `RepositoryProvider<CardPaymentService>`, alongside the other concrete
  service registrations already there (e.g. `ThermalPrinterServiceImpl`,
  `ConfigServiceImpl`) — same pattern, not a new one.

### Step 4 — Wire into `CheckoutCubit.confirm()`

- Inject `CardPaymentService` into `CheckoutCubit`'s constructor.
- When `method == PaymentMethod.card`: before the existing
  "mark completed + persist" logic (lines 112-126), call
  `cardPaymentService.charge(amount: ..., orderId: ...)` and branch:
  - `approved(transactionId)` → proceed exactly as today, plus store
    `transactionId` somewhere retrievable (simplest: append to the existing
    `note` field, or add a new nullable `paymentReference` column to
    `OrdersTable` if a dedicated field is preferred — free-text `note`
    reuse avoids a migration for v1).
  - `declined(reason)` → emit a **new** `CheckoutState.declined(reason)` (or
    extend the existing failure state to distinguish "card declined" from
    "local DB write failed" — they need different operator-facing copy:
    "Card declined, try again or use cash" vs. a generic error). Do not
    persist the order as completed.
  - `cancelled()` → return to the checkout sheet with no error styling
    (the operator/customer just backed out, not a failure).
- For cash: **no behavior change**, `confirm()` skips the charge call
  entirely — cash must never depend on this feature being present or
  working.

### Step 5 — Checkout UX for the charge round-trip

- `checkout_sheet.dart` needs a "processing" state while `charge()` awaits
  (the operator is standing there while the customer taps their card) —
  reuse whatever loading-state pattern `CheckoutState.processing` already
  provides (referenced in the current no-op flow) rather than inventing a
  new one.
- A decline must return the operator to a retryable state, not dead-end the
  checkout sheet — they should be able to immediately retry card or switch
  to cash without restarting the whole checkout flow.

## Acceptance criteria

- Selecting "Card" and completing a successful charge: order persists as
  completed with the real transaction id retrievable, identical downstream
  behavior to a cash sale (stock decrements, receipt prints, appears in
  reports).
- A declined or cancelled card charge: the order is **not** marked
  completed, the operator sees a clear, retryable state, and cash remains
  immediately available as a fallback in the same checkout sheet.
- With no card reader paired/configured at all, "Card" either doesn't
  appear as an option (reuse the existing
  `payment_method_section.dart` enable/disable toggle — default it off
  until a reader is actually configured) or fails gracefully with a clear
  "no reader connected" message — never a silent no-op like today.

## Dependencies

- None on other features in this plan. Independent of LAN sync, kitchen
  routing, combos, shift accountability, and outdoor UI.

## Open questions

- **Provider choice (SumUp vs. Satispay)** — blocks Step 1 onward; needs an
  actual organiser use case to decide against, per
  `PAYMENTS_AND_FISCAL.md`'s own "not yet resolved" note.
- **Integration path within the chosen provider** (e.g. SumUp's three
  paths) — trades off engineering effort vs. in-app polish; recommend
  picking the cheapest-to-ship path first and revisiting only if real
  operators complain about the UX of jumping to a second app mid-checkout.
