import 'package:utils/utils.dart';

import 'models/business_profile.dart';
import 'models/business_type.dart';

/// Resolves and persists the active [BusinessProfile].
///
/// The selected [BusinessType] is stored in [PersistenceService]
/// ([SPKeys.businessType]) so it can be read synchronously at startup. Mirrors
/// the resolution style of `FeatureFlagsRepository` — orthogonal axis, same
/// shape.
abstract interface class BusinessProfileRepository {
  /// The currently active profile (falls back to [BusinessProfile.fallback]).
  BusinessProfile get profile;

  /// Whether a business type has been chosen (onboarding has run).
  bool get hasType;

  /// Persist the chosen type and return the resulting profile.
  Future<BusinessProfile> setType(BusinessType type);

  /// Clear any persisted type, reverting to the fallback profile.
  Future<void> clear();
}

class BusinessProfileRepositoryImpl implements BusinessProfileRepository {
  BusinessProfileRepositoryImpl({
    required PersistenceService persistenceService,
  }) : _persistence = persistenceService {
    _type = _resolveInitialType();
  }

  final PersistenceService _persistence;

  BusinessType? _type;

  @override
  bool get hasType => _type != null;

  @override
  BusinessProfile get profile =>
      BusinessProfile.forType(_type ?? BusinessType.restaurant);

  @override
  Future<BusinessProfile> setType(BusinessType type) async {
    _type = type;
    await _persistence.saveString(SPKeys.businessType, type.name);
    return profile;
  }

  @override
  Future<void> clear() async {
    _type = null;
    await _persistence.remove(SPKeys.businessType);
  }

  BusinessType? _resolveInitialType() {
    final raw = _persistence.getString(SPKeys.businessType);
    if (raw == null || raw.isEmpty) return null;
    return BusinessType.fromName(raw);
  }
}
