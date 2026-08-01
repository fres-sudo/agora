# Feature 8 — Public menu QR publishing

> Proposed feature. Agora remains a local-first POS. This is an explicitly
> opt-in internet feature which lets an organiser publish a read-only copy of
> the current catalog for guests to open in a browser after scanning a QR code.

## Outcome

An organiser can open **Settings → Public Menu**, choose a server-provided
template, preview the current local catalog in that template, and tap
**Publish & generate QR**. Agora gives them a stable public HTTPS URL and a
shareable/printable QR image.

The code in the QR remains valid when the organiser later changes the menu:
they select **Update published menu**, which replaces the published snapshot
at the same public URL.

```
local Drift catalog ──► preview / publish request ──► server renderer
       ▲                                                   │
       │                                                   ▼
the POS is always authoritative                    static public menu + QR
```

There is no guest ordering, payment, customer data, LAN-hub dependency, or
live connection from a public menu to the POS in v1.

## Product decisions

- **Publishing is deliberate.** Catalog edits remain local until the host taps
  Publish/Update. The app never sends catalog data in the background.
- **The URL is stable.** Re-publishing changes the content behind the QR, not
  the QR itself.
- **The public site is a snapshot.** It shows only `ProductStatus.active`
  products in enabled categories, plus enabled combos; it must not expose SKU,
  cost, stock, tax, prep station, modifier configuration, or POS order data.
- **Templates are server-owned and versioned.** The app chooses a template ID
  and version; the server owns HTML/CSS/JS and renders the final document. The
  app must never upload arbitrary HTML.
- **Preview is in v1.** It calls the same renderer as publishing and is shown
  in an in-app WebView, so the result is faithful without reimplementing every
  website template in Flutter.
- **No required account.** A local publisher capability authorises changes to
  a menu. Optional account/recovery and multi-device sharing are later work.

## Scope

### In scope

- One active published menu for the catalog on an installation.
- Server-provided template gallery, including thumbnail, name, description,
  and supported presentation options.
- Local configuration for event/menu title, optional subtitle, selected
  template, and options declared by the template (for example: descriptions,
  prices, category icons, disclaimer).
- Preview of the exact current local snapshot in the selected template.
- Publish, update, copy/open public URL, unpublish, QR PNG export/share, and
  an A4 poster/PDF export.
- A visible status: unpublished, publishing, published, update available,
  offline/error.

### Deliberately out of scope for v1

- Customer ordering, payments, table numbers, or collecting personal data.
- A live stock/availability feed, push updates, analytics, custom domains,
  translations, or user-created templates.
- Required signup, email verification, Apple/Google sign-in, or platform
  attestation.
- Rendering templates natively in Flutter or executing downloaded template
  code locally.
- Product photos selected from the device. Today `Product.imageUrl` can be a
  local device path; that path cannot be used by a public website. V1 may show
  only no visual or an Agora stock-icon reference. Add server-managed photo
  uploads as a separate follow-up (see Backend contract).

## Client placement and local state

The entry point belongs in `features/settings`: publishing is an organiser
configuration activity, alongside store details, printer setup, sync, and
catalog templates. Add a **Public Menu** sidebar item to
`features/settings/lib/presentation/pages/settings_page.dart`.

Keep the remote integration behind a domain interface so presentation code
does not use HTTP/WebView details directly:

```
features/settings/lib/
├── data/
│   ├── repositories/public_menu_repository_impl.dart
│   └── sources/remote/public_menu_remote_data_source.dart
├── domain/
│   ├── models/
│   │   ├── public_menu_configuration.dart
│   │   ├── menu_template.dart
│   │   ├── menu_publication.dart
│   │   └── public_menu_snapshot.dart
│   └── repositories/public_menu_repository.dart
└── presentation/
    ├── blocs/public_menu/public_menu_cubit.dart
    └── widgets/public_menu/
        ├── public_menu_section.dart
        ├── template_gallery.dart
        ├── menu_preview_sheet.dart
        └── publication_actions.dart
```

`PublicMenuSnapshot` is a purpose-built wire model, not a serialization of
`package:catalog` domain classes. This prevents accidentally exporting private
or implementation-only fields and keeps the server schema stable if catalog
models change. The repository builds it from `CategoriesRepository`,
`ProductsRepository`, `CombosRepository`, and `SettingsCubit`/the settings
repository.

