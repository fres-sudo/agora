# Festival POS — Task Management Plan

> **App:** `apps/agora` (this *is* the Festival POS — the free/open-source POS for Italian sagre & fiere described in `README.md`).
> **Goal of this plan:** take the current codebase to a **shippable, fully-offline free-tier POS**, then prepare clean seams for the paid/cloud tier once the backend exists.
> **Architecture decision (confirmed):** keep the existing Melos feature-based architecture (`apps/agora` composes `features/*`). There is no separate standalone `apps/festival_pos` — `apps/agora` *is* the sagra/festival POS. `docs/architecture/ECOSYSTEM.md` / `ARCHITECTURE.md` were updated 2026-07-14 to reflect this; see [Appendix C](#appendix-c--doc-vs-reality-discrepancies) for the remaining (unrelated) doc-drift items.

---

## How to read this document

- Tasks are grouped into **Phases** (delivery order) and **Categories** (domain).
- Each task has: a unique ID, affected files, a short description, **acceptance criteria**, and **dependencies**.
- `[ ]` = not started. Tick as you go.
- **Effort** is a rough t-shirt size (S ≤ half day, M ≈ 1–2 days, L ≈ 3–5 days) — calibrate to your pace.
- Code-generation reminder: after touching Drift tables, `@freezed` models, DTOs, routes, or i18n, run `melos run build` (or per-package `build_runner`). Generated files (`.g.dart`, `.freezed.dart`, `.gr.dart`) are committed.

### Status legend used in "Current state" notes
- ✅ **Done** — real, working logic.
- 🟡 **Partial** — exists but incomplete / not wired.
- 🔴 **Missing** — does not exist.
- 💀 **Dead code** — exists but never provided/used.

---

## Executive summary — where the app stands today

The **data + domain + bloc layers are largely real**; the **presentation/wiring layer has the holes**. A recurring pattern: capable repositories and cubits exist but are never registered or never called.

| Capability | State | One-line gap |
|---|---|---|
| Product / category catalog | 🟡 | CRUD + persistence work; modifiers & ingredients collected in the form but **never saved**; `Product.modifierGroups` never populated. |
| Cart building | ✅ | Add/remove/qty/totals work in memory. |
| **Checkout / payment** | 🔴 | No payment screen, no cash/change, `paymentMethod` always `null`. |
| **Order completion** | 🔴 | Orders persist as `pending` and are **never marked completed** through any UI → breaks revenue reporting. |
| **Stock decrement on sale** | 🔴 | `decrementForOrder()` exists but is **never called**. |
| **Receipt / thermal printing** | 🔴 | No package, no domain, no UI. Settings → Receipt/Printer are placeholders. |
| **End-of-day report** | 🔴 | `ReportPage` is **100% hardcoded mock data**; real `OrdersRepository` aggregation queries exist but are unused. |
| Tax | 🟡 | Cart hardcodes tax `0`; Settings → Taxes is a placeholder. |
| Settings | 🟡 | Data layer (cubit/repo/DAO) is solid; only the **Category** section is wired. 6/8 sections are "coming soon". Store form not wired. |
| Discounts | 🟡 | Repo + bloc real; **no UI** anywhere; checkout discount button is commented out. |
| Auth / operator login | 🟡 → ❌ removed | `SessionCubit`/`AuthRepository` are empty stubs. **DECIDED: free tier has no auth/login/operator at all** — strip it (P7-5/P7-6). |
| Inventory management | 🟡 | Repo + bloc + adjust-cubit are real, but there's **no page** and the nav item is disabled. In scope ("very basic") — build the page (P7-8). |
| LAN sync hub | 🔴 | No `sync_hub/`. `sync_engine` package is real and ready to wire later. |

> **Critical-path to "an operator can take money and hand over a receipt":**
> `Cart → Checkout/Payment → Mark Completed → Decrement Stock → Print Receipt`.
> Phase 1 below delivers exactly this.

---

## Phase overview

| Phase | Theme | Outcome |
|---|---|---|
| **Phase 0** | Stabilise & verify | ✅ *Mostly done* — builds/generates/lints clean; web build green; test baseline recorded. P0-4 (DB double-open) deferred. |
| **Phase 1** | Checkout core (critical path) | An order can be paid, completed, stock-decremented. |
| **Phase 2** | Receipt & thermal printing | A physical/preview receipt via the new `packages/printing` abstraction. |
| **Phase 3** | Catalog completeness | Products with modifiers/ingredients fully manageable. |
| **Phase 4** | Settings & configuration | Tax, currency, store info, payment methods, printer config persist & drive behaviour. |
| **Phase 5** | End-of-day reporting | Real sales summary / Z-report from local data. |
| **Phase 6** | Discounts UX | Apply discounts at checkout; manage them. |
| **Phase 7** | Polish, UX, i18n, errors | Remove auth (no-login standalone), add inventory page, shippable quality. |
| **Phase 8** | Testing & release | Confidence + buildable artifacts. |
| **Phase 9** | LAN sync hub wiring (DEFERRED) | Local multi-station sync seams; placeholder until the sync hub spec lands. |

---

# Phase 0 — Stabilise & verify the baseline

**Why first:** the repo was recently migrated to a monorepo (`NEXT_STEPS.md`). Confirm it actually builds and tests pass before changing anything.

- [x] **P0-1 — Bootstrap & generate** · _Effort: S_
  - Run `melos bootstrap`, then `melos run build`.
  - **Acceptance:** all packages resolve; no missing `.g.dart`/`.freezed.dart`/`.gr.dart`; `melos run lint` is clean (or known-issues logged).
  - **Deps:** none.
  - ✅ **Done.** `fvm dart run melos bootstrap` → SUCCESS (25 packages). `fvm dart run melos run build --no-select` → SUCCESS (all codegen). `fvm dart run melos run lint` → SUCCESS, "No issues found!" in every package.
    - **Toolchain note:** FVM was not installed and there was no cached `3.38.5` SDK. Installed via `brew install fvm` + `fvm install 3.38.5` + `fvm use 3.38.5` (which created the `.fvm/flutter_sdk` symlink that Melos requires and wrote `.fvmrc`).
    - **Melos note:** the globally-activated Melos hit a kernel-version mismatch with Dart 3.10.4; running Melos via `fvm dart run melos …` avoids it. Scripts need `--no-select` to run non-interactively.
    - **Known issue (resolved):** `packages/sync_engine` lint initially failed because `test/sync_manager_test.mocks.dart` (Mockito `@GenerateMocks`) was not generated on the first build pass. Running `fvm dart run build_runner build` directly inside `packages/sync_engine` generated it; lint then clean.

- [x] **P0-2 — Run the app end-to-end** · _Effort: S_
  - `cd apps/agora && fvm flutter run`. Seeded Italian menu (Primi/Secondi/etc.) should appear in POS.
  - **Acceptance:** app launches to the POS shell; products render; can add to cart.
  - **Deps:** P0-1.
  - ✅ **Done (verified via build).** `cd apps/agora && fvm flutter build web` → `✓ Built build/web` (full `lib/main.dart` compile, ~77s), proving the whole app + provider/route/feature graph assembles and is launchable. The interactive "tap to add to cart" GUI flow was not driven from the headless shell, but the cart-add logic is covered by the existing root tests.
  - **Build-blocking bug found:** `apps/agora/pubspec.yaml` had a duplicate `path:` mapping key under `feature_auth` (the 2nd `path:` pointed at `features/discounts`), which the stricter build-pipeline YAML parser rejected. (Fixed externally during this session — see session notes; `feature_auth` and `feature_discounts` are now separate entries.)
  - **Platforms note:** the app ships `android`, `ios`, `web` only (no `macos`), so the macOS desktop device cannot be targeted without `flutter create --platforms=macos`.

- [x] **P0-3 — Run existing test suite** · _Effort: S_
  - `melos run test`. Tests currently live at repo-root `test/` (mirrors features): `test/pos/`, `test/orders/`, `test/products/`, `test/inventory/`, `test/settings/`.
  - **Acceptance:** record pass/fail baseline. File issues for any red tests; do not fix yet unless trivial.
  - **Deps:** P0-1.
  - ✅ **Done — baseline recorded (no fixes applied):**
    - `packages/bloc` (`bloc_exports`): **17 / 17 pass.**
    - `packages/sync_engine`: **11 / 12 pass** — 1 fail: `start() emits SyncPaused when offline — does not drain` (`sync_manager_test.dart:68`). Cause: test reads `statuses.last` without a microtask flush after `start()` (the test above it does `await Future.delayed(Duration.zero)`); a trivial test-only fix, deferred per "don't fix yet".
    - Repo-root `test/` (features, run via `fvm flutter test`): **61 / 76 pass, 15 fail.** Note: `melos run test` does **not** cover these (the root `test/` belongs to the `agora_workspace` root package, which isn't in Melos's `apps/**`/`features/**`/`packages/**` globs).
    - **15 root failures, by cause:**
      - **9 — real bug:** `ModifiersBloc` / `ProductsBloc` / `ProductDetailCubit` call `emit()` from inside a stream-subscription callback after the event handler already completed → `bloc 9.x` asserts `!_isCompleted` ("emit was called after an event handler completed normally"). Needs the `emit.forEach`/`onEach` pattern. (e.g. `modifiers_bloc.dart:49-53`.)
      - **3 — widget test infra:** `pos_page_test.dart` throws in `setUpAll`/pump via an image-codec exception (asset/network image in the test environment).
      - **2 — outdated assertions:** `active_order_bloc_test.dart` expects a `submitted` / empty-cart `error` state that the bloc does not emit (matches the audit's P1-7 finding that the submit success state is never produced).

- [ ] **P0-4 — Fix the DB double-open in bootstrap** · _Effort: S_ — ⏸️ **DEFERRED (not done).**
  - `apps/agora/lib/main.dart:29-31` opens a `AgoraDatabase`, seeds, then `db.close()`. `apps/agora/lib/app/app_providers.dart:67-70` opens a **second** instance for the app. Both use `K.dbName` (same file) so it works, but it's wasteful/confusing.
  - Either: (a) seed inside the provider-owned DB via a one-shot init, or (b) keep the pattern but document it. Recommended: move seeding to run against the single app-owned DB after providers initialise, or expose a `DatabaseInitializer`.
  - **Acceptance:** exactly one long-lived `AgoraDatabase` instance owns the app session; seeding still runs once and is idempotent.
  - **Deps:** P0-2.
  - ⏸️ **Deferred on purpose:** `main.dart` and `app_providers.dart` were being modified concurrently in this session (new `config` / `feature_flags` packages, `flavorizr`). Skipped the code edit to avoid clobbering those changes; revisit once the tree settles. The double-open is confirmed still present.

- [x] **P0-5 — Document the build/run loop in CONTRIBUTING** · _Effort: S_
  - Capture the exact commands that worked (FVM + melos). Keeps onboarding fast.
  - **Acceptance:** `CONTRIBUTING.md` has a verified "run the festival POS" section.
  - **Deps:** P0-2.
  - ✅ **Done.** Added a "Verified build & run loop (festival POS)" section to `CONTRIBUTING.md` with the exact working command sequence (FVM install/use, `fvm dart run melos …`, `--no-select`, the per-package `build_runner` gotcha, root-`test/` note, and `flutter build web` smoke test).

---

# Phase 1 — Checkout core (CRITICAL PATH)

**Goal:** turn "build a cart" into "take payment, finalise the sale, reduce stock." This is the single most important phase — without it the app cannot actually sell anything.

## Category 1A — Order data model & lifecycle

- [ ] **P1-1 — Add `orderType` to the order domain + schema** · _Effort: M_
  - Today `OrderType { dineIn, takeAway }` lives **inside** `features/pos/.../pos_order_type_selector.dart` (a feature-private enum) and the selected type is **local UI state only** — never persisted. `OrdersTable` has no order-type column.
  - **Files:**
    - `packages/database/lib/src/tables/orders_table.dart` — add `orderType` (Int, default 0) or reuse `note`. Prefer a real column.
    - `features/orders/lib/domain/models/order.dart` — add `orderType` field.
    - Move the `OrderType` enum to a shared location both `pos` and `orders` can use **without violating `features ↛ features`**. Recommended: put it in `packages/ui_kit` (already referenced for `OrderType` in the audit) **or** in `features/orders` domain and have `pos` depend on `orders` (allowed — `pos` already imports `orders`).
    - `features/orders/lib/data/repositories/orders_repository_impl.dart` — map the new column.
  - **Acceptance:** order type is chosen in POS, persisted, and read back on the order.
  - **Deps:** P0-1. Bump schema version + migration (see P1-9).

- [ ] **P1-2 — Capture `paymentMethod` on the order** · _Effort: S_
  - `orders_repository_impl.dart:77` hardcodes `paymentMethod: null`. The DB column exists (`OrdersTable.paymentMethod`, free text).
  - **Files:** `features/orders/lib/data/repositories/orders_repository_impl.dart`, `features/orders/lib/domain/models/order.dart` (add `paymentMethod` field), the active-order/checkout flow.
  - **Acceptance:** the selected payment method (Cash / Card / …) is written to the order row.
  - **Deps:** P1-5 (payment UI provides the value).

- [ ] **P1-3 — Mark orders `completed` on successful checkout** · _Effort: M_
  - **Core bug:** `ActiveOrderBloc._onSubmitted` (`active_order_bloc.dart:160-194`) calls `createOrder(currentOrder)` where `_buildOrder()` sets `status: OrderStatus.pending` (`active_order_bloc.dart:248`). Nothing ever calls `completeOrder`. `OrdersRepository.completeOrder(int)` and `OrderDetailCubit.complete()` exist but are unused/💀.
  - Decide the model: **complete-on-payment** (recommended for festival speed) — the order is created already `completed` once payment is confirmed, OR create `pending` then immediately `completeOrder(id)`.
  - **Files:** `features/orders/lib/presentation/blocs/active_order/active_order_bloc.dart` (and/or a new checkout cubit, see P1-5).
  - **Acceptance:** a paid order has `status == completed` in the DB; pending orders only exist if explicitly parked/held.
  - **Deps:** P1-5.

- [ ] **P1-4 — Decrement stock when a sale completes** · _Effort: M_
  - `InventoryRepository.decrementForOrder(...)` is fully implemented but **never called** (confirmed repo-wide). Stock never drops on a sale. (`restoreForVoidedOrder` IS called on delete of a completed order in `OrdersBloc._onDeleted`, but not on void.)
  - Wire decrement into the checkout completion path. Respect `Product.trackStock` / `ProductsTable.trackStock` — do not decrement untracked items.
  - **Files:** checkout flow (P1-5) or `ActiveOrderBloc`; needs an `InventoryRepository` dependency injected. Cross-feature dependency `orders → inventory` is already used (`OrdersBloc` reads `InventoryRepository`), so this is consistent.
  - **Acceptance:** completing an order reduces `StocksTable.quantity` for tracked products and records a `StockMovementsTable` row with reason `"Sale #<id>"`. Voiding restores it.
  - **Deps:** P1-3.

## Category 1B — Checkout & payment UI

- [ ] **P1-5 — Build the checkout / payment flow** · _Effort: L_
  - Replace the current no-op "Process Transaction" (which just fires `submitted` and shows a snackbar) with a real checkout step.
  - **Recommended UI:** an `AdaptiveSheet` (exists in `ui_kit`, renders bottom-sheet on mobile / side-sheet on tablet) containing: order summary, payment-method selector (Cash / Card), amount-tendered entry for cash, and **live change calculation**.
  - **New widget needed:** a numeric keypad / money entry — **none exists in `ui_kit`** (confirmed). Build `MoneyKeypad` + a cents↔display formatter (see P1-6) and consider promoting both to `ui_kit`.
  - Suggested new code (feature_pos or feature_orders presentation):
    - `CheckoutCubit` (or extend `ActiveOrderBloc`) orchestrating: validate cart → take payment → create+complete order → decrement stock → emit "print receipt" effect.
    - `CheckoutSheet`, `PaymentMethodSelector`, `CashTenderPad`, `ChangeDueDisplay`.
  - **Files:** `features/pos/lib/presentation/...`, `features/orders/lib/presentation/...`, `packages/ui_kit/...` (keypad/money input if promoted).
  - **Acceptance:** operator taps Charge → picks Cash → enters tendered → sees change → confirms → order is completed, stock decremented, success shown, cart cleared. Card path records method without tendered/change.
  - **Deps:** P1-2, P1-3, P1-4, P1-6.

- [ ] **P1-6 — Add a shared currency/cents formatter** · _Effort: S_
  - All money is integer **cents** everywhere; there is **no shared formatter** (only a private `_formatCurrency` in `features/orders`). Currency symbol should come from settings (see P4-2) and default to `€`.
  - **Files:** new `packages/utils/lib/src/money.dart` (or `ui_kit`) exposing e.g. `formatCents(int cents, {String symbol = '€'})` and a parse helper for keypad input.
  - **Acceptance:** one formatter used by POS, cart, checkout, receipt, reports. Handles `€` and locale decimal separator.
  - **Deps:** none (can land early).

- [ ] **P1-7 — Fix the POS submit confirmation listener** · _Effort: S_
  - `pos_page.dart:82-114` uses `BlocListener<ActiveOrderBloc, ActiveOrderState>` matching `state.submitted`. But the bloc emits the `ActiveOrderSubmitted` **effect** and sets state to `empty()` on success — it **never** emits a `submitted` state. So the success snackbar + the listener's `cleared()` dispatch **never run**. (The bloc extends `EffectBloc`; effects are on `bloc.effects`.)
  - Switch the listener to consume the effect stream (`ActiveOrderSubmitted` / `ActiveOrderShowError`), or have the new `CheckoutCubit` own success/error effects.
  - **Files:** `features/pos/lib/presentation/pages/pos_page.dart`.
  - **Acceptance:** on a successful sale the confirmation actually shows and the cart clears via the intended path; errors surface too.
  - **Deps:** P1-5 (ideally fold into the new checkout flow).

- [ ] **P1-8 — Wire mobile "Add Product" empty action** · _Effort: S_
  - `pos_page.dart:422-423` mobile empty state has `// TODO: Navigate to add product` (no-op). Tablet already opens `ProductFormWrapper.showCreate`.
  - **Files:** `features/pos/lib/presentation/pages/pos_page.dart`.
  - **Acceptance:** mobile empty state opens the product create form, matching tablet.
  - **Deps:** none.

## Category 1C — Schema migration hygiene

- [ ] **P1-9 — Introduce Drift migrations (schema is at v1, `createAll` only)** · _Effort: M_
  - `packages/database/lib/src/database.dart` has `schemaVersion => 1` and `onCreate: createAll()` with **no `onUpgrade`**. Any column added in P1-1/P1-2 (or later phases) will break existing installs without a migration step.
  - Add a `MigrationStrategy` with `onUpgrade` step migrations; bump `schemaVersion`. Consider `drift_dev`'s schema-version export/verification.
  - **Files:** `packages/database/lib/src/database.dart` (+ optional `drift_schemas/`).
  - **Acceptance:** upgrading from a v1 DB to the new version preserves data; a migration test passes.
  - **Deps:** any task that alters tables (P1-1, P1-2, plus Phase 3/4 schema changes).

---

# Phase 2 — Receipt & thermal printing

**Goal:** produce a receipt — the headline free-tier feature (`README` Roadmap: "Receipt printing (ESC/POS thermal printers)"). Nothing printer-related exists today (no package, no domain, no UI).

> **DECIDED — `packages/printing` abstraction is required.** Features depend **only** on our abstraction (`PrinterService` / `ReceiptRenderer`), never on the third-party packages directly. This keeps `features/*` decoupled and lets us swap the underlying packages later.
>
> **DECIDED — package choices** (most popular, maintained, BSD-3, both support Bluetooth + USB per free-tier scope):
> - **Renderer (ESC/POS command generation + ticket layout):** [`esc_pos_utils_plus`](https://pub.dev/packages/esc_pos_utils_plus) (~38k downloads, maintained fork of the classic `esc_pos_utils`).
> - **Transport (device discovery + send over Bluetooth/BLE + USB + Network):** [`flutter_thermal_printer`](https://pub.dev/packages/flutter_thermal_printer) (most-liked maintained transport, updated recently, Android/iOS/macOS/Windows).
> - Both third-party deps live **only** inside `packages/printing`. Pin exact versions in its pubspec.

- [ ] **P2-1 — Create the `packages/printing` abstraction package** · _Effort: M_
  - New shared package `packages/printing` (pubspec `name: printing`, `publish_to: none`). It is the **only** place that imports `esc_pos_utils_plus` and `flutter_thermal_printer`.
  - Public API (keep it minimal & framework-light, mirroring other packages):
    - `abstract interface class PrinterService` — `Future<List<PrinterDevice>> discover()`, `Future<Result<void>> connect(PrinterDevice)`, `Future<Result<void>> printBytes(List<int> escPos)`, `Future<Result<void>> disconnect()`, `Stream<PrinterConnectionStatus> status`.
    - `PrinterDevice` (id, name, connection type: bluetooth/ble/usb/network), `PrinterConnectionType` enum, `PrinterConnectionStatus`.
    - A concrete `ThermalPrinterServiceImpl` backed by `flutter_thermal_printer`.
    - A `FakePrinterService` (for tests/preview, no hardware).
    - A `printing_provider.dart` exposing a `SingleChildWidget` provider (pattern matches `sync_engine`/feature registration).
  - Return types use `package:result` (`Result<T>`) + `package:errors`; log via `package:logger` (Talker). No dependency on any `features/*`.
  - **Files:** new `packages/printing/pubspec.yaml`, `packages/printing/lib/printing.dart` (barrel) + `lib/src/...`. Add to `melos.yaml` workspace if needed (glob `packages/**` already covers it).
  - **Acceptance:** package builds in isolation; `FakePrinterService` round-trips bytes; a manual smoke test discovers + prints to a real printer; **no `features/*` imports the third-party packages directly** (grep-verified).
  - **Deps:** P0-1.

- [ ] **P2-2 — Receipt domain model & renderer (inside `packages/printing`)** · _Effort: M_
  - Add a `ReceiptRenderer` to `packages/printing` that takes a printer-agnostic receipt model (header, store info, line items w/ modifiers, subtotal, discount, tax, total, payment method, change, footer, timestamp, order #) and produces (a) ESC/POS bytes via `esc_pos_utils_plus` and (b) an on-screen **preview** widget.
  - The receipt model is plain Dart in `packages/printing` (no `features/*` dependency). The order→receipt mapping lives feature-side (a feature can depend on `printing`, not vice-versa).
  - Note: `PosSettings` model (`features/settings/.../pos_settings.dart`) exists with `receiptHeader`, `printerIp`, `currencySymbol` but is **currently unused** — reuse or supersede it.
  - **Files:** `packages/printing/lib/src/receipt/...` (model + renderer + preview); the order→receipt mapper in `features/orders` or a thin `features/receipts`; pull config from settings (P2-5/P4-x).
  - **Acceptance:** given a completed `Order` + store/receipt settings, the renderer produces correct ESC/POS bytes and a matching preview widget; covered by a golden test.
  - **Deps:** P2-1, P1-5 (order shape finalised), P1-6 (formatter).

- [ ] **P2-3 — Print-on-checkout + reprint** · _Effort: M_
  - After a successful sale (P1-5), emit a "print receipt" effect that sends to the configured printer; show a **preview/printing** sheet. Add a **reprint** action from the orders list (`OrdersPage`).
  - **Files:** checkout flow, `features/orders/lib/presentation/pages/orders_page.dart` (row action), printing package.
  - **Acceptance:** completing a sale prints a receipt; an existing order can be reprinted; failure to print is surfaced and the sale is still recorded.
  - **Deps:** P2-2.

- [ ] **P2-4 — Printer configuration UI (Settings → Printer)** · _Effort: M_
  - `Settings → Printer` is a literal placeholder (`placeholder_sections.dart`). Build pairing/selection (Bluetooth scan / USB list), test-print button, and persist selection. `AppSettingsTable` is intended to hold printer config (key/value).
  - **Files:** `features/settings/lib/presentation/widgets/printer_section.dart` (new), `features/settings/lib/presentation/pages/settings_page.dart`, `SettingsRepository.getPrinterSettings()` (already exists).
  - **Acceptance:** operator selects a printer, runs a successful test print, and the choice survives app restart.
  - **Deps:** P2-1, P4-1 (settings section pattern).

- [ ] **P2-5 — Receipt content configuration (Settings → Receipt Option)** · _Effort: S_
  - `Settings → Receipt Option` is a placeholder. Configure header/footer text, show/hide logo, show/hide tax line. `SettingsRepository.getReceiptSettings()` exists.
  - **Files:** `features/settings/lib/presentation/widgets/receipt_section.dart` (new), settings page.
  - **Acceptance:** receipt header/footer entered in settings appears on printed/previewed receipts.
  - **Deps:** P2-2, P4-1.

---

# Phase 3 — Catalog completeness (products, modifiers, ingredients)

**Goal:** make the product catalog fully manageable so modifiers actually work end-to-end (they currently can't reach the cart at all).

- [ ] **P3-1 — Persist product↔modifier links from the product form** · _Effort: M_
  - The "Variants & Modifiers" step toggles real modifiers, but `ProductFormCubit.submit()` builds a `Product` and calls `createProduct/updateProduct` **without** calling `setProductModifiers`. The cubit has **no `ModifiersRepository`** dependency; `ProductFormWrapper._show` constructs it with only `ProductsRepository` (`product_form_wrapper.dart:27`). Result: modifier selection on save is a **no-op**.
  - **Files:** `features/products/lib/presentation/blocs/product_form/product_form_cubit.dart`, `.../widgets/product_form/product_form_wrapper.dart`, register/inject `ModifiersRepository`.
  - **Acceptance:** selecting modifiers in the form and saving creates/removes rows in `ProductModifierLinksTable` (via `ModifiersRepository.setProductModifiers`).
  - **Deps:** P3-3 (need a way to create modifier groups first to test).

- [ ] **P3-2 — Populate `Product.modifierGroups` when reading products** · _Effort: M_
  - `ProductEntityMapper.toModel()` (`product_mapper.dart:10-24`) always defaults `modifierGroups: []`. So **every** product (including in POS) has no modifiers → modifiers can never be chosen when adding to cart, even after P3-1.
  - Load linked modifier groups + options for products (join via `ProductModifierLinksTable`). Decide eager vs. on-demand (on add-to-cart) for performance.
  - **Files:** `features/products/lib/domain/mappers/product_mapper.dart`, `products_repository_impl.dart`, `ModifiersDao` (has the join queries already).
  - **Acceptance:** a product with linked modifiers exposes them via `Product.modifierGroups`; POS can present them.
  - **Deps:** P3-1.

- [ ] **P3-3 — Modifier management UI (Settings → Modifier)** · _Effort: M_
  - `Settings → Modifier` is a placeholder, so **modifier groups can never be created via UI** → the product form's modifier step always shows "No modifiers available." `ModifiersBloc` is already registered globally and the data layer (DAO/repo, options, linking) is complete.
  - Build CRUD for modifier groups + options (name, multi-select toggle, option name + price change in cents).
  - **Files:** `features/products/lib/presentation/.../modifier_*` (new), `features/settings/.../modifier_section.dart` (new), settings page.
  - **Acceptance:** create a "Size" group with options "Small/Large (+€1.00)"; it appears in the product form modifier step.
  - **Deps:** P4-1 (settings section pattern).

- [ ] **P3-4 — Modifier selection at add-to-cart** · _Effort: M_
  - Today tapping a product adds it directly (`_onProductTap` → `itemAdded`) with **no modifier prompt**, and `SelectedModifiers.groupName` is hardcoded empty (`active_order_bloc.dart:84`, `// Would need modifier group name from context`).
  - When a product has modifier groups, present a selection sheet before adding; carry the real `groupName`/`optionName`/`priceChangeCents` into the line item.
  - **Files:** `features/pos/lib/presentation/...` (modifier picker), `active_order_bloc.dart`.
  - **Acceptance:** adding a product with required modifiers prompts for them; the cart line and persisted order item reflect the chosen modifiers and price changes.
  - **Deps:** P3-2.

- [ ] **P3-5 — Ingredients: finish or defer** · _Effort: M (or S to defer)_
  - The ingredients step **renders existing entries only**; its search field is `onChanged: (value) {}` (`ingredients_step.dart:99`) so there is **no way to add an ingredient**, and `ProductFormData.ingredients` is **dropped on submit** (never persisted; no ingredients table exists in the schema).
  - **Decision:** ingredients are not needed for a basic festival POS. Either (a) **defer**: hide/disable the step and remove dead form state, or (b) **implement**: add an ingredients/recipe table + persistence.
  - **Files:** `features/products/lib/presentation/widgets/product_form/steps/ingredients_step.dart`, `product_form_cubit.dart`, (if implementing) `packages/database` schema.
  - **Acceptance:** either the step is cleanly removed/disabled, or ingredients persist and reload.
  - **Deps:** P1-9 if implementing (schema change).

- [ ] **P3-6 — Quantity stepper in the cart** · _Effort: S_
  - Cart supports add (tap = +1) and swipe-to-remove, but there is **no in-cart quantity stepper**. `ui_kit` ships `QuantityButton` (+/− with min/max) — wire it. `ActiveOrderBloc` already handles `itemQuantityChanged`.
  - **Files:** `features/pos/lib/presentation/widgets/pos_order_item.dart` (+ panel), use `QuantityButton`.
  - **Acceptance:** operator can increment/decrement a line item's quantity from the cart; totals update.
  - **Deps:** none.

- [ ] **P3-7 — Seed real stock levels (currently none)** · _Effort: S_
  - The `DataSeeder` seeds categories + ~14 products + 2 demo orders, but **no stock**, no movements, no modifiers, no discounts, no settings. With stock-tracking on, products may show 0 stock.
  - Add seed stock for tracked products (or default new products to a sane initial stock / unlimited). Coordinate with P3-5 decision and `Product.trackStock`.
  - **Files:** `packages/database/lib/src/seeder/data_seeder.dart`.
  - **Acceptance:** seeded products have believable stock; low-stock UI in `ProductsPage` is exercised.
  - **Deps:** none.

---

# Phase 4 — Settings & configuration

**Goal:** make settings actually drive behaviour. Infra (cubit/repo/DAO, key-value `AppSettingsTable`) is complete; only **Category** is wired. 6/8 sections are placeholders and the **Store** form isn't connected.

- [ ] **P4-1 — Establish the settings-section wiring pattern** · _Effort: S_
  - The **Category** section (`category_section.dart`) is the reference: real CRUD via bloc + `SettingsCubit`. Document/replicate this pattern so each placeholder section (`placeholder_sections.dart`) can be filled consistently.
  - **Files:** `features/settings/lib/presentation/...`.
  - **Acceptance:** a short pattern note + a reusable section scaffold (`settings_section_scaffold.dart` already exists) ready for P2-4, P2-5, P3-3, P4-2..P4-5.
  - **Deps:** none.

- [ ] **P4-2 — Taxes configuration → drive cart tax** · _Effort: M_
  - `Settings → Taxes` is a placeholder, and the cart **hardcodes tax to 0** (`active_order_bloc.dart:240-241`, `// would come from settings`). `SettingsRepository` has typed getters (`getDouble`) and predefined keys.
  - Build a tax-rate setting (single rate is fine for a festival) and read it in `_buildOrder()`.
  - **Files:** `features/settings/.../taxes_section.dart` (new), settings page, `features/orders/.../active_order_bloc.dart`.
  - **Acceptance:** setting a tax rate makes the cart/checkout compute and persist `taxCents` correctly; receipts show it.
  - **Deps:** P4-1; affects P1-5/P2-2.

- [ ] **P4-3 — Currency & locale setting → drive formatter** · _Effort: S_
  - Currency symbol should be configurable (default `€`). Feed P1-6's formatter from settings.
  - **Files:** settings (a "general"/store section), `packages/utils` money formatter.
  - **Acceptance:** changing currency symbol updates display across POS/checkout/receipt/reports.
  - **Deps:** P1-6, P4-1.

- [ ] **P4-4 — Store information persistence (Settings → Store)** · _Effort: S_
  - `StoreSettingSection` (`store_setting_section.dart`) renders fields (Store Name, Phone, Email, City, Country, Full Address) as **plain `TextFormField`s with no controllers, no save** — store info is never persisted/loaded despite the infra existing.
  - Wire fields to `SettingsCubit` (load + save). Store name/address then feed the receipt header.
  - **Files:** `features/settings/lib/presentation/widgets/store_setting_section.dart`.
  - **Acceptance:** store details persist across restart and appear on the receipt.
  - **Deps:** P4-1; feeds P2-2/P2-5.

- [ ] **P4-5 — Payment methods configuration (Settings → Payment Method)** · _Effort: S_
  - `Settings → Payment Method` is a placeholder. For the free tier, allow enabling/labelling methods (Cash, Card, …) used by the checkout selector (P1-5). No payment-processor integration in the free tier.
  - **Files:** `features/settings/.../payment_method_section.dart` (new), settings page.
  - **Acceptance:** the checkout payment selector reflects configured methods.
  - **Deps:** P4-1; feeds P1-5.

---

# Phase 5 — End-of-day reporting (local)

**Goal:** a real sales summary / Z-report from local data. `ReportPage` is currently **entirely mocked**.

- [x] **P5-1 — Replace mock report data with a real reports bloc/repo** · _Effort: L_
  - `features/reports` has **no models, no repository, no bloc** (`ReportsFeature.providers == const []`). `ReportPage` hardcodes every number: summary cards (`72,099`, `$349,005`, …), `_mockTopProducts`, donut charts, `_mockOrders` (built with `OrderLineItem.fake()`), and the sales chart `FlSpot`s. The period dropdown (`onChanged: (value){}`) and the export button (`onPressed: (){}`) are no-ops. Dead leftover class `ImageFileOrderLineItem`.
  - The real queries already exist and are unused: `OrdersRepository.getTotalRevenue({start,end})`, `getTotalDiscounts(...)`, `getOrdersCount({status,start,end})`, `watchOrdersByDateRange(...)`, `watchOrdersByStatus(...)`.
  - Build a `ReportsCubit`/`ReportsBloc` + (optionally) a thin reporting repository that composes orders/order-items/inventory data. Register it in `ReportsFeature.providers`.
  - **Critical dependency:** revenue sums count **`completed`** orders only — this requires **P1-3** (orders are currently never completed).
  - **Files:** `features/reports/lib/...` (new bloc + models + provider wiring), `features/reports/lib/presentation/pages/report_page.dart`.
  - **Acceptance:** summary cards, top products, status donuts, and the orders table show **real** data for the selected period; remove `_mock*` and `ImageFileOrderLineItem`.
  - **Deps:** P1-3, P1-4.
  - ✅ **Done.** New domain models (`ReportData`, `ReportSummary`, `SalesPoint`, `ReportTopProduct`, `OrderStatusBreakdown`, `StockBreakdown` — freezed) + `ReportPeriod` enum. New `ReportsRepository`/`ReportsRepositoryImpl` composes the already-registered `OrdersRepository` + `ProductsRepository` (aggregation is in-memory over the period's orders via `watchOrdersByDateRange(...).first` + `watchAllProducts().first`; no new DAO queries needed). New `ReportsCubit`/`ReportsState` registered in `ReportsFeature.providers` (auto-loads on create); `...ReportsFeature.providers` added to `app_providers.dart` **after** Orders+Products. `report_page.dart` fully rewritten to a `BlocBuilder` consuming real data — all `_mock*`, `ImageFileOrderLineItem`, and the `SalesOverviewChart` mock `FlSpot`s removed. Revenue/items/avg-ticket count **completed** orders only; status donut counts all statuses; stock donut derived from `Product.trackStock`/`stockQuantity` (low-stock ≤ 5). Money rendered via `packages/utils` `formatCents`. `feature_reports` gained `result`/`talker`/`logger`/`utils` deps + `build_runner`/`freezed`/`auto_route_generator` dev-deps. `melos run build` (per-package) + analyze clean. Unit tests in `test/reports/repositories/` (5/5 pass) cover completed-only summary, status breakdown, top-product ranking incl. modifier revenue, stock breakdown, and empty state.

- [x] **P5-2 — Implement the period selector** · _Effort: S_
  - Make the period dropdown functional (Today / This event / Custom range) and refilter via the new bloc using `watchOrdersByDateRange`.
  - **Files:** `report_page.dart`, reports bloc.
  - **Acceptance:** changing the period updates all report widgets.
  - **Deps:** P5-1.
  - ✅ **Done.** The app-bar dropdown is now bound to `ReportPeriod` (`Today` / `This Week` / `This Month` / `All Time`); selecting a period calls `ReportsCubit.selectPeriod(...)` which recomputes the range (`ReportPeriod.range()`, week starts Monday) and reloads. Sales-trend granularity follows the period (hourly for Today, daily for week/month, monthly for All Time). Pull-to-refresh also reloads the current period. (Free-form custom date range deferred — the four presets cover the festival flow; a custom picker can slot into the same enum later.)

- [x] **P5-3 — End-of-day / Z-report summary screen** · _Effort: M_
  - A festival-operator-friendly summary: total revenue, order count, average ticket, cash vs card split, top products, items that hit zero stock, peak hour — raw numbers only, no narrative/AI layer.
  - **Files:** `features/reports/lib/presentation/pages/` (new `end_of_day_page.dart` or section), reports bloc.
  - **Acceptance:** one screen summarises an event/day from local data; reachable from the report area.
  - **Deps:** P5-1.
  - ✅ **Done (as a section on the report page).** New `EndOfDaySummary` widget surfaces the raw event wrap-up numbers — **cash vs card split**, discounts given, and **peak trading hour** — computed in `ReportSummary` (per-hour completed-order tally). Combined with the summary cards (total revenue, order count, **avg ticket**, items sold), top-products list, and the **out-of-stock** count in the stock donut, the report screen is the free-tier end-of-day summary for the selected period. Kept as a section on the existing `ReportPage` rather than a separate route (reachable from the Report nav destination); a dedicated `end_of_day_page.dart` can be extracted later if a print/share-only view is wanted.

- [ ] **P5-4 — Export report (CSV/PDF)** · _Effort: M_ — ⏸️ **DEFERRED.**
  - The download button is a no-op. Add local export (CSV minimum; PDF optional, reusing the printing/PDF stack if added in Phase 2). No package exists yet for this.
  - **Files:** `report_page.dart`, new util/package for CSV/PDF.
  - **Acceptance:** operator exports the current report to a shareable file.
  - **Deps:** P5-1; optionally P2-1/P2-2 if PDF.
  - ⏸️ **Deferred** (needs a file/share dependency — `share_plus`/`path_provider`/`csv` are not in the workspace). The Download button now shows an explicit "Export is coming soon" snackbar instead of silently no-op'ing, so intent is surfaced. Land alongside adding the export deps.

---

# Phase 6 — Discounts UX

**Goal:** let operators apply discounts at checkout. Data + bloc are real; there is **no UI anywhere** and the checkout discount button is commented out.

- [ ] **P6-1 — Discount entry at checkout** · _Effort: M_
  - `ActiveOrderBloc` already supports `discountApplied`/`discountRemoved` and computes percentage/fixed discounts in `_buildOrder()`. But the POS `PosActionButtons` (Customer / Tables / **Discount** / Save Bill) is **commented out** in `pos_order_panel.dart:65-73`, so nothing triggers it. `DiscountValidationCubit` exists but is 💀 (never provided).
  - Add a discount entry (apply by code or pick from active discounts), register `DiscountValidationCubit`, and surface apply/remove in the cart/checkout.
  - **Files:** `features/pos/lib/presentation/widgets/pos_order_panel.dart`, `pos_action_buttons.dart`, `features/discounts` (register `DiscountValidationCubit` in `DiscountsFeature.providers`).
  - **Acceptance:** applying a valid discount updates totals and persists `discountCents`; invalid/expired codes are rejected with a message.
  - **Deps:** P6-3 (need discounts to exist), P1-5.

- [ ] **P6-2 — Fix discount usage-limit mapping** · _Effort: S_
  - The entity→model mapper **drops `usageLimit`/`usageCount`** (`discounts_repository_impl.dart:20-30`, always defaults), yet `DiscountValidationCubit` checks usage limits → usage-limit validation is effectively dead. Note the `DiscountsTable` itself has **no** `usageLimit`/`usageCount` columns — confirm whether to add columns or drop the concept.
  - **Files:** `features/discounts/lib/data/repositories/discounts_repository_impl.dart`, possibly `packages/database/.../discounts_table.dart` (+ migration).
  - **Acceptance:** usage limits either work end-to-end (mapped + enforced + persisted) or are intentionally removed from the model.
  - **Deps:** P1-9 if adding columns.

- [ ] **P6-3 — Discount management UI (Settings → Discount & Voucher)** · _Effort: M_
  - `Settings → Discount & Voucher` is a placeholder. `DiscountsBloc` (CRUD + toggle + filter) is real.
  - Build list/create/edit (name, type %, value, optional code, valid-until, active toggle).
  - **Files:** `features/discounts/lib/presentation/...` (new), `features/settings/.../discount_section.dart` (new), settings page.
  - **Acceptance:** create/activate a discount; it becomes selectable at checkout (P6-1).
  - **Deps:** P4-1.

---

# Phase 7 — Polish, UX, i18n, errors

**Goal:** shippable quality for non-technical seasonal volunteers running a sagra stand — low technical literacy, busy event, zero downtime.

- [ ] **P7-1 — Remove/route dead code** · _Effort: S_
  - 💀 cubits never provided/used: `OrderDetailCubit` (→ adopt in P7-2), `ProductDetailCubit`, `StockAdjustmentCubit` (→ adopt in P7-8), `DiscountValidationCubit` (→ adopt in P6-1). Dead types: `ImageFileOrderLineItem` (reports), unused `PosSettings` model (superseded by `packages/printing` receipt model + settings keys). `OrdersPage` edit action is a no-op `case ...edit: break;` (→ wire in P7-2). (`session_state_utils.dart` and the rest of `feature_auth` are removed in P7-6.)
  - Either wire them into the flows above or delete them. Anything not adopted by Phases 1/5/6/7 should be deleted.
  - **Acceptance:** no orphaned cubits/classes; `melos run lint` clean; intentional dead code documented.
  - **Deps:** after the phases that might adopt them (1, 5, 6, 7).

- [ ] **P7-2 — Order detail page** · _Effort: M_
  - There is no order-detail page; `OrderDetailCubit` (load/complete/void) is unused and not registered. `OrdersPage` can list but not drill in.
  - Build a detail page (line items + modifiers, totals, payment, status; actions: void, reprint). Register `OrderDetailCubit` in `OrdersFeature.providers`.
  - **Files:** `features/orders/lib/presentation/pages/order_detail_page.dart` (new), router, providers.
  - **Acceptance:** tapping an order opens details; void restores stock (calls `restoreForVoidedOrder` — note it's currently only called on delete, not void) and reprint works.
  - **Deps:** P1-4 (stock restore on void), P2-3 (reprint).

- [ ] **P7-3 — Internationalisation (English + Italian)** · _Effort: M_
  - The product targets Italian sagre but i18n (`slang`, `packages/i18n`) ships generic English strings; many UI strings are hardcoded literals (snackbars, mock labels, etc.). Add Italian translations and route user-facing strings through `slang`.
  - **Files:** `packages/i18n/`, app & feature presentation strings; `slang.yaml`.
  - **Acceptance:** app runs in Italian and English; no hardcoded user-facing strings in new code.
  - **Deps:** stabilises late; do after flows exist.

- [ ] **P7-4 — Error handling & offline resilience UX** · _Effort: M_
  - Ensure failures (DB write, print) surface clearly and never lose a sale. `result`/`errors` provide `Result<T>` + `RepositoryException`; standardise surfacing (snackbars/dialogs) and logging via `Talker`. Note `AppException` is referenced in `CLAUDE.md`/docs but **does not exist** — only `RepositoryException`. Align docs or add the type.
  - **Acceptance:** every repository call in the checkout/print path handles errors gracefully; no unhandled exceptions in the happy + sad paths.
  - **Deps:** Phase 1/2.

- [ ] **P7-5 — Remove auth/login/operator entirely (free tier is a no-login standalone POS)** · _Effort: S_
  - **DECIDED:** the free tier needs **no auth, no login, no operator/cashier concept**. It is a full-local standalone POS. Strip all auth coupling from the app shell and routing.
  - Today the shell is gated by auth: `protected_shell_page.dart` wraps everything in `SessionListener` (redirects to `AuthShellRoute` on `unauthenticated`) and passes hardcoded identity to the `ui_kit` shell — `userName: 'Brian Susanto'`, `userSubtitle: 'JS002T'`, `currentOperator: 'Main Counter'`, plus `isClockedIn`, `onLogout` (`// TODO`), `onOperatorSwitchTap` (`// TODO`). The router registers `AuthShellRoute` (`app_router.dart:19`) and `AppFeature.providers` includes `AuthFeature.providers` (`app_providers.dart:114`).
  - **Good news — no `ui_kit` changes needed:** on `AppShellScope` every identity field is **optional** (`userName`, `currentOperator`, `onLogout`, `isClockedIn`, …) and `app_shell_actions.dart` "renders nothing if `userName`/`currentOperator` is null" (lines 9, 58). So simply **stop passing** them and the operator chip + user menu (clock-in/logout) disappear automatically.
  - **Steps:**
    1. `apps/agora/lib/app/pages/protected_shell_page.dart` — remove the `SessionListener` wrapper; drop `userName`/`userSubtitle`/`isClockedIn`/`onClockInTap`/`onLogout`/`currentOperator`/`onOperatorSwitchTap` from `AppShellScope` (keep only `openSidebar` + `child`); delete `_isClockedIn`.
    2. `apps/agora/lib/app/widgets/session_listener.dart` — delete the file.
    3. `apps/agora/lib/app/app_router.dart` — remove `AuthShellRoute` and the `feature_auth` import; make the protected shell the unconditional initial route.
    4. `apps/agora/lib/app/app_providers.dart` — remove `...AuthFeature.providers` and the `feature_auth` import.
    5. `apps/agora/pubspec.yaml` — remove the `feature_auth` path dependency. (`feature_auth` can be left in the repo unused, or deleted — see P7-6.)
    6. Regenerate routes (`build_runner`) and `melos bootstrap`.
  - **Also prune restaurant-only nav** in the same file: the disabled `Customers`, `Tables` nav items (`isEnabled: false`) are restaurant concepts — remove them. **Keep `Inventory`** but wire it (it's currently `isEnabled: false` with no route) — see P7-8.
  - **Acceptance:** app launches **straight into the POS** with no login/auth route; no operator chip, clock-in, or logout UI anywhere; nav shows only festival-relevant destinations; `melos run lint`/`build`/`test` pass; no references to `feature_auth`/`SessionCubit`/`SessionListener` remain in `apps/agora`.
  - **Deps:** none. (Do early — it simplifies everything downstream.)

- [ ] **P7-6 — Delete (or quarantine) the now-unused `feature_auth` package** · _Effort: S_
  - After P7-5 nothing imports `feature_auth`. The package itself is only stubs anyway (`AuthRepository`/`AuthRepositoryImpl` empty; `SessionCubit` logic fully commented out; `AuthShellPage` is just `AutoRouter()`; `session_state_utils.dart` is `// TODO remove this`).
  - **Decision:** delete `features/auth/` outright (cleanest for a no-auth free tier), **or** keep it in the monorepo unused for a possible future paid-tier login but ensure no app depends on it.
  - **Files:** `features/auth/` (whole package), `melos.yaml`/root `pubspec.yaml` workspace list if deleting, any stale references in `docs/AGENT_MANIFEST.json`.
  - **Acceptance:** `melos bootstrap` + `melos run build` succeed with `feature_auth` removed from the dependency graph; no dangling imports.
  - **Deps:** P7-5.

- [ ] **P7-7 — App identity & store assets** · _Effort: S_
  - Android applicationId is `com.example.agora`; launcher icons/splash configured via `flutter_native_splash`/`flutter_launcher_icons`. Set a real bundle id, app name, icon, and splash before release.
  - **Files:** `apps/agora/android`, `apps/agora/ios`, `apps/agora/web`, `native_splash.yaml`, launcher icon config.
  - **Acceptance:** installs as "Agora POS" with proper icon/splash and a real bundle id.
  - **Deps:** none.

- [ ] **P7-8 — Basic inventory management UI (build the missing Inventory page)** · _Effort: M_
  - **In scope for the free tier** ("very basic inventory management"). The data + bloc layers are **fully real but have no page** and the nav item is disabled.
  - What exists: `InventoryRepository` (watch all stocks, low-stock by threshold, movement history, `adjustStock`, `setStock`, `decrementForOrder`, `restoreForVoidedOrder` — all implemented), `InventoryBloc` (list + low-stock threshold + filter), and `StockAdjustmentCubit` (adjust/set with optimistic updates) — but `StockAdjustmentCubit` is 💀 (never provided) and `InventoryFeature` exposes **no route/page**.
  - Build a simple stock screen: per-product current quantity, low-stock highlighting, and quick **+/- adjust** / **set** actions (reuse `ui_kit` `QuantityButton` + `DataTableView`). Register `StockAdjustmentCubit` and add an `InventoryRoute` to `InventoryFeature`.
  - Wire it into the shell: change the `Inventory` nav item from `isEnabled: false` to enabled + routed in `protected_shell_page.dart` (`_navItems` + `_routedIndices` + `AutoTabsRouter.routes`) and in `app_router.dart`.
  - Note `getMovementHistory()` without a `productId` returns `const []` (`inventory_repository_impl.dart:109-112`, missing DAO query) — add the DAO query if you surface a global movement log; otherwise scope history per product.
  - **Files:** `features/inventory/lib/presentation/pages/inventory_page.dart` (new), `features/inventory/lib/presentation/routes/inventory_feature.dart` (add route + register cubit), `apps/agora/lib/app/app_router.dart`, `apps/agora/lib/app/pages/protected_shell_page.dart`, optionally `features/inventory/.../stock_movements_dao.dart`.
  - **Acceptance:** operator opens Inventory, sees stock levels with low-stock indication, and can adjust/set quantities; adjustments record `StockMovementsTable` rows and reflect immediately in `ProductsPage` stock + POS availability. Ties together with P1-4 (sales decrement) and P3-7 (seed stock).
  - **Deps:** P7-5 (nav cleanup), and complements P1-4 / P3-7.

---

# Phase 8 — Testing & release

**Goal:** confidence and shippable artifacts. Testing strategy per `docs/architecture/ARCHITECTURE.md` and `docs/llm/LLM_TESTING_GUIDELINES.md`: domain (pure), repos (mock DAOs), blocs (`bloc_test`), widgets (`flutter_test`), integration (in-memory Drift).

- [ ] **P8-1 — Unit-test the checkout + completion + stock path** · _Effort: M_
  - `bloc_test` for the new checkout flow: empty-cart guard, totals (subtotal/discount/**tax**), payment capture, completion, **stock decrement**, success/error effects. Mock repositories.
  - **Files:** `test/orders/...`, `test/pos/...`.
  - **Acceptance:** the critical path is covered incl. the previously-broken submit confirmation (P1-7).
  - **Deps:** Phase 1.

- [ ] **P8-2 — Test reporting aggregations** · _Effort: M_
  - In-memory Drift DB: seed orders/items, assert revenue/order-count/top-products/period filtering match.
  - **Files:** `test/reports/...` (new).
  - **Deps:** Phase 5.

- [ ] **P8-3 — Test settings → behaviour wiring** · _Effort: S_
  - Tax rate drives cart tax; currency drives formatter; store info reaches receipt.
  - **Files:** `test/settings/...`.
  - **Deps:** Phase 4.

- [ ] **P8-4 — Printing tests with `FakePrinterService`** · _Effort: S_
  - Golden test: `ReceiptRenderer` produces expected ESC/POS bytes for a known order + settings. Test the reprint path using `packages/printing`'s `FakePrinterService` (no hardware). Verify discovery/connect/print error paths return `Result.error` and surface in the checkout flow.
  - **Files:** `packages/printing/test/...` (renderer + fake service), plus checkout-flow tests in `test/...`.
  - **Deps:** Phase 2.

- [ ] **P8-5 — Migration test** · _Effort: S_
  - Verify v1 → latest schema migration preserves data (P1-9).
  - **Files:** `packages/database/test/...`.
  - **Deps:** P1-9.

- [ ] **P8-6 — Inventory adjustment tests** · _Effort: S_
  - `bloc_test`/repo tests: adjusting/setting stock updates `StocksTable` and records `StockMovementsTable`; sale decrement (P1-4) and void restore behave correctly.
  - **Files:** `test/inventory/...` (extend existing).
  - **Deps:** P7-8, P1-4.

- [ ] **P8-6 — CI + release builds** · _Effort: M_
  - Ensure `melos run lint`, `melos run test`, and `melos run build` run in CI (lefthook already does format/analyze pre-commit and test pre-push). Produce Android APK/AAB (+ optionally iOS/web) builds.
  - **Files:** `.github/workflows/...`, `lefthook.yaml`.
  - **Acceptance:** green CI on push; a downloadable Android artifact.
  - **Deps:** Phase 0–7 stable.

---

# Phase 9 — LAN sync hub wiring (DEFERRED — placeholders only)

> **Status:** the `sync_hub/` directory **does not exist yet**. Per direction, these are **placeholder seams** only. Do **not** implement against invented API contracts; fill in once the hub spec lands (`docs/architecture/BACKEND.md`). The good news: `packages/sync_engine` is **already real and tested** (outbox queue + connectivity monitor + managed WebSocket with reconnect), so the client seam is mostly about wiring, not building. There is no free/paid split any more — LAN sync is a core roadmap feature (`ECOSYSTEM.md` Phase 2), gated only by whether a station is paired with a hub, not by a subscription.

- [ ] **P9-1 — Pairing seam (standalone vs hub-paired)** · _Effort: M_
  - Introduce a `SyncPairingService` abstraction with a **local default = standalone** (no hub). When a station pairs with a hub's LAN address, sync activates; otherwise the app behaves exactly as it does today.
  - **Acceptance:** a station works fully standalone with no hub present; pairing is additive, not a purchase gate.
  - **Deps:** none (pure abstraction).

- [ ] **P9-2 — Wire `sync_engine` into the order write path (outbox)** · _Effort: M_
  - `sync_engine` provides `SyncableRepository.safeSync(...)` (local write + outbox enqueue) and `OutboxTable`/`OutboxDao`. Make order/catalog repositories enqueue mutations to the outbox **whenever paired with a hub** (no-op when standalone). Register a `SyncManager` and per-entity `SyncHandler`s (handlers do the actual LAN push — **left blank until the hub API exists**).
  - **Acceptance:** when paired, completing an order enqueues an outbox entry; standalone, nothing is enqueued. Handlers are stubs that clearly TODO the network call.
  - **Deps:** P9-1, Phase 1.

- [ ] **P9-3 — Kitchen/stand ticket routing — placeholder** · _Effort: L (deferred)_
  - Per `ECOSYSTEM.md` Phase 2: a completed order should route to the right prep stand via WebSocket. Define the client subscription seam and a `SyncHandler` for orders. **Topic/payload contracts TBD by the hub** (`BACKEND.md` proposes `orders`, `stock`, `kitchen:{stand}`).
  - **Acceptance:** documented seam + stubbed handler; no behaviour until the hub spec lands.
  - **Deps:** P9-2.

- [ ] **P9-4 — Multi-station order/stock sync — placeholder** · _Effort: L (deferred)_
  - Shared order queue and stock count across POS tablets over the event's LAN. Reuse outbox + WebSocket inbound messages. **Conflict resolution is explicitly NOT implemented in `sync_engine`** — `BACKEND.md` proposes append-only orders + delta stock adjustments to sidestep most conflicts; validate that design when specced.
  - **Acceptance:** documented design note + seam; deferred.
  - **Deps:** P9-2.

- [ ] **P9-5 — Reconcile architecture docs with reality** · _Effort: S_
  - ✅ **Done (2026-07-14).** `docs/architecture/ECOSYSTEM.md`, `ARCHITECTURE.md`, `BACKEND.md`, `PAYMENTS_AND_FISCAL.md`, `docs/marketing/PRODUCT_BRIEF.md`, `docs/llm/ARCHITECTURE.md`, and root `CLAUDE.md` were rewritten to scope the product to sagra/village-festival/small-event use only (dropping the restaurant-SaaS multi-app roadmap and the cloud multi-tenant backend), and now correctly describe `apps/agora` as the sole app. `docs/architecture/BUSINESS_PROFILES.md` and `docs/architecture/AI_INTEGRATION.md` were deleted (vertical-switching and cloud-AI-subscription concepts no longer apply). Remaining stale items from the old Appendix C below (`AppException`, `safe()` as free function, `AGENT_MANIFEST.json` paths) are unrelated code/doc drift, not scope drift — still open.
  - **Deps:** none.

---

## Appendix A — Critical-path dependency chain (the must-do spine)

```
P0-1 ─┬─ P0-2 ─ P0-3
      └─ P1-6 (formatter) ───────────────┐
P1-1 (orderType) ─┐                       │
P1-9 (migrations) ┘                       ▼
P1-2 (paymentMethod) ─┐            P1-5 (checkout/payment UI)
P1-3 (complete order) ─┼──────────►  │  ▲
P1-4 (decrement stock) ┘             │  │ P1-7 (fix submit listener)
                                     ▼
                              P2-1 ─ P2-2 ─ P2-3 (print receipt)
                                     │
                                     ▼
                              P5-1 (real reports — needs P1-3/P1-4)
```

Everything else (Phase 3 modifiers, Phase 4 settings, Phase 6 discounts, Phase 7 polish) hangs off this spine and can be parallelised once Phase 1 lands.

## Appendix B — "Definition of shippable" (free-tier MVP checklist)

- [ ] **No login** — app opens straight into the POS; auth/operator fully removed — **P7-5, P7-6**
- [ ] Configure products/categories (and modifiers) locally — **P3-1..P3-4**
- [ ] Build a cart with quantities and modifiers — **P3-4, P3-6**
- [ ] Take payment (cash + change, card) and finalise the sale — **P1-5**
- [ ] Orders persist as **completed**; stock decrements — **P1-3, P1-4**
- [ ] Basic inventory management (view + adjust stock) — **P7-8**
- [ ] Print/preview a receipt on a thermal printer (`packages/printing`) — **P2-1..P2-4**
- [ ] Configure tax, currency, store info, printer — **P4-2..P4-4, P2-4**
- [ ] See a real end-of-day sales summary — **P5-1, P5-3**
- [ ] Works fully offline; no crashes on the happy/sad paths — **P7-4**
- [ ] Italian + English — **P7-3**
- [ ] Real app identity + release build — **P7-7, P8-6**

## Appendix C — Doc vs. reality discrepancies (worth knowing)

| Doc claim | Reality |
|---|---|
| `package:errors` exposes `AppException` (`CLAUDE.md`, `ARCHITECTURE.md`). | Only `RepositoryException` exists; no `AppException` anywhere. |
| `safe()` helper / `result` "free function". | `safe`/`safeSync` are **methods** on `Repository`/`SyncableRepository`; no top-level `safe()`. |
| `AgoraDatabase` exposes DAOs (`db.productsDao`) in some older notes. | DAOs are **not** registered on the DB; constructed as `SomeDao(db)` in each feature. (`NEXT_STEPS.md` already corrects this.) |
| `docs/AGENT_MANIFEST.json` paths like `lib/products/...`. | Pre-migration layout; real paths are `features/products/lib/...`. Manifest is stale. |
| LAN sync hub exists / ready (Phase 2 of `ECOSYSTEM.md`). | No `sync_hub/`. `packages/sync_engine` **is** real and ready to wire. |

*(The `apps/festival_pos`-as-separate-app and restaurant-SaaS/cloud-backend discrepancies that used to live here were resolved by the 2026-07-14 doc rewrite — see P9-5 above — not just noted.)*

---

_Last generated from a full audit of `apps/agora`, `features/*`, and `packages/*` on the `master` branch. Line/file references reflect the code at that time; re-verify after large refactors._
