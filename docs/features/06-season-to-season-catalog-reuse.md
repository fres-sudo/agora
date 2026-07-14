# Feature 6 — Season-to-season catalog/pricing reuse

> Priority #6. A *pro-loco* runs largely the same menu every year — restoring
> last year's catalog should be one tap, not manual re-entry of every
> product, price, and modifier.

## Description

Let an operator save the current product catalog (categories, products,
prices, modifier groups) as a named template, and restore a saved template
into a fresh/empty catalog at the start of a new season.

## Why

Manual re-entry of a full sagra menu every year is exactly the kind of
tedious setup work that pushes a volunteer treasurer back toward "just keep
using the old Windows tool" — this is low engineering effort for high
retention value.

## What's in scope

- **Save**: snapshot the current catalog (categories, products incl. price/
  cost/tax, modifier groups + options) into a named, stored template.
- **Restore**: recreate categories/products/modifiers from a saved template
  into the live catalog — additive (doesn't delete what's already there) or
  replace-all (clears first) — pick one clearly, see the open question
  below.
- Multiple named templates (not just "last save wins") so an operator
  running more than one type of event can keep separate menus.

**Out of scope for v1:** cross-device transfer (e.g. exporting a template as
a file to email to another organiser's tablet) — see the stretch goal at
the end. Stock levels are explicitly **not** part of a template — a
template is a menu/pricing definition, not a stock snapshot (stock resets
fresh each season regardless).

## Where

Confirmed by reading the code: **no mechanism for this exists at all**, and
one specific blocker needs fixing first:

- `packages/database/lib/src/seeder/data_seeder.dart` — the only
  catalog-bulk-insert code that exists today — is **onboarding-only**: it
  seeds one of four hardcoded `StarterCatalog` enum values
  (`restaurant`/`barCafe`/`quickService`/`festival`) from compile-time
  constant lists baked into the Dart source, and no-ops if any category
  already exists (`_categoriesFor`/`_productsFor`, lines 111/143). It is
  not a general "insert this arbitrary catalog" engine, though its
  category→product→transaction insertion *shape* is a reasonable pattern to
  follow for the restore path.
- **Blocker: JSON serialization is explicitly disabled** on every catalog
  domain model. `packages/catalog/lib/models/product.freezed.dart`,
  `category.freezed.dart`, `modifier_group.freezed.dart`,
  `modifier_option.freezed.dart` all carry
  `@JsonKey(includeFromJson: false, includeToJson: false)` — there is no
  `toJson`/`fromJson` today. Any snapshot format needs this added (or a
  hand-written mapper that doesn't rely on freezed's JSON codegen at all —
  simpler to just enable it, see Step 1).
- No export/import/backup code exists anywhere in `features/products` or
  `features/settings` (confirmed by grep). The only related UI is
  `danger_zone_section.dart` in `features/settings` — a one-way destructive
  "reset everything" button with no save-before-wipe step; this feature is
  effectively the missing "save before you wipe" counterpart, though it's
  framed as season rollover, not disaster recovery.
- Given catalog data already lives in `packages/catalog` (shared by
  `feature_products`/`feature_pos`/`feature_settings`/`feature_reports`),
  and a template is catalog data, the template model/repository interface
  belongs there too, following the established pattern. The concrete
  storage (new Drift table) and the save/restore UI belong in
  `features/settings` (a natural sibling of `danger_zone_section.dart`) or
  `features/products` — recommend **`features/settings`**, since "manage my
  catalog templates" reads as an admin/setup action, same category as
  store info and the danger zone.

## How

### Step 1 — Enable JSON on the catalog models (or write hand-rolled mappers)

- Simplest path: remove the `@JsonKey(includeFromJson: false,
  includeToJson: false)` annotations from `Product`, `Category`,
  `ModifierGroup`, `ModifierOption` in `packages/catalog/lib/models/`, add
  `@JsonSerializable`/`part '*.g.dart'` per the project's existing
  freezed+json_serializable convention (used elsewhere per `CLAUDE.md`'s
  codegen table), and run `build_runner` for `packages/catalog`.
- **Before doing this, find out why JSON was disabled** — it may have been
  deliberate (e.g. avoiding accidental serialization of a model that
  shouldn't cross a wire boundary) rather than an oversight. Check git
  blame/history on those annotations. If there's a real reason, prefer
  hand-written `toJson`/`fromMap` helpers scoped to this feature only,
  rather than flipping a repo-wide flag with unknown side effects.

### Step 2 — Template storage: in-app, not file-based, for v1

Given the product is offline-first with no cloud and no guaranteed file-
sharing UX on every target device, the simplest reliable mechanism is a
**local snapshot table**, not a file export:

```
CatalogTemplatesTable (+TableMixin):
  name          text
  snapshotJson  text   -- serialized {categories, products, modifierGroups}
                            using the models from Step 1, ids stripped/remapped
                            on restore
  savedAt       (from TableMixin.createdAt)
```
One JSON blob per template is deliberately simple — this data is small
(a sagra menu is dozens of items, not thousands) and avoids designing a
full relational snapshot schema (template-categories, template-products,
etc.) for no real benefit at this scale.

### Step 3 — Save flow

- New `CatalogTemplatesRepository` (interface in `packages/catalog`, impl +
  DAO in `features/settings` or `features/products` — match wherever the
  UI ends up living, per the "Where" recommendation above).
- `saveCurrentAsTemplate(String name)`: read all current categories (via
  the existing `CategoriesRepository`), products (`ProductsRepository`,
  excluding `stockQuantity` — not part of a template per scope), modifier
  groups (`ModifiersRepository`); serialize to the JSON shape from Step 2;
  insert one `CatalogTemplatesTable` row.

### Step 4 — Restore flow

- `restoreTemplate(String templateId, {required bool replaceExisting})`:
  deserialize the snapshot; for each category/product/modifier group,
  insert as new rows (fresh ids — a restored catalog is not "the same rows
  reactivated," it's new data seeded from a saved shape, avoiding stale-id
  collisions with anything created since the snapshot was taken).
- If `replaceExisting`, soft-delete (existing `TableMixin.deletedAt`
  pattern — already used repo-wide, e.g. modifier soft-delete/restore in
  `modifiers_dao.dart`) current categories/products first, inside the same
  transaction, mirroring `DataSeeder`'s existing `db.transaction` pattern
  for the insert half.
- Wrap the whole restore in one transaction — a partial restore (some
  products inserted, then a failure) is worse than not restoring at all.

### Step 5 — UI

- New **Settings → Catalog Templates** section (sibling to
  `danger_zone_section.dart`): list of saved templates (name + saved date),
  "Save current catalog as template" action (name prompt), "Restore" action
  per template with a clear choice between "add to current catalog" and
  "replace current catalog" (see open question), and delete-template.

## Acceptance criteria

- Saving the current catalog, then wiping it (danger zone) or starting a
  fresh install, then restoring the saved template recreates all
  categories/products/prices/modifier groups correctly.
- Restoring never touches stock levels — a restored product starts with
  whatever stock behavior a newly-created product normally gets (0/untracked,
  per existing `Product` defaults), not the stock level from when the
  template was saved.
- A restore failure partway through leaves the catalog exactly as it was
  before the restore attempt (transactional).

## Open questions

- **Replace vs. merge on restore** — should restoring a template always
  replace the current catalog, always merge/add, or let the operator choose
  each time (as drafted above)? A treasurer starting a brand-new season
  with an empty catalog probably wants "restore = replace," but "merge"
  matters if they've already started customizing this season's menu before
  remembering the template exists. Recommend keeping the choice explicit at
  restore time rather than guessing.
- **Stretch goal, not v1**: export a template as a shareable file (JSON,
  once Step 1 lands this is nearly free) so one *pro-loco* volunteer can
  hand their catalog to another association's device without both needing
  to have used the same tablet historically. Worth revisiting once the
  in-app version ships and there's real demand signal for cross-device
  sharing.
