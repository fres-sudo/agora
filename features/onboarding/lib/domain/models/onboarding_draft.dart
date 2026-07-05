import 'package:feature_flags/feature_flags.dart';

/// Whether the operator wants a sample starter catalog or an empty one.
enum MenuChoice { sample, empty }

/// A staff member the operator adds during onboarding (staff-login businesses).
class StaffDraft {
  const StaffDraft({required this.name, required this.role, required this.pin});

  final String name;
  final String role;
  final String pin;

  StaffDraft copyWith({String? name, String? role, String? pin}) => StaffDraft(
    name: name ?? this.name,
    role: role ?? this.role,
    pin: pin ?? this.pin,
  );
}

/// All input collected by the onboarding wizard. Immutable — the cubit swaps in
/// a new copy on every edit via [copyWith].
class OnboardingDraft {
  const OnboardingDraft({
    this.type,
    this.businessName = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.city = '',
    this.country = '',
    this.currencySymbol = '€',
    this.taxRate = 0,
    this.cashEnabled = true,
    this.cardEnabled = true,
    this.staff = const [],
    this.menuChoice = MenuChoice.sample,
  });

  final BusinessType? type;
  final String businessName;
  final String address;
  final String phone;
  final String email;
  final String city;
  final String country;
  final String currencySymbol;
  final double taxRate;
  final bool cashEnabled;
  final bool cardEnabled;
  final List<StaffDraft> staff;
  final MenuChoice menuChoice;

  /// The profile implied by the chosen [type] (fallback until one is picked).
  BusinessProfile get profile =>
      type == null ? BusinessProfile.fallback : BusinessProfile.forType(type!);

  OnboardingDraft copyWith({
    BusinessType? type,
    String? businessName,
    String? address,
    String? phone,
    String? email,
    String? city,
    String? country,
    String? currencySymbol,
    double? taxRate,
    bool? cashEnabled,
    bool? cardEnabled,
    List<StaffDraft>? staff,
    MenuChoice? menuChoice,
  }) => OnboardingDraft(
    type: type ?? this.type,
    businessName: businessName ?? this.businessName,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    city: city ?? this.city,
    country: country ?? this.country,
    currencySymbol: currencySymbol ?? this.currencySymbol,
    taxRate: taxRate ?? this.taxRate,
    cashEnabled: cashEnabled ?? this.cashEnabled,
    cardEnabled: cardEnabled ?? this.cardEnabled,
    staff: staff ?? this.staff,
    menuChoice: menuChoice ?? this.menuChoice,
  );
}
