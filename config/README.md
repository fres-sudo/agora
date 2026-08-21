# Environment configuration

This directory holds the per-environment configuration consumed by the Flutter
app at **build time** via `--dart-define-from-file`.

```bash
fvm flutter run \
  --flavor dev \
  --dart-define-from-file=config/dev.json \
  -t apps/agora/lib/main.dart
```

> The values are read in Dart through `AppConfig.fromEnvironment()` in
> `packages/config`. The canonical key names live in
> `packages/config/lib/src/config_keys.dart` — keep the two in sync.

## Files

| File | Flavor | Mode | Default tier | Purpose |
|---|---|---|---|---|
| `local.json` | `dev` | `local` | `free` | Fully offline free-tier POS. No backend. |
| `dev.json` | `dev` | `hybrid` | `paidPro` | Local backend (`localhost:3000`), all features on. |
| `staging.json` | `staging` | `hybrid` | `paidPro` | Pre-production / QA backend. |
| `prod.json` | `prod` | `hybrid` | `free` | Production build. |

Only the `*.example` files are committed. **Copy them to the real names** (which
are git-ignored) and adjust per machine:

```bash
for e in local dev staging prod; do
  [ -f "config/$e.json" ] || cp "config/$e.json.example" "config/$e.json"
done
```

## Keys

| Key | Type | Meaning |
|---|---|---|
| `FLAVOR` | string | Build flavor: `dev` \| `staging` \| `prod`. Must match `--flavor`. |
| `APP_NAME` | string | App/window title. |
| `API_BASE_URL` | string | REST API base URL. Empty when `BOOTSTRAP_MODE=local`. |
| `PUBLIC_MENU_API_BASE_URL` | string | Public-menu publisher API base URL. Empty disables public menu publishing. |
| `WS_BASE_URL` | string | Realtime websocket URL. Empty when `BOOTSTRAP_MODE=local`. |
| `BOOTSTRAP_MODE` | string | `local` (offline) \| `hybrid` (backend-connected). |
| `TIER` | string | Default subscription tier: `free` \| `paidBasic` \| `paidPro`. |
| `ENABLE_LOGGING` | bool | Verbose Talker logging. |
| `ENABLE_INSPECTOR` | bool | In-app debug inspector. |
| `SUMUP_AFFILIATE_KEY` | string | Reader SDK affiliate key. Empty disables card payments. |

## Flavor vs tier

`FLAVOR` controls the **native build** (application id, app name, icon).
`TIER` controls **runtime entitlements** (free vs premium features) and is owned
by `packages/feature_flags`. They are independent: e.g. the production flavor
ships with `TIER=free` by default, and a paid subscription would raise the tier
at runtime. The tier can also be overridden locally for QA via the
`FeatureFlagsCubit`.

See `docs/ENVIRONMENTS.md` for the full guide and VS Code launch configs.
