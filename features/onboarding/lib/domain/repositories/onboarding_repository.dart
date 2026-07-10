import 'package:feature_onboarding/domain/models/onboarding_draft.dart';

abstract interface class OnboardingRepository {
  /// Whether onboarding has been completed. Read synchronously at startup to
  /// decide the initial route.
  bool isCompleted();

  /// Commit the wizard input: persist the business profile + settings, create
  /// staff (or a single-user session), optionally seed a starter catalog, and
  /// mark onboarding done.
  Future<void> complete(OnboardingDraft draft);
}
