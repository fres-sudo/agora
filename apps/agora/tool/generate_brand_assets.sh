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
  # macOS ships an SVG-capable Quick Look renderer. Render masters once at 2x
  # and downsample with sips; this keeps every platform export sharp.
  qlmanage -t -s 2048 -o "$render_dir" "$source" >/dev/null
  cp "$render_dir/$(basename "$source").png" "$output"
}

resize_png() {
  local source="$1"
  local size="$2"
  local output="$3"
  sips -z "$size" "$size" "$source" --out "$output" >/dev/null
}

render_svg "$source_dir/agora-icon.svg" "$brand_dir/app_icon_1024.png"
render_svg "$source_dir/agora-mark.svg" "$brand_dir/app_icon_foreground.png"
render_svg "$source_dir/agora-monochrome.svg" "$brand_dir/app_icon_monochrome.png"
render_svg "$source_dir/agora-mark.svg" "$brand_dir/logo.png"
render_svg "$source_dir/agora-branding.svg" "$brand_dir/branding.png"
render_svg "$source_dir/agora-branding.svg" "$brand_dir/branding_android.png"

# Keep splash art image-based rather than screen-size-based: each native shell
# supplies the #141414 field and centres these transparent images responsively.
resize_png "$brand_dir/logo.png" 512 "$platforms_dir/splash/mark-512.png"
resize_png "$brand_dir/logo.png" 1024 "$platforms_dir/splash/mark-1024.png"
resize_png "$brand_dir/branding.png" 1024 "$platforms_dir/splash/branding-1024.png"

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

for set in LaunchImage.imageset devLaunchImage.imageset stagingLaunchImage.imageset prodLaunchImage.imageset; do
  target="ios/Runner/Assets.xcassets/$set"
  [[ -d "$target" ]] || continue
  cp "$platforms_dir/splash/mark-512.png" "$target/LaunchImage.png"
  cp "$platforms_dir/splash/mark-512.png" "$target/LaunchImage@2x.png"
  cp "$platforms_dir/splash/mark-1024.png" "$target/LaunchImage@3x.png"
done

echo "Agora brand assets generated."
