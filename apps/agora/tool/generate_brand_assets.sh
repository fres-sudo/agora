#!/bin/zsh
set -euo pipefail

cd "${0:A:h:h}"

brand_dir="assets/brand"
source_dir="$brand_dir/source"
platforms_dir="$brand_dir/platforms"
render_dir=$(mktemp -d /private/tmp/agora-brand.XXXXXX)
trap 'rm -rf "$render_dir"' EXIT

mkdir -p "$platforms_dir"/{android,ios,web,macos,linux,windows,splash}

render_svg() {
  local source="$1"
  local output="$2"
  # sips preserves the SVG's explicit canvas dimensions, unlike Quick Look's
  # square thumbnail previews. Platform-specific sizing happens below.
  sips -s format png "$source" --out "$output" >/dev/null
}

resize_png() {
  local source="$1"
  local size="$2"
  local output="$3"
  sips -z "$size" "$size" "$source" --out "$output" >/dev/null
}

resize_long_edge() {
  local source="$1"
  local size="$2"
  local output="$3"
  sips -Z "$size" "$source" --out "$output" >/dev/null
}

prepare_splash_branding() {
  local source="$1"
  local output="$2"
  local pad_color="$3"
  local cropped="$render_dir/$(basename "$source" .png)-cropped.png"
  local scaled="$render_dir/$(basename "$source" .png)-scaled.png"

  # Scale the 1600x360 vector export without distortion, then place it
  # centrally in flutter_native_splash's documented 800x320 branding frame.
  sips -Z 800 "$source" --out "$scaled" >/dev/null
  sips -p 320 800 --padColor "$pad_color" "$scaled" --out "$output" >/dev/null
}

# The SVG masters are the single source of truth. Raster files are only
# platform exports; use light assets on #FFFFFF and dark assets on #0A0A0A.
render_svg "$source_dir/agora-icon.svg" "$brand_dir/app_icon_1024.png"
render_svg "$source_dir/agora-icon-on-light.svg" "$brand_dir/app_icon_light_1024.png"
render_svg "$source_dir/agora-adaptive-foreground.svg" "$brand_dir/app_icon_foreground.png"
render_svg "$source_dir/agora-monochrome.svg" "$brand_dir/app_icon_monochrome.png"
render_svg "$source_dir/agora-mark.svg" "$brand_dir/logo_light.png"
render_svg "$source_dir/agora-mark-on-dark.svg" "$brand_dir/logo_dark.png"
render_svg "$source_dir/agora-branding.svg" "$brand_dir/branding_light.png"
render_svg "$source_dir/agora-branding-on-dark.svg" "$brand_dir/branding_dark.png"
prepare_splash_branding "$brand_dir/branding_light.png" "$brand_dir/branding_light.png" FFFFFF
prepare_splash_branding "$brand_dir/branding_dark.png" "$brand_dir/branding_dark.png" 0A0A0A

# Retain current Flutter asset names while native_splash uses the explicit
# appearance-aware filenames below.
cp "$brand_dir/logo_dark.png" "$brand_dir/logo.png"
cp "$brand_dir/branding_dark.png" "$brand_dir/branding.png"
cp "$brand_dir/branding_dark.png" "$brand_dir/branding_android.png"

for mode in light dark; do
  resize_png "$brand_dir/logo_${mode}.png" 512 "$platforms_dir/splash/logo-${mode}-512.png"
  resize_png "$brand_dir/logo_${mode}.png" 1024 "$platforms_dir/splash/logo-${mode}-1024.png"
  cp "$brand_dir/branding_${mode}.png" "$platforms_dir/splash/branding-${mode}-800x320.png"
done

cp "$platforms_dir/splash/logo-light-1024.png" "$brand_dir/splash_logo_light.png"
cp "$platforms_dir/splash/logo-dark-1024.png" "$brand_dir/splash_logo_dark.png"
resize_png "$brand_dir/app_icon_light_1024.png" 960 "$brand_dir/android12_splash_icon_light.png"
resize_png "$brand_dir/app_icon_1024.png" 960 "$brand_dir/android12_splash_icon_dark.png"
cp "$platforms_dir/splash/branding-light-800x320.png" "$brand_dir/splash_branding_light.png"
cp "$platforms_dir/splash/branding-dark-800x320.png" "$brand_dir/splash_branding_dark.png"

# Android legacy launchers and adaptive foreground density buckets.
for spec in "mdpi 48 108" "hdpi 72 162" "xhdpi 96 216" "xxhdpi 144 324" "xxxhdpi 192 432"; do
  parts=(${=spec})
  resize_png "$brand_dir/app_icon_1024.png" "${parts[2]}" "$platforms_dir/android/ic_launcher_${parts[1]}.png"
  resize_png "$brand_dir/app_icon_foreground.png" "${parts[3]}" "$platforms_dir/android/ic_launcher_foreground_${parts[1]}.png"
  resize_png "$brand_dir/app_icon_monochrome.png" "${parts[3]}" "$platforms_dir/android/ic_launcher_monochrome_${parts[1]}.png"
