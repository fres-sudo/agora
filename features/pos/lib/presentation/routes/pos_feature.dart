import 'package:bloc_exports/bloc_exports.dart';

// POS has no feature-specific BLoCs — it composes products, orders and discounts.
// Provider registration is handled by those features.
class PosFeature {
  static List<SingleChildWidget> get providers => const [];
}
