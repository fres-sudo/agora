# Agora — Payments & Italian Fiscal Compliance

> **Status:** design decision + market research. Nothing here is implemented yet.
> This doc records the strategy for accepting card payments for the
> sagra/village-festival segment, and explains why Italian fiscal-receipt
> compliance is explicitly **parked**, not built.
>
> **Not tax/legal advice.** All figures and rules are Italy-specific and dated to
> mid-2026; they change often. Confirm live provider pricing and current AdE
> rules with a *commercialista* before shipping or quoting a customer.

---

## 0. The one idea to hold onto

Most sagre/village festivals run under the *legge 398/1991* non-commercial,
cost-covering exemption and are **not legally required** to issue a fiscal
receipt (*scontrino elettronico*) for their sales. That single fact shapes
this whole doc:

```
Payment  = accepting the customer's money      → one Bluetooth card reader, optional add-on
Fiscal   = recording the sale to Agenzia Entrate → PARKED — most of this segment doesn't need it
```

Agora is **not** trying to be a fiscally-compliant register for commercial
venues. It's a cash-first POS with an optional card add-on for volunteer
event stands.

---

## 1. Payment acceptance

### 1.1 Scope for this segment

Card payment is **not** a legal requirement for most sagre — it's a
convenience add-on. Cash is, and stays, the default and the only thing that
has to work with zero setup. The MVP integrates **one** provider behind a
Bluetooth reader, not a multi-acquirer abstraction:

- No PCI/gateway build of our own.
- No payment-provider abstraction layer across multiple acquirers — one
  concrete integration, kept thin.
- Optional: an event can run entirely on cash and never touch this.

### 1.2 How the money actually moves

Every card payment follows the same chain, regardless of provider:

```
customer taps card
  → Bluetooth reader captures it
  → ACQUIRER (SumUp/Satispay) authorizes
  → card network / bank rails
  → funds settle to the organiser's account, minus the fee
```

We integrate an existing acquirer's SDK/API — becoming a licensed
acquirer/PSP ourselves would require PSD2 authorization from Banca d'Italia,
out of scope for this product.

### 1.3 Candidate providers (Italy, mid-2026)

| Provider | What it is | Merchant pays | Why it fits this segment |
|---|---|---|---|
| **SumUp** | Card acquirer, Bluetooth reader | ~**1.69%**/txn, or **0.99%** with a paid sub. Solo reader **€79**. | Cheap hardware, no monthly commitment needed, works for a one-weekend event. |
| **Satispay** | Bank-to-bank wallet, no card rails | **0% under €10**, **0.95%** at €10+. No card hardware to buy. | Zero hardware cost, popular with small Italian food/drink stands already; fee structure favours small tickets. |

**Decision needed (not yet made):** pick one. SumUp is the safer default
(actual card acceptance, a physical reader the volunteer can hand around);
Satispay removes hardware cost entirely but requires the customer to have
the Satispay app, which not every festival-goer will. This is the next open
decision, not resolved by this doc.

**What the provider charges us (the developer):** effectively nothing —
both providers' SDKs/APIs are free to integrate; the fee above is the
organiser's, not ours.

### 1.4 Why a merchant picks Agora over a bare SumUp/Satispay app

We are not competing on payments — SumUp's and Satispay's own apps already
accept a card. We compete on running the stand:

1. **Offline-first** — proven for exactly this use case: a field or piazza
   with no reliable connectivity. SumUp/Satispay's own apps degrade without
   it.
2. **Multi-stand coordination (roadmap)** — a shared order queue, stock
   count, and kitchen ticket routing across 3–5 registers over the local
   network, with no internet connection. See `ECOSYSTEM.md` / `BACKEND.md`.
3. **Volunteer-shaped workflow** — PIN login per volunteer, per-shift cash
   reconciliation, season-to-season catalog reuse. None of this exists in a
   bare payment app.
4. **Flat pricing** — a one-time or seasonal licence, the way a *pro-loco*
   treasurer already budgets, not a cut of revenue.

Mental model: the customer taps on a SumUp/Satispay reader, but **the order,
the kitchen ticket, the stock decrement, and the end-of-event report all
happen in Agora.** The card reader is a peripheral, not the product.

---

## 2. Italian fiscal compliance — parked

### 2.1 Why this is out of scope for now

Since 2021/2022, Italian commercial sales generally require an electronic
fiscal receipt (*documento commerciale*), historically via a certified
hardware **Registratore Telematico (RT)**, transmitted to the Agenzia delle
Entrate. **Legge 398/1991** exempts qualifying non-commercial associative
activity — the *pro-loco*/volunteer-sagra model this product targets — from
that obligation, provided the activity stays within the exemption's
conditions (cost-covering, non-commercial, association-run).

