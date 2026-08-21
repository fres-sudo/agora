# SumUp card payments

## Scope

Agora integrates the SumUp Reader SDK 7.1 line directly in the existing
Android and iOS app shells (Android 7.1.0; iOS locked to the resolved 7.1.x
patch). The first release supports an attended card-reader checkout:

- operator login/logout and reader settings;
- one card charge for the order total;
- durable local payment attempts and SumUp transaction references;
- cash checkout unchanged;
- approved orders published to the LAN using the existing order event.

Refunds, tips, Tap to Pay, SumUp Cloud API/Solo, offline store-and-forward,
Payment Switch, and a generic multi-provider registry are explicitly outside
this release.

## Configuration

Create a SumUp affiliate key for every application identifier that will run the
SDK:

| Flavor | Application identifier |
|---|---|
| dev | `space.fres.agora.dev` |
| staging | `space.fres.agora.stg` |
| production | `space.fres.agora` |

Set the matching key in the untracked `config/<environment>.json` file:

```json
{
  "SUMUP_AFFILIATE_KEY": "sup_afk_..."
}
```

An empty key is safe: the SDK remains unconfigured, the card setting defaults
off, and checkout cannot initiate a card charge.

## Transaction lifecycle

1. Checkout verifies that SumUp is logged in and obtains the merchant currency.
2. Agora inserts the full order locally with `paymentPending` status and a
   unique `sumup-<order-sync-id>` attempt ID. It is not published or fulfilled.
3. The native SDK charges the exact minor-unit total using that attempt ID as
   SumUp's foreign transaction ID.
4. On approval, Agora stores the transaction code, marks the order completed,
   publishes it once, then runs stock, discount, kitchen-ticket, and receipt
   side effects.
5. Declined, cancelled, and known technical failures are retained as
   soft-deleted audit attempts. They never trigger fulfillment.
6. An ambiguous result remains visible in Orders as `Payment review`. Agora
   blocks another checkout for that order. The operator must compare the
   attempt ID with SumUp transaction history before taking any further payment.

Only `approved` is a fulfillment-authorizing result. A connection failure is
never treated as a decline, and a duplicate foreign transaction ID is treated
as ambiguous because the original charge may exist.

## Release validation

Before enabling card payments in production:

1. Confirm the affiliate key is registered for the exact production Android
   application ID and iOS bundle ID.
2. On physical Android and iOS devices, open Settings → Payment Method, log in,
   pair the intended reader, and enable Card.
3. Exercise approved, declined, operator-cancelled, reader-disconnected, and
   network-loss flows with SumUp test facilities or a controlled merchant.
4. Confirm only approved payments decrement stock, print kitchen tickets, and
   appear as completed sales on another LAN station.
5. Confirm an interrupted/ambiguous payment appears as `Payment review`, shows
   its attempt ID in order details, and cannot be charged again.
6. Confirm legacy cash orders and the cash checkout path remain unchanged.

Native builds require Android API 26+, Java 17, and iOS 16+. Both platform
builds must pass before shipping; SDK behavior still requires physical-device
testing because a simulator cannot validate reader pairing or real payments.
