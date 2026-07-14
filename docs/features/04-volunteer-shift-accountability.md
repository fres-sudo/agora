# Feature 4 — Volunteer shift accountability (PIN login + cash reconciliation)

> Priority #4. Half of this is already built and working. The other half
> (cash reconciliation) doesn't exist anywhere.

## Description

Every volunteer clocks in/out with their own PIN, and when they clock out,
the app shows expected cash for their shift (from completed cash orders)
and lets them enter what's actually in the drawer, recording any variance.

## Why

Sagre run on rotating volunteer shifts handling cash. Knowing who was on
the till and whether the drawer balanced at handover is the accountability
mechanism a treasurer actually needs — right now there's no way to tie a
sale to a person or to catch a shortfall until much later, if ever.

## What's already built — don't re-build this

Confirmed by reading the code, **directly contradicting**
`docs/FESTIVAL_POS_TASKS.md` tasks P7-5/P7-6, which claim auth was slated
for full removal ("free tier has no auth/login/operator at all",
`SessionCubit`/`AuthRepository` are "empty stubs"). That plan either wasn't
executed or was reversed — treat `FESTIVAL_POS_TASKS.md`'s P7-5/P7-6 as
**stale**, not as current direction. Current reality:

- **PIN login works end-to-end and is wired into the app.**
  `features/auth/lib/presentation/pages/pin_login_page.dart` — employee
  avatar grid → PIN pad → `SessionCubit.loginWithPin`.
  `features/auth/lib/data/repositories/auth_repository_impl.dart:37-71` —
  verifies against bcrypt (`PinHasher`) with a legacy-plaintext-upgrade
  path; session persisted via `flutter_secure_storage`. Wired in
  `apps/agora/lib/app/app_providers.dart` (`AuthFeature.providers`,
  registered before `AppResetService`) and
  `apps/agora/lib/app/app_router.dart` (`AuthShellRoute`/`PinLoginRoute`
  live routes). `apps/agora/lib/app/pages/protected_shell_page.dart` reads
  the session for the shell header and drives clock-in/out.
- **Employee CRUD + clock-in/out already work.**
  `features/workforce/lib/domain/models/employee.dart` —
  `id, name, pin (hashed), role (EmployeeRole: owner/manager/cashier),
  isActive, hourlyRateCents, avatarUrl?`. `clock_record.dart` —
  `id, employeeId, employeeName, clockedInAt, clockedOutAt?, note?`, with a
  DB-level partial unique index guaranteeing one open shift per employee
  (`packages/database` schema v4 migration). `ClockInCubit`
  (`features/workforce/lib/presentation/blocs/clock_in/clock_in_cubit.dart`)
  and `clock_records_page.dart`/`employees_page.dart` are real, working UI.

**None of the above needs to be built.** This feature is purely additive.

## What's missing — this is the actual feature

- **Cash reconciliation has zero footprint anywhere** — confirmed by a
  repo-wide grep for `shiftId|cashCount|reconcil` (excluding unrelated
  inventory-stock-reconciliation comments). No cash field on any table, no
  employee/shift link on `OrdersTable`.
- **Orders aren't tied to an employee or shift at all.**
  `OrdersTable`/`Order` domain model
  (`packages/order_management/lib/models/order.dart:18-37`) has no
  `employeeId`/`shiftId` field. This means "expected cash for this shift"
  cannot be computed today even in principle — it's not just a missing UI
  screen, it's a missing data link.

## Where

- `features/workforce` owns `ClockRecord`/`WorkforceRepository` — this is
  where reconciliation data belongs (it's shift data, one feature, no
  cross-feature sharing need identified yet, so no new `packages/`
  extraction required unless reports/orders end up needing shift data too
  — reassess if that comes up).
- `packages/order_management` owns `Order`/`CheckoutCubit` — needs the new
  `employeeId` link, since that's where an order is completed and the
  current session's employee is knowable.
- `packages/database` — two schema changes (`OrdersTable.employeeId`,
  and a reconciliation table).

## How

### Step 1 — Link orders to the employee who took them

- Add `employeeId` (nullable int, FK → `EmployeesTable`) to `OrdersTable`
  (`packages/database/lib/src/tables/orders_table.dart`).
