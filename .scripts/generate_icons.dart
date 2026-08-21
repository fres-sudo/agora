import 'dart:convert';
import 'dart:io';

/// Paths — run from the repo root (`dart run .scripts/generate_icons.dart`).
const _svgSourceDir = 'assets/icons';
const _fontOutputFile = 'packages/ui_kit/assets/fonts/AgoraIcons.ttf';
const _classOutputFile = 'packages/ui_kit/lib/src/theme/agora_icons.dart';
const _fontName = 'AgoraIcons';
const _className = _fontName;
const _packageName = 'ui_kit';

/// Style subfolders under [_svgSourceDir]. Each contains the same base set of
/// kebab-case SVGs (e.g. `alert-circle.svg`). `line` is the "regular" style
/// and is emitted without a suffix; the rest are suffixed with their style
/// name (material-style: `alert_circle_bulk`, `alert_circle_solid`, ...).
const _regularStyle = 'line';
const _iconStyles = [_regularStyle, 'bulk', 'solid', 'twotone'];

/// Some SVGs (primarily `line` and `twotone`) are authored as strokes.
/// Icon fonts have no stroke concept, so every stroke-based source must be
/// outlined into filled paths before it is passed to `icon_font_generator`.
const _nodeToolsDir = '.scripts/node';

void main() async {
  final stopwatch = Stopwatch()..start();
  stdout.writeln('🔧 [generate_icons] Starting icon font generation...');

  _validateSvgSource();

  final mergedDir = await Directory.systemTemp.createTemp('agora_icons_');
  try {
    final count = await _populateMergedSource(mergedDir);
    stdout.writeln(
        '📦 Merged $count SVG(s) from ${_iconStyles.length} style(s) into a temp source dir.');

    _validateMergedSource(mergedDir, count);

    _ensureOutputDirs();
    await _generateIconFont(mergedDir.path);
  } finally {
    await mergedDir.delete(recursive: true);
  }

  stopwatch.stop();
  stdout.writeln('✅ [generate_icons] Done in ${stopwatch.elapsed.inSeconds}s.');
  stdout.writeln(
      '   AgoraIcons is exported from package:ui_kit — re-run `melos bootstrap` if this is a fresh checkout.');
}

/// Validates that each style subdirectory exists and contains SVG files.
void _validateSvgSource() {
  final sourceDir = Directory(_svgSourceDir);
  if (!sourceDir.existsSync()) {
    stderr.writeln('❌ Source directory "$_svgSourceDir" not found.');
    exit(1);
  }

  for (final style in _iconStyles) {
    final styleDir = Directory('$_svgSourceDir/$style');
    if (!styleDir.existsSync()) {
      stderr.writeln('❌ Style directory "${styleDir.path}" not found.');
      exit(1);
    }

    final svgs = styleDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.svg'))
        .toList();

    if (svgs.isEmpty) {
      stderr.writeln('⚠️  No SVG files found in "${styleDir.path}". Aborting.');
      exit(1);
    }

    stdout
        .writeln('📂 Found ${svgs.length} SVG file(s) in "${styleDir.path}".');
  }
}

/// Copies every style's SVGs into [mergedDir] with a snake_case name and a
/// material-style suffix (e.g. `alert_circle_bulk.svg`), except for
/// [_regularStyle] which is copied without a suffix (`alert_circle.svg`).
///
/// Returns the total number of files copied.
Future<int> _populateMergedSource(Directory mergedDir) async {
  var count = 0;
  final outlineJobs = <_OutlineJob>[];
  final outputNames = <String>{};

  for (final style in _iconStyles) {
    final styleDir = Directory('$_svgSourceDir/$style');
    final suffix = style == _regularStyle ? '' : '_$style';

    final svgs = styleDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.svg'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final svg in svgs) {
      final baseName = _toSnakeCase(_baseNameWithoutExtension(svg.path));
      final destPath = '${mergedDir.path}/$baseName$suffix.svg';

      if (!outputNames.add(_baseNameWithoutExtension(destPath))) {
        stderr.writeln(
            '❌ Multiple source SVGs resolve to "${_baseNameWithoutExtension(destPath)}".');
        exit(1);
      }

      if (_isStrokeBased(svg)) {
        outlineJobs.add(_OutlineJob(svg.absolute.path, destPath));
      } else {
        svg.copySync(destPath);
      }
      count++;
    }
  }

  if (outlineJobs.isNotEmpty) {
    await _outlineStrokes(outlineJobs);
  }

  return count;
}

