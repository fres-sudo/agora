import 'package:flutter/foundation.dart';

import 'models/feature.dart';
import 'models/subscription_tier.dart';

/// An immutable snapshot of what the current user/tenant is entitled to.
///
/// Pure and side-effect free: given a [SubscriptionTier] it can answer whether
/// any [Feature] is enabled. This is the object widgets and blocs consult.
///
/// ```dart
/// if (flags.isEnabled(Feature.kitchenSync)) {
///   syncManager.start(...);
/// }
/// ```
@immutable
class FeatureFlags {
  const FeatureFlags({required this.tier});

  /// The free tier — nothing paid is unlocked. Safe default everywhere.
  static const FeatureFlags free = FeatureFlags(tier: SubscriptionTier.free);

  /// The active subscription tier driving the entitlements.
  final SubscriptionTier tier;

  /// Whether the given [feature] is unlocked for the current [tier].
  bool isEnabled(Feature feature) => tier.isAtLeast(feature.minimumTier);

  /// Convenience inverse of [isEnabled].
  bool isDisabled(Feature feature) => !isEnabled(feature);

  /// All features currently unlocked. Useful for diagnostics / debug screens.
  Set<Feature> get enabledFeatures => Feature.values.where(isEnabled).toSet();

  FeatureFlags copyWith({SubscriptionTier? tier}) =>
      FeatureFlags(tier: tier ?? this.tier);

  @override
  String toString() => 'FeatureFlags(tier: ${tier.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureFlags &&
          runtimeType == other.runtimeType &&
          tier == other.tier;

  @override
  int get hashCode => tier.hashCode;
}