- `CheckoutCubit.confirm()` (`packages/order_management/lib/blocs/checkout/checkout_cubit.dart:103-164`)
  is where the order is finalized — it needs access to the current
  session's employee id at that point. `CheckoutCubit` currently has no
  dependency on auth/session state; inject a way to read the current
  employee id (likely via a small callback/provider passed in at
  construction in `apps/agora/lib/app/app_providers.dart`, consistent with
  how `CheckoutCubit` already reads `DiscountsRepository`/
  `InventoryRepository` per the existing provider-ordering comments —
  Auth is already registered before Orders in that file, so the dependency
  direction is fine).
- Nullable, not required: orders taken with no session (shouldn't normally
  happen since PIN login gates the shell, but keep it nullable defensively
  rather than crash checkout if session state is ever momentarily absent).

### Step 2 — Cash reconciliation table

New table, referencing the shift being closed:
```
CashReconciliationsTable (+TableMixin):
  clockRecordId   FK → ClockRecordsTable, unique (one reconciliation per shift)
  expectedCents   int   -- computed at close time from cash orders in this shift
  countedCents    int   -- what the volunteer enters
  varianceCents   int   -- countedCents - expectedCents, stored not just derived,
                            so a later report doesn't need to recompute historical math
  note            text nullable
```
Bump `schemaVersion` (coordinate with features 2/3 if shipping close
together — one migration, not three).

### Step 3 — Compute expected cash

- `WorkforceRepository` gains a method, e.g.
  `Future<int> expectedCashCentsForShift(int clockRecordId)` — sums
  `grandTotalCents` for orders where `employeeId == shift.employeeId`,
  `paymentMethod == 'Cash'`, `status == completed`, and
  `createdAt BETWEEN clockedInAt AND now()`. This is the first place
  `WorkforceRepository` needs to read `OrdersTable` — check current
  dependency direction (`features/workforce` importing `order_management`
  or `orders`'s repository interface) before implementing; this is a new
  cross-feature dependency edge, follow the same "read through a shared
  package interface, not another feature directly" rule that motivated
  `packages/order_management`/`packages/catalog`/`packages/discounts` in
  the first place — i.e. `workforce` should depend on
  `package:order_management`'s `OrdersRepository` interface, not on
  `features/orders` directly.

### Step 4 — Clock-out flow gains a cash-count step

- Current `clockOut(employeeId)`
  (`features/workforce/lib/data/repositories/workforce_repository_impl.dart:108-122`)
  is a single call with no intermediate step. The natural integration point
  is `ProtectedShellPage._onClockInTap`
  (`apps/agora/lib/app/pages/protected_shell_page.dart:148-156`) — on
  clock-out (not clock-in), show a new sheet/page: "Expected cash: €X.XX —
  enter counted cash" → on confirm, write the `CashReconciliationsTable`
  row *and then* call `clockOut`. Don't let a skipped/cancelled count block
  clocking out entirely — a volunteer forgetting to count shouldn't be
  locked into a shift; make the count step skippable with a clear "counted
  later" state rather than a hard gate, unless the treasurer explicitly
  wants it mandatory (open question below).

### Step 5 — Surface variance

- `clock_records_page.dart` gains a variance indicator per closed shift
  (green/neutral if reconciled and near zero, flagged if a meaningful
  discrepancy) — reuse the existing list-item pattern, add one more badge
  next to the existing duration badge.
- Optional, lower priority: an end-of-event rollup of variance across all
  shifts, on `features/reports`' existing end-of-day summary
  (`EndOfDaySummary` widget) — natural fit next to the existing cash-vs-card
  split, but not required for v1.

## Acceptance criteria

- Every completed cash order during a shift is attributable to the
  employee who took it.
- Clocking out shows expected cash computed from that shift's cash orders,
  accepts a counted amount, and stores the variance.
- `clock_records_page.dart` shows the variance for closed, reconciled
  shifts.
- A shift with no cash orders (all-card, or no sales) shows €0 expected,
  not an error.

## Open questions (need a decision before Step 4)

- Is entering a cash count **mandatory** to clock out, or skippable? A hard
  gate is more accountable but risks a volunteer being stuck if they forget
  the drawer is elsewhere; skippable is friendlier but weakens the whole
  point of the feature. Recommend skippable-with-a-visible-"not reconciled"
  state, revisit if treasurers push back.
- Who can see variance — every volunteer, or only manager/owner roles
  (`EmployeeRole` already has this distinction)? Recommend gating the
  variance *number* (not the count-entry step itself) to `manager`/`owner`,
  consistent with `EmployeeRole` already existing for exactly this kind of
  permission split.