Suggested snapshot shape (illustrative, not a literal Dart DTO):

```json
{
  "schemaVersion": 1,
  "menu": {
    "title": "Sagra di San Rocco",
    "subtitle": "Stand gastronomico",
    "currency": "EUR",
    "disclaimer": "Allergeni: chiedi allo staff"
  },
  "categories": [
    {
      "name": "Primi",
      "icon": "pasta",
      "items": [
        {"kind": "product", "name": "Tagliatelle", "description": "", "priceCents": 800}
      ]
    }
  ],
  "combos": [
    {"kind": "combo", "name": "Menu completo", "priceCents": 1200}
  ]
}
```

Use the configured business name as the initial title, but allow a
publication-specific title/subtitle: a shop name is not always the event name.
Validate the title and require at least one visible item before previewing or
publishing.

Persist non-secret publication metadata locally: remote menu ID, public URL,
template ID/version, last published snapshot hash/version, and timestamps.
The owner capability must be stored only in platform secure storage, keyed by
the remote menu ID; never put it in Drift, app settings, logs, QR payloads, or
share text. A reset/uninstall can therefore lose update authority; the UI must
warn before local reset and offer a future recovery path only when one exists.

## Client flow

1. The host opens **Public Menu**. The app fetches the template manifest when
   online; it may display the last cached manifest as read-only while offline.
2. They choose a template and fill the publication-specific presentation
   fields. Thumbnails communicate the design before a full preview.
3. **Preview** builds a fresh snapshot from the local catalog and sends it to
   the preview API. The returned temporary HTTPS page opens in a WebView.
   Scrolling, images, responsive layout, and browser interactions work exactly
   as on the guest-facing site, but it is not public and expires quickly.
4. **Publish** (or **Update**) sends the same fresh snapshot, template ID, and
   pinned template version. Do not reuse a preview response as the publication.
5. On success, save non-secret metadata and secret ownership capability; show
   the QR, public URL, a printable A4 poster, and an explicit **Update menu**
   action whenever the local catalog hash differs from the last published hash.
6. **Unpublish** is a destructive, confirmed remote request. It should replace
   the guest page with a friendly unavailable page, rather than serving an
   object-storage 404.

Preview and publishing require internet. If it disappears, the rest of Agora
continues working locally; this feature shows an actionable offline state and
does not queue a stale catalog for later automatic publication.

## Deferred backend contract

The cloud service is a small multi-tenant **public-menu publisher**, separate
from the local LAN `sync_hub`. It holds public snapshots and publisher
capabilities; it never receives orders, stock, customer data, or a copy of the
local Drift database.

### Authentication and ownership

This is intentionally capability-based, not user-account-based in v1.

- On first creation, the client generates a cryptographically random owner
  secret. It sends the secret over HTTPS only for `POST /v1/menus`; the server
  stores a slow/hash-derived verifier, never the plaintext.
- The server returns a random `menuId`, an unguessable public slug, and the
  original owner secret remains only in secure client storage.
- `PUT` and `DELETE` require the owner secret. The capability is scoped to one
  menu and permits only update/unpublish of that menu.
- A stable device ID is not an authenticator. It may be used only as a
  best-effort rate-limit signal. No Apple App Attest or Google Play Integrity
  is required for v1.
- Menu creation is intentionally open to app clients, so control abuse at the
  perimeter: WAF/bot protection, IP/device rate limits, strict payload and
  image quotas, lifecycle expiry, and admin takedown. These controls limit
  cost; they do not establish personal identity.

Use HTTPS for all API and public-page traffic. Never place the owner capability
in a URL, query string, local database, crash report, or analytics event.

### API

All write bodies are JSON, validated against a versioned schema. The server
must HTML-escape all text fields and only render templates it owns.

| Endpoint | Auth | Purpose |
|---|---|---|
| `GET /v1/menu-templates` | none | Return active template metadata and current versions. CDN-cache this response. |
| `POST /v1/menu-previews` | none + abuse limits | Validate `{templateId, templateVersion, snapshot}`; return an unguessable temporary preview URL and expiry. |
| `POST /v1/menus` | new client-generated owner capability + abuse limits | Create a permanent menu and render/store its first published snapshot. |
| `PUT /v1/menus/{menuId}` | owner capability | Validate, replace the public snapshot atomically, and return unchanged public URL plus publication metadata. |
| `DELETE /v1/menus/{menuId}` | owner capability | Unpublish/revoke the public menu. |
| `GET /m/{publicSlug}` | none | Guest-facing static menu document. |

