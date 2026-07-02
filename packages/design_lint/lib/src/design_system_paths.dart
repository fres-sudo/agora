/// Path predicates shared by every rule.
///
/// The design-system rules forbid raw colors / text styles / Material widgets in
/// *application* code, but the design system itself (`packages/ui_kit`) has to
/// build on exactly those primitives — `AppText` wraps `Text`, `AppButton`
/// wraps a Material button, `AppColors` is literally a table of `Color`s. Those
/// files, plus machine-generated ones, are therefore exempt.
library;

/// Whether [path] belongs to a file the design-system rules must not touch.
bool isExemptPath(String path) {
  final normalized = path.replaceAll(r'\', '/');

  // The design system defines the primitives it is asking everyone else to use.
  if (normalized.contains('/packages/ui_kit/')) return true;

  // Tests are not shipped UI — they routinely build throwaway `Text`/`Color`
  // probes and fixtures. Enforce the design system on production code only.
  if (normalized.contains('/test/') || normalized.endsWith('_test.dart')) {
    return true;
  }

  // Never lint generated sources — developers don't hand-edit these.
  const generatedSuffixes = [
    '.g.dart',
    '.freezed.dart',
    '.gr.dart',
    '.config.dart',
    '.mocks.dart',
    '.gen.dart',
  ];
  for (final suffix in generatedSuffixes) {
    if (normalized.endsWith(suffix)) return true;
  }

  return false;
}