/// An SVG needs outlining if it contains a paintable stroke. Sources that are
/// already expressed entirely as filled geometry are copied as-is.
bool _isStrokeBased(File svg) =>
    RegExp(r'''stroke\s*=\s*["'](?!none["'])''', caseSensitive: false)
        .hasMatch(svg.readAsStringSync());

/// Guards the exact boundary consumed by the font generator. A remaining
/// stroke would either disappear or be interpreted as an incorrectly filled
/// open path, depending on the SVG parser used downstream.
void _validateMergedSource(Directory mergedDir, int expectedCount) {
  final svgs = mergedDir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.toLowerCase().endsWith('.svg'))
      .toList();

  if (svgs.length != expectedCount) {
    stderr.writeln(
        '❌ Expected $expectedCount merged SVGs, but found ${svgs.length}.');
    exit(1);
  }

  final stroked = svgs.where(_isStrokeBased).toList();
  if (stroked.isNotEmpty) {
    stderr.writeln(
        '❌ ${stroked.length} merged SVG(s) still contain paintable strokes.');
    for (final file in stroked.take(10)) {
      stderr.writeln('   ${file.path}');
    }
    exit(1);
  }

  stdout.writeln('  ✓ Validated $expectedCount fill-only SVG source(s).');
}

class _OutlineJob {
  _OutlineJob(this.src, this.dest);
  final String src;
  final String dest;
}

/// Converts every stroke-based SVG to a filled-path SVG by shelling
/// out to `.scripts/node/outline_stroke.mjs` (uses the `svg-outline-stroke`
/// npm package, which rasterizes then re-traces the stroke as a fill, then
/// corrects contour winding so holes survive conversion to a font glyph).
Future<void> _outlineStrokes(List<_OutlineJob> jobs) async {
  stdout.writeln(
      '🖊  Outlining ${jobs.length} stroke-based SVG(s) into filled paths...');

  await _ensureNodeToolsInstalled();

  final process = await Process.start(
    'node',
    ['outline_stroke.mjs'],
    workingDirectory: _nodeToolsDir,
    runInShell: true,
  );

  process.stdin.write(jsonEncode([
    for (final job in jobs) {'src': job.src, 'dest': job.dest},
  ]));
  await process.stdin.close();

  await stdout.addStream(process.stdout);
  final stderrOutput = await process.stderr.transform(utf8.decoder).join();
  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    stderr.writeln(stderrOutput);
    stderr.writeln('❌ outline_stroke.mjs failed (exit $exitCode).');
    exit(exitCode);
  }
}

/// Runs `npm install` in [_nodeToolsDir] the first time it's needed.
Future<void> _ensureNodeToolsInstalled() async {
  if (Directory('$_nodeToolsDir/node_modules').existsSync()) return;

  stdout.writeln(
      '📦 Installing node tooling for stroke outlining (svg-outline-stroke)...');
  final result = await Process.run(
    'npm',
    ['install', '--no-fund'],
    workingDirectory: _nodeToolsDir,
    runInShell: true,
  );

  if (result.exitCode != 0) {
    stdout.write(result.stdout);
    stderr.writeln(result.stderr);
    stderr.writeln('❌ npm install failed in "$_nodeToolsDir".');
    exit(result.exitCode);
  }
}

/// Returns the file name without its directory path or extension.
String _baseNameWithoutExtension(String path) {
  final fileName = path.split(Platform.pathSeparator).last;
  final dotIndex = fileName.lastIndexOf('.');
  return dotIndex == -1 ? fileName : fileName.substring(0, dotIndex);
}

const _digitWords = {
  '0': 'zero',
  '1': 'one',
  '2': 'two',
  '3': 'three',
  '4': 'four',
  '5': 'five',
  '6': 'six',
  '7': 'seven',
  '8': 'eight',
  '9': 'nine',
};

