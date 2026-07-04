# Agora — Payments & Italian Fiscal Compliance

> **Status:** design decision + market research. Nothing here is implemented yet.
> This doc records the strategy, the regulatory landscape, and the integration
> plan agreed for accepting card payments and staying compliant with Italian
> fiscal law.
>
> **Not tax/legal advice.** All figures and rules are Italy-specific and dated to
> mid-2026; they change often (e.g. Satispay's rates shift in Sept 2026). Confirm
> live provider pricing and current AdE rules with a *commercialista* before
> shipping or quoting a customer.

---

## 0. The one idea to hold onto

**Payment acceptance and fiscalization are two legally separate systems.** SumUp
and friends bundle them and take a cut of every sale. Agora's strategy is to
**decouple them** and make each an *optional, provider-agnostic module*:

```
Payment  = accepting the customer's money      → pluggable acquirer (SumUp/Stripe/…)
Fiscal   = recording the sale to Agenzia Entrate → pluggable certified RT (software)
```

Owning *both* modules in one app is what lets Agora satisfy the 2026 POS↔RT link
trivially and sell a flat-price, no-per-transaction-tax product.

---

## 1. Payment acceptance

### 1.1 How the money actually moves

Every card payment follows the same chain, regardless of provider:

```
customer taps card
  → reader / phone-NFC captures it
  → ACQUIRER (SumUp/Stripe/Nexi) authorizes
  → card network (Visa / Mastercard)
  → customer's bank (issuer) approves
  → funds settle to the MERCHANT's account (T+1/T+2), minus the fee
```

The merchant's fee (**MDR** — merchant discount rate) bundles three things:
**interchange** (to the issuer bank) + **scheme fees** (Visa/MC) + the
**acquirer's margin**. SumUp/Stripe's product is hiding that complexity behind a
single flat %.

**SoftPOS / Tap to Pay** is the same chain, but the **phone's NFC chip is the
reader** — no external hardware. Visa/MC certify the phone; the provider SDK
handles card data in a secure/attested area, so **our app never sees the PAN**
(keeps us in the lightest PCI-DSS scope).

### 1.2 We integrate an acquirer — we do NOT become one

Becoming a licensed acquirer/PSP requires PSD2 authorization from Banca d'Italia —
out of scope for a solo dev. We integrate an existing acquirer's SDK/API. Two
positions:

**Position A — "Bring Your Own acquirer" (chosen default).**
The operator has their own SumUp/Stripe/Satispay account; our app talks to it via
the provider's free SDK/API. We never touch the money and **pay nothing per
transaction**. Our revenue is a **flat software subscription**. This *is* the
"no per-transaction tax" positioning.

**Position B — "Platform" (Stripe Connect), optional/later.**
We become the platform; merchants onboard through us; we add an **application fee**
(markup) that Stripe splits to us automatically. Turns payments into revenue but
makes us a mini-SumUp — revisit only *after* we own the software relationship.

### 1.3 Provider business models & merchant pricing (Italy, mid-2026)

| Provider | What it is | Merchant pays |
|---|---|---|
| **SumUp** | Acquirer + merchant account for micro-merchants | ~**1.69%**/txn, or **0.99%** with Payments Plus sub. Solo reader **€79**. Tap to Pay on iPhone included. |
| **Stripe Terminal** | Developer-first PSP + Connect platform layer | In-person EEA cards **1.4% + €0.10**; Tap to Pay +~€0.10/auth. Readers **€59–259** (or €0 with Tap to Pay). Online 1.5% + €0.25. |
| **Satispay** | **Not card rails** — bank-to-bank via wallet app | **0% under €10**, **0.95%** at €10+. No card hardware. Popular with IT bars/kiosks. |
| **Nexi SmartPOS Cassa+** | Italian incumbent all-in-one | ~**€29/month**, zero commission under €10. |

**What the provider charges *us* (the developer):**
- Position A: **€0** — SumUp Cloud API and Stripe Terminal SDK are free to integrate.
- Position B (Stripe Connect): managed model **€0** to us (possible partner
  revenue share); self-serve **€2/mo per active merchant + 0.25% + €0.10 per
  payout**, and we set our own markup.

### 1.4 Why a merchant picks Agora over SumUp's own free POS

We do **not** compete on payments. SumUp is a payments company; its POS app is a
thin **loss-leader** to keep merchants on its rails. We compete on the
**management software layer**, with payment demoted to a swappable peripheral.

- SumUp's job: *"accept a card."* Agora's job: *"run the venue."*
- The merchant who only needs "accept a card" is **not our customer** — and that's
  fine. Our customer outgrew SumUp's toy POS but won't pay €200/mo for a bloated
  RCH/Toast system.

Concrete reasons to switch (things SumUp's free app can't do):

1. **Offline-first** — festival-proven; SumUp degrades/dies without connectivity.
2. **Real hospitality workflow** — tables, tabs, coursing, floor map, kitchen
   display, multi-terminal shared queue.
3. **Italian fiscalization done right** — software RT + the 2026 POS↔RT link.
4. **Payment-agnostic / no lock-in** — SumUp *or* Stripe *or* Satispay *or* cash;
   keep your own acquirer deal. SumUp's POS only works with SumUp payments.
5. **Depth already built** — inventory, workforce/PIN, discounts, reporting.
6. **Simple, venue-shaped UX** (see `BUSINESS_PROFILES.md`).

Mental model: the customer taps on a SumUp Solo, but **the order, table, kitchen
ticket, fiscal receipt, inventory decrement and Z-report all happen in Agora.**
SumUp is reduced to a dumb terminal inside our experience.

---

## 2. Italian fiscal compliance

### 2.1 The obligation

Since 2021/2022, paper fiscal receipts are replaced by the electronic
*documento commerciale*: each sale must be **memorized and transmitted** to the
Agenzia delle Entrate (AdE). Historically this required a certified hardware
**Registratore Telematico (RT)**.

### 2.2 The 2026 game-changer — software RT (PEM/PEL)

From 2026 Italy allows a **software-based** certified RT as an alternative to
hardware. Architecture:

- **PEM (Punto di Emissione)** — *in our app*: collects sale data, applies the
  qualified digital signature, generates the *documento commerciale*.
- **PEL (Punto di Elaborazione)** — *run by a certified provider*: verifies
  integrity, transmits to AdE, handles legal preservation.

Described as *"la terza via, la più evoluta"* — full compliance **with no physical
RT hardware**. For a solo dev this is the unlock: **build the PEM in-app, integrate
a certified PEL API**. We ride the provider's certification (our PEM must still
conform to AdE technical specs).