done

# iOS/iPadOS required point-scale combinations (filenames mirror Xcode assets).
for size in 20 29 40 58 60 76 80 87 120 152 167 180 1024; do
  resize_png "$brand_dir/app_icon_1024.png" "$size" "$platforms_dir/ios/Icon-App-${size}.png"
done

# PWA and favicon sizes; maskable icons retain the safe-area foreground.
for size in 16 32 192 512; do
  resize_png "$brand_dir/app_icon_1024.png" "$size" "$platforms_dir/web/Icon-${size}.png"
  resize_png "$brand_dir/app_icon_foreground.png" "$size" "$platforms_dir/web/Icon-maskable-${size}.png"
done

# Desktop distribution export sizes. The app does not currently include
# desktop runners, so these remain clean drop-in exports rather than new apps.
for size in 16 32 64 128 256 512 1024; do
  resize_png "$brand_dir/app_icon_1024.png" "$size" "$platforms_dir/macos/icon_${size}x${size}.png"
done
for size in 16 24 32 48 64 128 256 512; do
  resize_png "$brand_dir/app_icon_1024.png" "$size" "$platforms_dir/linux/agora_${size}x${size}.png"
done
for size in 16 20 24 30 32 36 40 48 60 64 72 80 96 128 256; do
  resize_png "$brand_dir/app_icon_1024.png" "$size" "$platforms_dir/windows/agora_${size}x${size}.png"
done
sips -s format ico "$platforms_dir/windows/agora_256x256.png" --out "$platforms_dir/windows/Agora.ico" >/dev/null

iconset_dir="$platforms_dir/macos/Agora.iconset"
mkdir -p "$iconset_dir"
cp "$platforms_dir/macos/icon_16x16.png" "$iconset_dir/icon_16x16.png"
cp "$platforms_dir/macos/icon_32x32.png" "$iconset_dir/icon_16x16@2x.png"
cp "$platforms_dir/macos/icon_32x32.png" "$iconset_dir/icon_32x32.png"
cp "$platforms_dir/macos/icon_64x64.png" "$iconset_dir/icon_32x32@2x.png"
cp "$platforms_dir/macos/icon_128x128.png" "$iconset_dir/icon_128x128.png"
cp "$platforms_dir/macos/icon_256x256.png" "$iconset_dir/icon_128x128@2x.png"
cp "$platforms_dir/macos/icon_256x256.png" "$iconset_dir/icon_256x256.png"
cp "$platforms_dir/macos/icon_512x512.png" "$iconset_dir/icon_256x256@2x.png"
cp "$platforms_dir/macos/icon_512x512.png" "$iconset_dir/icon_512x512.png"
cp "$platforms_dir/macos/icon_1024x1024.png" "$iconset_dir/icon_512x512@2x.png"
iconutil -c icns "$iconset_dir" -o "$platforms_dir/macos/Agora.icns"

# Apply files to platforms already enabled in the repository.
cp "$platforms_dir/web/Icon-192.png" web/icons/Icon-192.png
cp "$platforms_dir/web/Icon-512.png" web/icons/Icon-512.png
cp "$platforms_dir/web/Icon-maskable-192.png" web/icons/Icon-maskable-192.png
cp "$platforms_dir/web/Icon-maskable-512.png" web/icons/Icon-maskable-512.png
cp "$platforms_dir/web/Icon-32.png" web/favicon.png

for flavor in main dev staging prod; do
  target="android/app/src/$flavor/res"
  [[ "$flavor" == "main" ]] && target="android/app/src/main/res"
  for spec in "mdpi 48" "hdpi 72" "xhdpi 96" "xxhdpi 144" "xxxhdpi 192"; do
    parts=(${=spec})
    mkdir -p "$target/mipmap-${parts[1]}"
    cp "$platforms_dir/android/ic_launcher_${parts[1]}.png" "$target/mipmap-${parts[1]}/ic_launcher.png"
  done
done

for set in AppIcon.appiconset AppIcon-dev.appiconset AppIcon-staging.appiconset AppIcon-prod.appiconset; do
  target="ios/Runner/Assets.xcassets/$set"
  [[ -d "$target" ]] || continue
  for target_file in "$target"/*.png(N); do
    filename="${target_file:t}"
    pixel_size=$(print -r -- "$filename" | sed -E 's/.*-([0-9]+)(\.5)?x.*@([123])x\.png/\1:\2:\3/' | awk -F: '{ printf "%d", $1 * $3 + (($2 == ".5") ? ($3 / 2) : 0) }')
    [[ "$filename" == *1024* ]] && pixel_size=1024
    cp "$platforms_dir/ios/Icon-App-${pixel_size}.png" "$target/$filename"
  done
done

# flutter_native_splash owns the iOS/Android/Web light and dark splash resource
# sets. Run its generator after this script to install both modes from
# native_splash.yaml.
echo "Agora brand assets generated. Run flutter_native_splash next."
