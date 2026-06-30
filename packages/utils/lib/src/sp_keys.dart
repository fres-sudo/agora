abstract class SPKeys {
  static const String theme = 'theme';
  static const String onboarding = 'onboardingSeen';
  static const String setupWizard = 'setupWizardSeen';

  /// Persisted override for the active subscription tier (free vs paid).
  ///
  /// When set, it takes precedence over the compile-time default tier baked
  /// into [AppConfig]. Primarily a developer/QA affordance for exercising paid
  /// features without a real backend entitlement.
  static const String subscriptionTier = 'subscriptionTier';
}
