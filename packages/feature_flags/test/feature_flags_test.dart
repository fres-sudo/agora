import 'package:feature_flags/feature_flags.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionTier.fromName', () {
    test('parses paid pro synonyms', () {
      expect(SubscriptionTier.fromName('paidPro'), SubscriptionTier.paidPro);
      expect(SubscriptionTier.fromName('paid_pro'), SubscriptionTier.paidPro);
      expect(SubscriptionTier.fromName('pro'), SubscriptionTier.paidPro);
      expect(SubscriptionTier.fromName('saas'), SubscriptionTier.paidPro);
    });

    test('parses paid basic synonyms', () {
      expect(
        SubscriptionTier.fromName('paidBasic'),
        SubscriptionTier.paidBasic,
      );
      expect(
        SubscriptionTier.fromName('paid_basic'),
        SubscriptionTier.paidBasic,
      );
      expect(SubscriptionTier.fromName('basic'), SubscriptionTier.paidBasic);
    });

    test('defaults to free for null/unknown', () {
      expect(SubscriptionTier.fromName(null), SubscriptionTier.free);
      expect(SubscriptionTier.fromName(''), SubscriptionTier.free);
      expect(SubscriptionTier.fromName('garbage'), SubscriptionTier.free);
    });

    test('rank ordering supports isAtLeast', () {
      expect(SubscriptionTier.paidPro.isAtLeast(SubscriptionTier.free), isTrue);
      expect(
        SubscriptionTier.paidBasic.isAtLeast(SubscriptionTier.paidPro),
        isFalse,
      );
      expect(SubscriptionTier.free.isPaid, isFalse);
      expect(SubscriptionTier.paidBasic.isPaid, isTrue);
    });
  });

  group('FeatureFlags entitlement table', () {
    test('free tier unlocks nothing gated', () {
      const flags = FeatureFlags.free;
      for (final feature in Feature.values) {
        expect(
          flags.isEnabled(feature),
          isFalse,
          reason: '$feature must be locked on the free tier',
        );
      }
      expect(flags.enabledFeatures, isEmpty);
    });

    test('paid basic unlocks basic features but not pro-only', () {
      const flags = FeatureFlags(tier: SubscriptionTier.paidBasic);

      // basic-tier features
      expect(flags.isEnabled(Feature.kitchenSync), isTrue);
      expect(flags.isEnabled(Feature.multiTerminalSync), isTrue);
      expect(flags.isEnabled(Feature.cloudReports), isTrue);
      expect(flags.isEnabled(Feature.aiReportSummary), isTrue);
      expect(flags.isEnabled(Feature.aiDietaryFilter), isTrue);

      // pro-only features
      expect(flags.isEnabled(Feature.aiUpsellNudge), isFalse);
      expect(flags.isEnabled(Feature.aiWaitingTimeAlert), isFalse);
      expect(flags.isEnabled(Feature.aiKitchenPrioritisation), isFalse);
      expect(flags.isEnabled(Feature.aiDemandForecast), isFalse);
      expect(flags.isDisabled(Feature.aiDemandForecast), isTrue);
    });

    test('paid pro unlocks everything', () {
      const flags = FeatureFlags(tier: SubscriptionTier.paidPro);
      for (final feature in Feature.values) {
        expect(
          flags.isEnabled(feature),
          isTrue,
          reason: '$feature must be unlocked on the pro tier',
        );
      }
      expect(flags.enabledFeatures, Feature.values.toSet());
    });

    test('every Feature declares a non-free minimum tier', () {
      // Always-free capabilities should not be modelled as a Feature at all.
      for (final feature in Feature.values) {
        expect(
          feature.minimumTier.isPaid,
          isTrue,
          reason: '$feature should not exist if it is free for everyone',
        );
      }
    });
  });
}
