import 'package:feature_flags/feature_flags.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusinessType.fromName', () {
    test('parses known spellings', () {
      expect(BusinessType.fromName('barCafe'), BusinessType.barCafe);
      expect(BusinessType.fromName('bar'), BusinessType.barCafe);
      expect(BusinessType.fromName('quick_service'), BusinessType.quickService);
      expect(BusinessType.fromName('takeaway'), BusinessType.quickService);
      expect(BusinessType.fromName('festival'), BusinessType.festival);
      expect(BusinessType.fromName('restaurant'), BusinessType.restaurant);
    });

    test('defaults to restaurant for null/unknown', () {
      expect(BusinessType.fromName(null), BusinessType.restaurant);
      expect(BusinessType.fromName('nonsense'), BusinessType.restaurant);
    });
  });

  group('BusinessProfile.forType presets', () {
    test('restaurant has the full capability set and staff login', () {
      final p = BusinessProfile.forType(BusinessType.restaurant);
      expect(p.has(Capability.tables), isTrue);
      expect(p.has(Capability.covers), isTrue);
      expect(p.has(Capability.dineIn), isTrue);
      expect(p.has(Capability.takeaway), isTrue);
      expect(p.requiresStaffLogin, isTrue);
      expect(p.defaultCardEnabled, isTrue);
    });

    test('bar/café drops tables & covers but keeps staff login', () {
      final p = BusinessProfile.forType(BusinessType.barCafe);
      expect(p.has(Capability.tables), isFalse);
      expect(p.has(Capability.covers), isFalse);
      expect(p.requiresStaffLogin, isTrue);
    });

    test('quick-service is single-user with no tables', () {
      final p = BusinessProfile.forType(BusinessType.quickService);
      expect(p.requiresStaffLogin, isFalse);
      expect(p.has(Capability.tables), isFalse);
      expect(p.has(Capability.takeaway), isTrue);
      expect(p.has(Capability.reports), isTrue);
    });

    test('festival is cash-first, single-user, minimal', () {
      final p = BusinessProfile.forType(BusinessType.festival);
      expect(p.requiresStaffLogin, isFalse);
      expect(p.has(Capability.dineIn), isFalse);
      expect(p.has(Capability.discounts), isFalse);
      expect(p.defaultCardEnabled, isFalse);
      expect(p.defaultTaxRate, 0);
    });

    test('fallback is the restaurant profile', () {
      expect(BusinessProfile.fallback.type, BusinessType.restaurant);
    });
  });
}
