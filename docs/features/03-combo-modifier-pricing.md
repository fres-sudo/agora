# Feature 3 — Combo/modifier pricing

> Priority #3. The classic sagra combo: panino + patatine + bibita for one
> fixed price, cheaper than the sum of the parts.

## Description

Let an operator define a bundle of specific products (e.g. one panino, one
patatine, one bibita) sold together as a single cart line at one price,
distinct from today's per-product modifier system.

## Why

Sagra menus are built around combos — it's how the till moves fast and how
pricing is communicated on the board. Today Agora has no way to represent
"these three things together cost €8" — only "this one product plus a
priced option."

## What's in scope

- Define a combo: a fixed set of products (with quantities), a combo price
  (either a flat override price, or a discount off the sum — flat price is
  simpler and matches how sagre price boards actually read: "Menu Completo
  €10", not "10% off").
- Add a combo to the cart as one line; it prints/appears as one line with a
  sub-breakdown of its contents (for the kitchen ticket — see feature 2 —
  and the receipt).
- Stock decrements for **each constituent product** when a combo sells (a
  combo isn't a separate stock-tracked SKU; it consumes its parts).

**Out of scope:** combos with substitutable/optional items ("choose one of
3 drinks") — v1 is fixed-contents only, matching the stated priority
("panino+patatine+bibita **style**"). Optional-item combos can be a later
iteration once the fixed version is proven.

## Where

Confirmed by reading the code: the existing modifier system **cannot**
represent this and shouldn't be stretched to try.

- `ModifierGroup`/`ModifierOption` (`packages/catalog/lib/models/`) are
  scoped to **one product's own price** — `ModifierOption.priceChangeCents`
  is a delta applied to that single product
  (`packages/order_management/lib/blocs/active_order/active_order_bloc.dart`
  line ~290 sums `mod.priceChangeCents * item.quantity` onto one product's
  `unitPriceCents`). There is no schema or model concept of a line
  referencing more than one `Product.id`.
- `ProductModifierLinksTable`
  (`packages/database/lib/src/tables/modifiers_table.dart:26-37`) links one
  modifier group to many products it *can* attach to — that's the opposite
  relationship from what a combo needs (many distinct products consumed
  together as one sellable unit).
- **This is a new concept**, not an extension. Following the established
  shared-domain-package pattern (`packages/catalog` holds `Product`,
  `packages/order_management` holds `Order`/`OrderLineItem`, both consumed
  by `feature_pos`/`feature_orders`/`feature_reports`/`feature_settings`
  without those features importing each other): a combo needs to be visible
  to the same set of consumers, so it belongs in **`packages/catalog`**
  alongside `Product` — a `Combo` is catalog data, not order data. The
  order-time representation (a cart line referencing a combo) extends
  `packages/order_management`.

## How

### Step 1 — Schema

New tables in `packages/database/lib/src/tables/`:
```
CombosTable        (+TableMixin): name, priceCents (flat override), isEnabled
ComboItemsTable     (+TableMixin): comboId (FK→Combos), productId (FK→Products), quantity
```
`ComboItemsTable` is the many-to-many with a quantity, deliberately separate
from `ProductModifierLinksTable` since the relationship semantics differ
(consumption, not attachment). Bump `schemaVersion` with a migration, same
process as feature 2's schema step — if both features ship close together,
combine into one schema-version bump rather than two.

### Step 2 — Domain model (`packages/catalog`)

```dart
@freezed
class Combo with _$Combo {
  const factory Combo({
    required String id,
    required String name,
    required int priceCents,
    required bool isEnabled,
    required List<ComboItem> items,
  }) = _Combo;
}

@freezed
class ComboItem with _$ComboItem {
  const factory ComboItem({
    required String productId,
    required String productName, // denormalized for display without a join
    required int quantity,
  }) = _ComboItem;
}
```
Mirror `ModifierGroup`/`ModifierOption`'s existing mapper pattern
(`features/products/lib/domain/mappers/modifier_mapper.dart`) for
`CombosDao`/`CombosRepositoryImpl` → note per the current pattern, the DAO
and concrete repository impl live in `features/products` (which already
`export`s `package:catalog/catalog.dart` and owns the concrete data layer
for everything catalog-shaped), while the abstract `CombosRepository`
interface and shared `CombosBloc` live in `packages/catalog` itself.

### Step 3 — Cart representation

- `OrderLineItem` (`packages/order_management/lib/models/order_line_item.dart:7-23`)
  currently always references one `productId`. Add a nullable `comboId` +
  keep `productId` null for combo lines; the line's `unitPriceCents` becomes
  the combo's flat price directly (no modifier-delta math needed for v1
  since combos don't support modifiers on top).
- `OrderItemsTable`/`order_items_table.dart` needs the same nullable
  `comboId` column, and — since order items snapshot data at sale time
  (`productName`, `unitPrice` are already snapshots, not FKs alone) — also
  snapshot the combo's constituent breakdown as JSON (for receipt/ticket
  rendering after the fact, independent of whether the combo definition
  later changes). This matches the project's existing snapshot convention,
  don't invent a new one.
- `active_order_bloc.dart`'s `_onItemAdded` needs a new `comboAdded`-style
  event (or a unified "addable" abstraction over `Product`/`Combo` — prefer
  the smallest change: a parallel event, not a generic refactor of the
  existing product path, to avoid destabilizing the already-working
  per-product cart math).

### Step 4 — Stock decrement

- `CheckoutCubit.confirm()`'s stock-decrement step (wherever
  `InventoryRepository.decrementForOrder` is invoked — check current
  wiring in `packages/order_management`'s checkout flow) must, for a combo
  line, decrement **each constituent product** by
  `comboItem.quantity * lineQuantity`, not decrement anything against a
  `comboId` (combos are never stock-tracked themselves).

### Step 5 — UI

- **Settings → Combos** management section (new, same shape as
  `modifier_section.dart`/`modifier_form.dart`): pick N products + quantity
  each, set the flat price, name it ("Menu Completo").
- **POS grid**: combos appear alongside products (likely as a distinct
  visual chip/badge so the cashier can tell a combo tile from a product
  tile at a glance) — tapping adds the combo line directly (no modifier
  picker sheet, since v1 combos have fixed contents).
- **Receipt/ticket**: combo line prints as one priced line with its
  contents indented underneath (using the snapshot from Step 3), so the
  kitchen (feature 2) still knows to make one panino + one patatine + one
  bibita from that single line.

## Acceptance criteria

- Creating a combo of 3 existing products with a flat price, adding it to a
  cart, and completing checkout: one line item at the combo price, all 3
  constituent products' stock decrements correctly, and the receipt/ticket
  shows the breakdown.
- Combos never appear as a stock-tracked item themselves — disabling or
  deleting a combo doesn't touch product stock.

## Dependencies

- None hard-blocking. Combo receipt printing reuses whatever
  `packages/printing` already supports for multi-line receipts (already
  built). Kitchen ticket breakdown (feature 2) should read the same
  snapshot JSON from Step 3 once it exists, but combo pricing doesn't need
  to wait on feature 2 to ship.
