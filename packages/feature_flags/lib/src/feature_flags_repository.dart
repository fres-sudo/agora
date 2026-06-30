import 'package:config/config.dart';
import 'package:utils/utils.dart';

import 'feature_flags.dart';
import 'models/subscription_tier.dart';

/// Resolves the active [FeatureFlags] for the app and exposes the ability to
/// override the subscription tier at runtime.
///
/// Resolution order for the active tier:
///   1. A persisted override (developer/QA toggle), if present.
///   2. The compile-time default baked into [AppConfig] (`TIER` dart-define).
///
/// In a future paid build this is where a backend subscription check would be
/// consulted; for now it stays fully local so the free tier works with zero
/// infrastructure (`docs/FESTIVAL_POS_TASKS.md` P9-1).
abstract interface class FeatureFlagsRepository {
  /// The currently active feature flags.
  FeatureFlags get flags;

  /// The currently active tier.
  SubscriptionTier get tier;

  /// Persist a tier override and return the resulting flags.
  Future<FeatureFlags> overrideTier(SubscriptionTier tier);

  /// Clear any persisted override, reverting to the compile-time default.
  Future<FeatureFlags> clearOverride();
}

class FeatureFlagsRepositoryImpl implements FeatureFlagsRepository {
  FeatureFlagsRepositoryImpl({
    required PersistenceService persistenceService,
    AppConfig? config,
  }) : _persistence = persistenceService,
       _config = config ?? AppConfig.current {
    _tier = _resolveInitialTier();
  }

  final PersistenceService _persistence;
  final AppConfig _config;

  late SubscriptionTier _tier;

  @override
  FeatureFlags get flags => FeatureFlags(tier: _tier);

  @override
  SubscriptionTier get tier => _tier;

  @override
  Future<FeatureFlags> overrideTier(SubscriptionTier tier) async {
    _tier = tier;
    await _persistence.saveString(SPKeys.subscriptionTier, tier.name);
    return flags;
  }

  @override
  Future<FeatureFlags> clearOverride() async {
    await _persistence.remove(SPKeys.subscriptionTier);
    _tier = SubscriptionTier.fromName(_config.tierName);
    return flags;
  }

  SubscriptionTier _resolveInitialTier() {
    final override = _persistence.getString(SPKeys.subscriptionTier);
    if (override != null && override.isNotEmpty) {
      return SubscriptionTier.fromName(override);
    }
    return SubscriptionTier.fromName(_config.tierName);
  }
}
