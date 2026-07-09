import 'package:provider/single_child_widget.dart';

/// Common contract for the static feature-registration classes (`XFeature`)
/// that each `features/<name>` package exposes to the app shell.
///
/// Implementing this lets the app shell compose feature providers uniformly
/// (e.g. by iterating a `List<AppFeature>`) instead of referencing each
/// feature class ad hoc.
abstract class AppFeature {
  const AppFeature();

  /// DAOs, repositories and BLoCs this feature contributes to the app-wide
  /// provider tree.
  List<SingleChildWidget> get providers;
}
