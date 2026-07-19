// Invoked by .scripts/generate_icons.dart. Reads a JSON manifest of
// [{ src, dest }] jobs from stdin, converts each stroke-based SVG into a
// filled-path SVG (icon fonts have no stroke concept — only fill geometry
// survives conversion), and writes the result to `dest`.
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname } from 'node:path';
import outlineStroke from 'svg-outline-stroke';
import { fixWinding } from './fix_winding.mjs';

// svg-outline-stroke rasterizes then traces (potrace). Tracing straight off
// a 24x24 raster produces mushy, over-rounded corners, so we upscale the
// SVG's declared width/height before rasterizing and rely on fantasticon's
// per-glyph normalization to scale it back down — no downscale step needed.
const RASTER_SCALE = 20;

function upscale(svg) {
  return svg
    .replace(/width="([\d.]+)"/, (_, n) => `width="${parseFloat(n) * RASTER_SCALE}"`)
    .replace(/height="([\d.]+)"/, (_, n) => `height="${parseFloat(n) * RASTER_SCALE}"`);
}

function readManifest() {
  return new Promise((resolve, reject) => {
    let data = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => (data += chunk));
    process.stdin.on('end', () => resolve(JSON.parse(data)));
    process.stdin.on('error', reject);
  });
}

const jobs = await readManifest();

for (const { src, dest } of jobs) {
  const original = readFileSync(src, 'utf8');
  const outlined = await outlineStroke(upscale(original), {
    color: '#282930',
    turdSize: 0,
    optTolerance: 0.1,
  });

  // potrace emits multi-contour icons (holes, nested frames) as a single
  // evenodd path. The font pipeline downstream (svgicons2svgfont/svg2ttf)
  // ignores fill-rule entirely, so we bake the winding correction in now.
  const fixed = outlined
    .replace(/d="([^"]+)"/, (_, d) => `d="${fixWinding(d)}"`)
    .replace(/\s*fill-rule="evenodd"/, '');

  mkdirSync(dirname(dest), { recursive: true });
  writeFileSync(dest, fixed);
}

console.log(`Outlined ${jobs.length} SVG(s).`);
