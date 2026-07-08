import 'dart:io';

/// Paths — run from the repo root (`dart run .scripts/generate_icons.dart`).
const _svgSourceDir = 'assets/icons';
const _fontOutputFile = 'packages/ui_kit/assets/fonts/AgoraIcons.ttf';
const _classOutputFile = 'packages/ui_kit/lib/src/theme/agora_icons.dart';
const _fontName = 'AgoraIcons';
const _className = _fontName;
const _packageName = 'ui_kit';

void main() async {
  final stopwatch = Stopwatch()..start();
  stdout.writeln('🔧 [generate_icons] Starting icon font generation...');

  _validateSvgSource();
  _ensureOutputDirs();
  await _generateIconFont();

  stopwatch.stop();
  stdout.writeln('✅ [generate_icons] Done in ${stopwatch.elapsed.inSeconds}s.');
  stdout.writeln(
      '   AgoraIcons is exported from package:ui_kit — re-run `melos bootstrap` if this is a fresh checkout.');
}

/// Validates that the SVG source directory exists and contains SVG files.
void _validateSvgSource() {
  final sourceDir = Directory(_svgSourceDir);
  if (!sourceDir.existsSync()) {
    stderr.writeln('❌ Source directory "$_svgSourceDir" not found.');
    exit(1);
  }

  final svgs = sourceDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.svg'))
      .toList();

  if (svgs.isEmpty) {
    stderr.writeln('⚠️  No SVG files found in "$_svgSourceDir". Aborting.');
    exit(1);
  }

  stdout.writeln('📂 Found ${svgs.length} SVG file(s) in "$_svgSourceDir".');
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

/// Runs `icon_font_generator` against the SVG source directory.
///
/// Requires Node.js — the generator shells out to the `fantasticon` npm
/// package to rasterize the font.
Future<void> _generateIconFont() async {
  stdout.writeln('🔠 Running icon_font_generator...');

  final args = [
    'run',
    'icon_font_generator',
    '--from=$_svgSourceDir',
    '--out-font=$_fontOutputFile',
    '--out-flutter=$_classOutputFile',
    '--class-name=$_className',
    '--package=$_packageName',
    '--naming-strategy=camel',
  ];

  stdout.writeln('   dart ${args.join(' ')}');

  final result = await Process.run('dart', args);
  stdout.write(result.stdout);

  if (result.exitCode != 0) {
    stderr.writeln(result.stderr);
    stderr.writeln('❌ icon_font_generator failed (exit ${result.exitCode}).');
    exit(result.exitCode);
  }

  stdout.writeln('  ✓ Font  → $_fontOutputFile');
  stdout.writeln('  ✓ Class → $_classOutputFile');
}