Candidate certified PEL / *corrispettivi* API providers: **fiskaly** (explicitly
Italian software RT), **A-Cube**, **Openapi**, **effatta**.

### 2.3 The 2026 POS↔RT link obligation

- **Law:** Legge di Bilancio 2025 (**L. 207/2024, comma 74**), amending art. 2
  c.3 **D.Lgs 127/2015**; detailed by **Provvedimento AdE n. 424470 del
  31/10/2025**.
- **What:** from **1 Jan 2026**, every electronic payment must be traceable to the
  fiscal memorization of the receipt. It's a **logical** link (associate the RT
  serial with the POS's identifying data via the *Fatture e Corrispettivi* web
  area) — no cable.
- **Deadline:** register pairings active in Jan 2026 by **~20 April 2026** (45 days
  from service opening).
- **Penalties:** 90% of VAT due, **min €500/violation**; recidivism (4/5yrs) →
  activity suspension 15 days–2 months; undocumented revenue > €50k → closure up
  to 6 months.

**Why this favors Agora:** because our app owns *both* the payment orchestration
and the fiscal emission, mapping a card payment to its transmitted receipt (and
reconciling amounts) is automatic. Bundled competitors have to bolt this together.

### 2.4 "Less fiscal than SumUp" = fiscalization is OPT-IN

