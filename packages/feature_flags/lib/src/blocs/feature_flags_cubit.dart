import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature_flags.dart';
import '../feature_flags_repository.dart';
import '../models/feature.dart';
import '../models/subscription_tier.dart';

/// Exposes the active [FeatureFlags] to the widget tree and lets the app change
/// the subscription tier at runtime (developer/QA toggle, or — later — a
/// backend-driven subscription update).
///
/// The state is simply the current [FeatureFlags] value object, so widgets can
/// gate UI directly:
/// ```dart
/// BlocBuilder<FeatureFlagsCubit, FeatureFlags>(
///   builder: (context, flags) => flags.isEnabled(Feature.cloudReports)
///       ? const CloudReportsButton()
///       : const SizedBox.shrink(),
/// );
/// ```
class FeatureFlagsCubit extends Cubit<FeatureFlags> {
  FeatureFlagsCubit({required FeatureFlagsRepository repository})
    : _repository = repository,
      super(repository.flags);

  final FeatureFlagsRepository _repository;

  /// Whether [feature] is currently unlocked.
  bool isEnabled(Feature feature) => state.isEnabled(feature);

  /// Override the active tier (e.g. simulate a paid subscription locally).
  Future<void> setTier(SubscriptionTier tier) async {
    emit(await _repository.overrideTier(tier));
  }

  /// Revert to the compile-time default tier.
  Future<void> resetTier() async {
    emit(await _repository.clearOverride());
  }
}

extension FeatureFlagsCubitExtension on BuildContext {
  FeatureFlagsCubit get featureFlagsCubit => read<FeatureFlagsCubit>();

  FeatureFlagsCubit get watchFeatureFlagsCubit => watch<FeatureFlagsCubit>();

  /// The current feature flags (non-reactive read).
  FeatureFlags get featureFlags => read<FeatureFlagsCubit>().state;
}