Because that covers most of the target segment, building fiscal-receipt
compliance now would be significant engineering effort spent on a
requirement most customers don't have.

### 2.2 When to revisit this

Only if the product later targets a **commercial-fair segment that cannot
use the legge 398 exemption** (e.g. a for-profit event operator, or a sagra
structured in a way that falls outside the exemption's conditions). If that
happens, the relevant background — the 2026 software-RT (PEM/PEL) path and
the POS↔RT link obligation — should be re-researched at that time, since
rules and provider pricing shift often. Do not build against it speculatively.

### 2.3 What this means in the product

- No RT/PEM-PEL integration.
- No fiscal receipt printing — a plain courtesy receipt (already covered by
  the existing thermal-printer feature) is sufficient.
- Do not present "fiscal compliance" as a feature, shipped or planned, in
  any customer-facing material. *(Verify per-case with a commercialista —
  this doc is not a blanket legal opinion for every organiser.)*

---

## 3. Integration plan (Flutter) — once a provider is chosen

### 3.1 SumUp, if chosen

| Path | How | UX | Needs |
|---|---|---|---|
| **Reader SDK (Mobile SDK)** | Embed SumUp in the app; drives the Bluetooth reader. App calls `checkout(amount)` → SDK runs the flow → returns result. | Fully in-app | Native Android/iOS SDK — no official Flutter plugin; wrap via MethodChannel |
| **Cloud API** | App sends an HTTPS request with the amount to a standalone Solo reader; result via webhook. | Reader is a separate device | Solo reader + API keys |
| **Payment Switch (app-to-app)** | App opens the SumUp app passing the amount; SumUp processes; returns to our app. | Jumps to the SumUp app and back | Least code, quickest to ship |

### 3.2 Satispay, if chosen

Satispay is bank-to-bank via the customer's Satispay app (QR/NFC handshake),
not card rails — integration is via Satispay's business API, not a card SDK.
No physical reader to provision.

### 3.3 Keep it a single, thin integration

Do **not** build a multi-provider `PaymentProvider` abstraction for this —
that complexity is only worth it if a second provider is actually demanded.
One concrete integration, called directly from the checkout flow, is enough:

```dart
class CardPaymentService {
  Future<PaymentResult> charge({
    required Money amount,
    required String orderId,
  });
}
```

The cashier hits **Charge** → picks Card → the reader/app prompts for the
amount → `PaymentResult` (with a transaction id) is attached to the order.

### 3.4 Constraints to design around

- **Card payment is inherently online** (the acquirer authorizes in real
  time). In a fully offline moment, the app falls back to cash — card is
  additive, never a blocker to completing a sale.
- **Keep secrets off the device** where the chosen provider requires
  server-minted tokens — confirm whether the chosen provider needs this
  before assuming a backend is required just for payments.

---

## 4. Recommended sequencing

1. **Ship cash-only first.** No payment integration at all — this is
   already most of the value for most sagre.
2. **Decide the single provider** (§1.3 — SumUp vs. Satispay) once there's a
   concrete organiser asking for card acceptance.
3. **Add the one `CardPaymentService` integration**, flat pricing unaffected
   (§4 of `ECOSYSTEM.md` — no per-transaction cut on the software side;
   whatever the provider charges is between the organiser and the provider).
4. **Do not build fiscalization** unless the target segment changes (§2.2).

---

## Sources (retrieved mid-2026)

**Fiscal / regulation**
- Confcommercio — obbligo collegamento POS-RT: <https://www.confcommercio.it/-/obbligo-collegamento-pos-e-registratori-di-cassa>
- fiskaly — corrispettivi telematici senza hardware (software RT PEM/PEL): <https://www.fiskaly.com/it/blog/scadenza-rt-2026%E2%80%93comunicazione-corrispettivi-telematici-senza-hardware>

**Payments**
- SumUp Developer — In-Person Payments (SDKs / Cloud API / Switch): <https://developer.sumup.com/terminal-payments>
- SumUp — pricing & fees: <https://help.sumup.com/en-US/articles/4oI3qHHji2I2S9dyvRfec3-pricing-fees>
- Satispay Business — costi: <https://www.satispay.com/it-it/business/costi/>

## Related docs
- `ECOSYSTEM.md` — product scope, feature priority list, flat pricing model.
- `BACKEND.md` — local LAN sync hub (unrelated to payments, but the other
  half of the "why switch from a bare payment app" pitch).
