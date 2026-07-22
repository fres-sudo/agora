# Agora brand assets

The app mark is a simplified festival canopy that reads as an **A**. It is a
deliberately practical symbol for a village food stand: recognisable at small
sizes, independent of language, and distinct from restaurant and payment-app
visual conventions.

## Visual rules

- Canvas: `#141414` (the UI kit's `neutral900` / light-theme primary).
- Mark: `#FAFAFA` (`neutral50`) for reliable outdoor contrast.
- Accent: `#FFAB00` (`warning500`) only for the sun/plate; it is not an action
  colour in the product UI.
- Wordmark: Inter 700, echoing the UI kit's Inter display type.
- Do not add gradients, shadows, food illustrations, or extra brand colours.

## Source and generated files

- `source/` contains the editable SVG masters.
- `app_icon_1024.png`, `app_icon_foreground.png`, `app_icon_monochrome.png`,
  `logo.png`, `branding.png`, and `branding_android.png` are Flutter-ready
  raster inputs.
- `platforms/` contains platform-sized exports. It is intentionally separate
  from platform runners so macOS/Linux/Windows assets are ready before those
  runners are enabled in this Flutter app.

Run `./tool/generate_brand_assets.sh` from `apps/agora` after changing a source
SVG. It regenerates every raster asset and installs the Android, iOS, web, and
flavour files that exist in this repository.