Fiscalization is a **capability the operator turns on only when legally required**,
not a permanent tax on every sale. Occasional/event sales (the festival tier) may
not need a full RT — ship those as a non-fiscal *gestionale* with a courtesy
receipt. Turn on the fiscal module when a bricks-and-mortar venue needs it. *(Verify
per-case with a commercialista — don't overstate the exemption.)*

---

## 3. Integration plan (Flutter)

### 3.1 SumUp — three paths

| Path | How | UX | Needs |
|---|---|---|---|
| **Reader SDK (Mobile SDK)** | Embed SumUp in the app; drives a Bluetooth reader (Air/Solo) or phone Tap to Pay. App calls `checkout(amount)` → SDK runs the flow → returns result. | Fully in-app | Native Android/iOS SDK — **no official Flutter plugin**; wrap via MethodChannel |
| **Cloud API** | App/backend sends HTTPS request with the amount to a **Solo** standalone reader; result via webhook. | Reader is separate device; no phone app needed | Solo reader + API keys (held by backend) |
| **Payment Switch (app-to-app)** | App opens the SumUp app passing the amount; SumUp processes; returns to our app. | Amount auto-filled but **jumps to SumUp app and back** | Least code; quickest to ship |

All three eliminate the manual amount-typing merchants do today.

### 3.2 Stripe Terminal — the cleanest Flutter path

SumUp ships **no official Flutter SDK**; Stripe Terminal has a mature community
plugin, **`mek_stripe_terminal`**, supporting **Tap to Pay** (phone-as-reader, no
hardware) and Bluetooth/smart readers, fully in-app. Flow:

1. Backend mints a **connection token** (keeps secret keys off the device).
2. App connects to a reader, or the phone's NFC via Tap to Pay.
3. App calls collect/process **with the amount** → customer taps → result in-app.
4. iOS Tap to Pay requires Apple's **"Tap to Pay on iPhone" entitlement**.

**Recommended starting point:** Stripe Terminal + Tap to Pay — lowest-friction
"tap-to-charge" on Flutter with zero extra hardware. Add SumUp (Cloud API + Solo)
as a second provider when a customer specifically asks for it.

### 3.3 The abstraction

Hide every provider behind one interface (a `payments` capability, gated per
`BUSINESS_PROFILES.md`):

```dart
abstract interface class PaymentProvider {
  Future<PaymentResult> charge({
    required Money amount,
    required String orderId,   // ties payment → order → fiscal receipt
  });
}

// StripeTerminalProvider, SumUpCloudProvider, SumUpSwitchProvider, …
```

The cashier hits **Charge** on the order → `charge(...)` → the reader lights up with
the amount pre-loaded → `PaymentResult` (with a transaction id) comes back and is
attached to the order and later to the fiscal document (satisfying the POS↔RT link).

### 3.4 Constraints to design around

- **Card payment is inherently online** (the acquirer authorizes in real time), so
  `payments` is a *paid/online* capability. In the offline festival tier, fall back
  to cash. Maps cleanly onto tier/profile gating.
- **Keep secrets off the device** — SumUp API keys / Stripe connection tokens are
  minted by a small backend endpoint, never hardcoded. This is the first concrete
  reason to stand up a backend, and only for this.

---

## 4. How it maps to the architecture

Two new capabilities in the `BUSINESS_PROFILES.md` scheme, gated by tier + profile:

| Capability | Meaning | Gating |
|---|---|---|
| `payments` | Accept card via a `PaymentProvider` | Paid + online; profile-dependent |
| `fiscalization` | PEM in-app + certified PEL provider | Opt-in; on when legally required |

Neither is hardcoded per business type — both are declarative capabilities the
onboarding preset (or the operator) toggles.

---

## 5. Recommended sequencing (solo dev)

1. **Festival/free tier stays non-fiscal** — courtesy receipt, cash, zero fees,
   zero payment integration.
2. **Paid tier** adds `payments` via **one** provider (Stripe Terminal + Tap to Pay)
   behind the `PaymentProvider` interface. Flat subscription; **no per-transaction
   cut** (Position A).
3. **Add `fiscalization`** (software RT via fiskaly/A-Cube) as an optional module
   for venues that need it; this also satisfies the POS↔RT link because we own both
   ends.
4. **Add a second `PaymentProvider`** (SumUp Cloud API + Solo) on customer demand.
5. **Revisit Position B (Connect markup)** only if/when payment revenue is wanted —
   knowing it dilutes the "no per-transaction cut" story.

Guardrails: don't become a PSP or hardware manufacturer; integrate certified
acquirers and certified PELs; keep PANs out of the app.

---

## Sources (retrieved mid-2026)

**Fiscal / regulation**
- Confcommercio — obbligo collegamento POS-RT: <https://www.confcommercio.it/-/obbligo-collegamento-pos-e-registratori-di-cassa>
- PMI.it — POS connesso alla cassa dal 2026, scadenza 20 aprile 2026: <https://www.pmi.it/impresa/contabilita-e-fisco/484139/obbligo-pos-connesso-alla-cassa-dal-2026-come-adeguarsi-evitando-sanzioni.html>
- Studio Vabri — obbligo interconnessione POS-RT, modalità operative: <https://www.studiovabri.com/2025/11/17/circ-25-2025-obbligo-interconnessione-pos-registratore-telematico-dal-01-01-2026-modalita-operative/>
- fiskaly — corrispettivi telematici senza hardware (software RT PEM/PEL): <https://www.fiskaly.com/it/blog/scadenza-rt-2026%E2%80%93comunicazione-corrispettivi-telematici-senza-hardware>
- Openapi — scontrino elettronico via API: <https://openapi.com/blog/tax-receipt-api>
- A-Cube — API corrispettivi elettronici: <https://www.acubeapi.com/prodotti/api-scontrino-elettronico-smart>

**Payments**
- SumUp Developer — In-Person Payments (SDKs / Cloud API / Switch): <https://developer.sumup.com/terminal-payments>
- SumUp Developer — Cloud API: <https://developer.sumup.com/terminal-payments/cloud-api>
- SumUp Developer — Solo reader: <https://developer.sumup.com/terminal-payments/readers/solo>
- SumUp — pricing & fees: <https://help.sumup.com/en-US/articles/4oI3qHHji2I2S9dyvRfec3-pricing-fees>
- Stripe — Italy pricing (Terminal, Tap to Pay, online): <https://stripe.com/it/pricing>
- Stripe Connect — platform pricing: <https://stripe.com/it/connect/pricing>
- Stripe — Tap to Pay (Terminal): <https://stripe.com/terminal/tap-to-pay>
- `mek_stripe_terminal` — Flutter plugin (Tap to Pay): <https://pub.dev/packages/mek_stripe_terminal>
- Satispay Business — costi: <https://www.satispay.com/it-it/business/costi/>

## Related docs
- `BUSINESS_PROFILES.md` — capability/tier gating; `payments` & `fiscalization` as capabilities.
- `ECOSYSTEM.md` — product lines, tiers, app list.
- `AI_INTEGRATION.md` — AI features and subscription gating.