/// Converts a kebab-case (or otherwise dashed) name to snake_case.
///
/// Dart identifiers can't start with a digit, so a leading run of digits
/// (e.g. `3d-cube-scan` → `3d_cube_scan`) is spelled out as words, mirroring
/// how Flutter's own Material Icons handle this (`Icons.three_d_rotation`).
String _toSnakeCase(String name) {
  final snake = name.replaceAll('-', '_').toLowerCase();

  final leadingDigits = RegExp(r'^[0-9]+').firstMatch(snake)?.group(0);
  if (leadingDigits == null) return snake;

  final words = leadingDigits.split('').map((d) => _digitWords[d]).join('_');
  final rest = snake.substring(leadingDigits.length);
  return rest.isEmpty ? words : '${words}_$rest';
}

/// Creates output directories if they do not already exist.
void _ensureOutputDirs() {
  for (final path in [
    'packages/ui_kit/assets/fonts',
    'packages/ui_kit/lib/src/theme'
  ]) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }
}

/// Runs `icon_font_generator` against the merged SVG source directory.
///
/// Requires Node.js — the generator shells out to the `fantasticon` npm
/// package to rasterize the font.
Future<void> _generateIconFont(String sourceDir) async {
  stdout.writeln('🔠 Running icon_font_generator...');

  final outputDir = await Directory.systemTemp.createTemp('agora_icon_font_');
  final generatedFont = '${outputDir.path}/AgoraIcons.ttf';
  final generatedClass = '${outputDir.path}/agora_icons.dart';

  final args = [
    'run',
    'icon_font_generator',
    '--from=$sourceDir',
    '--out-font=$generatedFont',
    '--out-flutter=$generatedClass',
    '--class-name=$_className',
    '--package=$_packageName',
    '--naming-strategy=snake',
    // Stroke outlining deliberately rasterizes at 20x for clean contours,
    // while native filled SVGs use their original 24x24 coordinates.
    // Fantasticon must normalize each glyph or the latter render at ~1/20th
    // of the intended width.
    '--normalize',
  ];

  stdout.writeln('   ${Platform.resolvedExecutable} ${args.join(' ')}');

  try {
    final result = await Process.run(Platform.resolvedExecutable, args);
    stdout.write(result.stdout);

    if (result.exitCode != 0) {
      stderr.writeln(result.stderr);
      stderr.writeln('❌ icon_font_generator failed (exit ${result.exitCode}).');
      exit(result.exitCode);
    }

    final formatResult = await Process.run(
      Platform.resolvedExecutable,
      ['format', generatedClass],
    );
    if (formatResult.exitCode != 0) {
      stderr.writeln(formatResult.stderr);
      stderr.writeln('❌ Failed to format generated Dart bindings.');
      exit(formatResult.exitCode);
    }

    _validateGeneratedOutputs(
      File(generatedFont),
      File(generatedClass),
    );

    File(generatedFont).copySync(_fontOutputFile);
    File(generatedClass).copySync(_classOutputFile);
  } finally {
    if (outputDir.existsSync()) {
      outputDir.deleteSync(recursive: true);
    }
  }

  stdout.writeln('  ✓ Font  → $_fontOutputFile');
  stdout.writeln('  ✓ Class → $_classOutputFile');
}

void _validateGeneratedOutputs(File font, File bindings) {
  if (!font.existsSync() || font.lengthSync() == 0) {
    stderr.writeln('❌ Font generator produced no TTF data.');
    exit(1);
  }
  if (!bindings.existsSync()) {
    stderr.writeln('❌ Font generator produced no Dart bindings.');
    exit(1);
  }

  final bindingSource = bindings.readAsStringSync();
  final glyphCount =
      RegExp(r'^  static const \w+ = _AgoraIconsData\(', multiLine: true)
          .allMatches(bindingSource)
          .length;
  final expectedCount = Directory(_svgSourceDir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.toLowerCase().endsWith('.svg'))
      .length;

  if (glyphCount != expectedCount) {
    stderr.writeln(
        '❌ Generated $glyphCount Dart glyphs for $expectedCount source SVGs.');
    exit(1);
  }

  stdout.writeln('  ✓ Validated $glyphCount generated glyph binding(s).');
}