For a simpler initial transport, the owner capability can be an
`Authorization: Bearer` value. Treat it as a password: high entropy, scoped,
never logged, and rate-limited. A later keypair/request-signature scheme can
reduce bearer-token replay risk without changing the product UX.

`POST /v1/menu-previews` should return a URL such as
`https://preview.menu.agora.it/p/<opaque-token>`, valid for 10–30 minutes.
This permits the WebView to load normal HTTPS assets. Preview inputs should be
discarded at expiry and must never be discoverable, indexed, or cached as a
public menu.

### Renderer, templates, and immutable publication versions

The server maps `(templateId, templateVersion, snapshot)` to the final HTML;
the renderer is the single source of truth for both preview and publication.
It may run in an edge/serverless worker, then write immutable HTML/CSS/assets
to object storage/CDN. Guests only read static files.

Pin the renderer/template version in each publication. A new template version
must not restyle an already public menu silently. The host explicitly selects
the newer version and republishes to adopt it.

Template metadata returned to the app should contain only selection/preview
information, for example:

```json
{
  "id": "rustic-festival",
  "version": 3,
  "name": "Rustic festival",
  "description": "Warm, large type for outdoor reading",
  "thumbnailUrl": "https://assets.menu.agora.it/templates/rustic-v3.png",
  "options": ["subtitle", "descriptions", "categoryIcons", "disclaimer"]
}
```

Do not send executable template code to the app. This avoids duplicated
rendering logic, remote-code lifecycle/security concerns, and pixel drift
between the preview and the guest-facing page.

### Image follow-up

When custom local product photos are needed, add a separate, bounded asset
flow rather than putting image bytes or device paths in `PublicMenuSnapshot`:

1. the app requests a short-lived, menu-scoped upload URL;
2. it resizes/compresses a local photo within defined dimensions/size;
3. it uploads the asset to the server-controlled object store;
4. the snapshot references the returned immutable asset ID.

Preview assets live in an expiring namespace; published assets share the
publication lifecycle. Reject arbitrary remote image URLs and SVG/HTML uploads
in v1. This follow-up must be designed before enabling custom photos in the
public menu UI.

## Build order

1. Agree the backend schema, endpoint error format, rate limits, expiry policy,
   template metadata contract, and public `menu.agora.it` domain. Implement
   the service independently; this repository gets no `backend/` or
   `sync_hub/` changes for it.
2. Add client domain models, snapshot builder, configuration persistence, and
   secure capability store. Unit-test visibility filtering and ensure private
   catalog fields cannot enter the snapshot.
3. Add template-manifest repository with cache, template gallery, and local
   configuration form.
4. Add preview API integration and WebView sheet. Test loading, expiry, error,
   offline, and a representative mobile viewport.
5. Add create/update/unpublish integration, QR generation, share sheet, and
   poster/PDF export. Preserve the stable URL through updates.
6. Add photo asset upload only after its bounded server contract is available.

## Acceptance criteria

- A host can go from an existing local catalog to a usable QR in one explicit
  publish flow, without creating an account.
- The preview and published page use the same template version and snapshot;
  a representative visual regression test proves they agree.
- Updating prices/items locally does not alter the public page until the host
  explicitly updates it; after an update, the public URL and QR remain the
  same.
- The server rejects malformed/oversize snapshots, unknown template versions,
  and writes without the matching owner capability.
- A guest can open the public URL on an ordinary mobile browser without
  Agora installed or access to the event LAN.
- Unpublishing makes the guest URL safely unavailable and deletes/marks for
  deletion the related snapshot/assets according to the retention policy.

## Open questions before implementation

- What retention policy balances event history with storage cost: auto-expire
  after 30, 90, or 365 days, and should a host be able to extend it?
- Does an active product with a disabled category always stay hidden in the
  POS? The snapshot builder should match the current POS filtering exactly;
  add a regression test for that rule before implementation.
- Is the initial audience Italian-only? If so, template copy, currency, and
  mandatory allergen wording can be designed for Italy first rather than
  prematurely localised.
- What recovery experience is appropriate after an uninstall/device change?
  The v1 answer can be “the menu remains public but cannot be updated”; an
  optional email magic link is the likely later solution.
