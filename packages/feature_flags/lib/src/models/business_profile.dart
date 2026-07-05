import 'package:flutter/foundation.dart';

import 'business_type.dart';
import 'capability.dart';

/// An immutable description of how the app should behave for a given
/// [BusinessType]: which [Capability]s are on, and the sensible defaults
/// onboarding should pre-fill.
///
/// Built from a static preset via [BusinessProfile.forType]; the concrete
/// values are the single place vertical behaviour is defined.
///
/// ```dart
/// if (profile.has(Capability.tables)) {
///   // show the table picker
/// }
/// ```
@immutable
class BusinessProfile {
  const BusinessProfile({
    required this.type,
    required this.capabilities,
    required this.defaultTaxRate,
    required this.defaultCardEnabled,
    required this.defaultCurrencySymbol,
  });

  /// The active business type.
  final BusinessType type;

  /// The capabilities enabled for this profile.
  final Set<Capability> capabilities;

  /// Tax rate to pre-fill in onboarding (percent, e.g. `10` for 10%).
  final double defaultTaxRate;

  /// Whether card payment is enabled by default (cash is always on).
  final bool defaultCardEnabled;

  /// Currency symbol to pre-fill in onboarding.
  final String defaultCurrencySymbol;

  /// Whether [c] is enabled for this profile.
  bool has(Capability c) => capabilities.contains(c);

  /// Whether this business runs multiple staff behind a PIN login. When
  /// `false`, the app runs single-user with no login screen.
  bool get requiresStaffLogin => has(Capability.staffLogin);

  /// The safe default profile used before onboarding has run.
  static BusinessProfile get fallback => forType(BusinessType.restaurant);

  /// The preset profile for [type]. This map is the authoritative definition of
  /// how each vertical is shaped.
  static BusinessProfile forType(BusinessType type) {
    switch (type) {
      case BusinessType.restaurant:
        return const BusinessProfile(
          type: BusinessType.restaurant,
          capabilities: {
            Capability.tables,
            Capability.covers,
            Capability.dineIn,
            Capability.takeaway,
            Capability.staffLogin,
            Capability.inventory,
            Capability.reports,
            Capability.discounts,
          },
          defaultTaxRate: 10,
          defaultCardEnabled: true,
          defaultCurrencySymbol: '€',
        );
      case BusinessType.barCafe:
        return const BusinessProfile(
          type: BusinessType.barCafe,
          capabilities: {
            Capability.dineIn,
            Capability.takeaway,
            Capability.staffLogin,
            Capability.inventory,
            Capability.reports,
            Capability.discounts,
          },
          defaultTaxRate: 10,
          defaultCardEnabled: true,
          defaultCurrencySymbol: '€',
        );
      case BusinessType.quickService:
        return const BusinessProfile(
          type: BusinessType.quickService,
          capabilities: {
            Capability.dineIn,
            Capability.takeaway,
            Capability.inventory,
            Capability.reports,
            Capability.discounts,
          },
          defaultTaxRate: 10,
          defaultCardEnabled: true,
          defaultCurrencySymbol: '€',
        );
      case BusinessType.festival:
        return const BusinessProfile(
          type: BusinessType.festival,
          capabilities: {
            Capability.takeaway,
            Capability.inventory,
            Capability.reports,
          },
          defaultTaxRate: 0,
          defaultCardEnabled: false,
          defaultCurrencySymbol: '€',
        );
    }
  }

  @override
  String toString() => 'BusinessProfile(type: ${type.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessProfile &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;
}
