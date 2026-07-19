// Rewinds a potrace-traced SVG path's subpaths so a nonzero fill-rule
// reproduces the same result as evenodd (which is what potrace emits).
// TrueType glyph outlines have no fill-rule concept — they're effectively
// nonzero-only — so an evenodd-only path with holes (e.g. a hexagon nut
// icon, or a picture-in-picture icon's inner + outer frame) loses those
// holes once converted into a font glyph unless the winding is corrected
// here first.
export function parsePath(d) {
  const tokens = d.match(/[MLCZmlcz]|-?\d*\.?\d+(?:e-?\d+)?/g) || [];
  let i = 0;
  const subpaths = [];
  let current = null;
  let cur = [0, 0];
  const isNum = (t) => t !== undefined && /^-?\d/.test(t);
  const readPoint = () => {
    const x = parseFloat(tokens[i++]);
    const y = parseFloat(tokens[i++]);
    return [x, y];
  };
  while (i < tokens.length) {
    const tok = tokens[i];
    if (tok === 'M' || tok === 'm') {
      i++;
      const p = readPoint();
      if (current) subpaths.push(current);
      current = { start: p, segments: [] };
      cur = p;
      while (isNum(tokens[i])) {
        const p2 = readPoint();
        current.segments.push({ type: 'L', end: p2 });
        cur = p2;
      }
    } else if (tok === 'C' || tok === 'c') {
      i++;
      while (isNum(tokens[i])) {
        const c1 = readPoint();
        const c2 = readPoint();
        const end = readPoint();
        current.segments.push({ type: 'C', c1, c2, end });
        cur = end;
      }
    } else if (tok === 'L' || tok === 'l') {
      i++;
      while (isNum(tokens[i])) {
        const end = readPoint();
        current.segments.push({ type: 'L', end });
        cur = end;
      }
    } else if (tok === 'Z' || tok === 'z') {
      i++;
      if (current && (cur[0] !== current.start[0] || cur[1] !== current.start[1])) {
        current.segments.push({ type: 'L', end: current.start });
      }
    } else {
      i++;
    }
  }
  if (current) subpaths.push(current);
  return subpaths;
}

function cubicPoint(p0, p1, p2, p3, t) {
  const mt = 1 - t;
  const x = mt * mt * mt * p0[0] + 3 * mt * mt * t * p1[0] + 3 * mt * t * t * p2[0] + t * t * t * p3[0];
  const y = mt * mt * mt * p0[1] + 3 * mt * mt * t * p1[1] + 3 * mt * t * t * p2[1] + t * t * t * p3[1];
  return [x, y];
}

function flatten(sp, steps = 12) {
  const pts = [sp.start];
  let prev = sp.start;
  for (const seg of sp.segments) {
    if (seg.type === 'L') {
      pts.push(seg.end);
      prev = seg.end;
    } else {
      for (let t = 1; t <= steps; t++) {
        pts.push(cubicPoint(prev, seg.c1, seg.c2, seg.end, t / steps));
      }
      prev = seg.end;
    }
  }
  return pts;
}

function signedArea(pts) {
  let a = 0;
  for (let i = 0; i < pts.length; i++) {
    const [x1, y1] = pts[i];
    const [x2, y2] = pts[(i + 1) % pts.length];
    a += x1 * y2 - x2 * y1;
  }
  return a / 2;
}

function pointInPolygon(pt, poly) {
  let inside = false;
  for (let i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    const xi = poly[i][0], yi = poly[i][1];
    const xj = poly[j][0], yj = poly[j][1];
    const intersect = (yi > pt[1]) !== (yj > pt[1]) &&
      pt[0] < ((xj - xi) * (pt[1] - yi)) / (yj - yi) + xi;
    if (intersect) inside = !inside;
  }
  return inside;
}

function reverseSubpath(sp) {
  const verts = [sp.start, ...sp.segments.map((s) => s.end)];
  const n = sp.segments.length;
  const newStart = verts[n];
  const newSegments = [];
  for (let i = n - 1; i >= 0; i--) {
    const seg = sp.segments[i];
    const endPoint = verts[i];
    if (seg.type === 'C') {
      newSegments.push({ type: 'C', c1: seg.c2, c2: seg.c1, end: endPoint });
    } else {
      newSegments.push({ type: 'L', end: endPoint });
    }
  }
  return { start: newStart, segments: newSegments };
}

function fmt(n) {
  return Number(n.toFixed(3)).toString();
}

function subpathsToD(subpaths) {
  return subpaths
    .map((sp) => {
      let d = `M${fmt(sp.start[0])} ${fmt(sp.start[1])}`;
      for (const seg of sp.segments) {
        if (seg.type === 'C') {
          d += ` C${fmt(seg.c1[0])} ${fmt(seg.c1[1])} ${fmt(seg.c2[0])} ${fmt(seg.c2[1])} ${fmt(seg.end[0])} ${fmt(seg.end[1])}`;
        } else {
          d += ` L${fmt(seg.end[0])} ${fmt(seg.end[1])}`;
        }
      }
      return d;
    })
    .join(' ');
}

export function fixWinding(d) {
  const subpaths = parsePath(d);
  if (subpaths.length <= 1) return d;

  const flattened = subpaths.map((sp) => flatten(sp));
  const areas = flattened.map((pts) => signedArea(pts));
  // A vertex on the subpath's own boundary — not its centroid. Concentric
  // contours (e.g. a picture-in-picture icon's outer frame + inner frame)
  // share nearly the same centroid, which makes centroid-based containment
  // ambiguous; a boundary point unambiguously belongs to exactly this ring.
  const samplePoints = subpaths.map((sp) => sp.start);

  const depths = subpaths.map((_, idx) => {
    let depth = 0;
    for (let j = 0; j < subpaths.length; j++) {
      if (j === idx) continue;
      if (pointInPolygon(samplePoints[idx], flattened[j])) depth++;
    }
    return depth;
  });

  const fixed = subpaths.map((sp, idx) => {
    const desiredPositive = depths[idx] % 2 === 0;
    const isPositive = areas[idx] > 0;
    return isPositive === desiredPositive ? sp : reverseSubpath(sp);
  });

  return subpathsToD(fixed);
}
