import 'package:auth_session/auth_session.dart';
import 'package:database/database.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feature_onboarding/domain/models/onboarding_draft.dart';
import 'package:feature_onboarding/domain/repositories/onboarding_repository.dart';
import 'package:utils/utils.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({
    required AgoraDatabase database,
    required PersistenceService persistenceService,
    required BusinessProfileRepository businessProfileRepository,
    required AuthRepository authRepository,
  }) : _db = database,
       _persistence = persistenceService,
       _businessProfile = businessProfileRepository,
       _auth = authRepository;

  final AgoraDatabase _db;
  final PersistenceService _persistence;
  final BusinessProfileRepository _businessProfile;
  final AuthRepository _auth;

  @override
  bool isCompleted() => _persistence.getBool(SPKeys.onboarding) ?? false;

  @override
  Future<void> complete(OnboardingDraft draft) async {
    final type = draft.type ?? BusinessType.restaurant;
    final profile = BusinessProfile.forType(type);

    // 1. Persist the chosen business type → active profile.
    await _businessProfile.setType(type);

    // 2. Write business identity, fiscal, and payment settings.
    await _writeSettings(draft, type);

    // 3. Staff vs single-user.
    if (profile.requiresStaffLogin) {
      for (final s in draft.staff) {
        await _db
            .into(_db.employeesTable)
            .insert(
              EmployeesTableCompanion.insert(
                name: s.name,
                pin: s.pin,
                role: Value(s.role),
              ),
            );
      }
      // No auto-login: the PIN screen will let the operator choose who they are.
    } else {
      final ownerId = await _db
          .into(_db.employeesTable)
          .insert(
            EmployeesTableCompanion.insert(
              name: draft.businessName.isEmpty ? 'Owner' : draft.businessName,
              pin: '0000',
              role: const Value('owner'),
            ),
          );
      await _setBool(SettingsKeys.singleUserMode, true);
      await _auth.startSession(ownerId);
    }

    // 4. Optional starter catalog.
    if (draft.menuChoice == MenuChoice.sample) {
      await DataSeeder(_db).seedStarterCatalog(_catalogFor(type));
    }

    // 5. Mark onboarding complete (SharedPreferences is the source of truth).
    await _setBool(SettingsKeys.onboardingCompleted, true);
    await _persistence.saveBool(SPKeys.onboarding, true);
  }

  Future<void> _writeSettings(OnboardingDraft d, BusinessType type) async {
    await _setString(SettingsKeys.businessType, type.name);
    await _setString(SettingsKeys.businessName, d.businessName);
    await _setString(SettingsKeys.businessAddress, d.address);
    await _setString(SettingsKeys.businessPhone, d.phone);
    await _setString(SettingsKeys.businessEmail, d.email);
    await _setString(SettingsKeys.businessCity, d.city);
    await _setString(SettingsKeys.businessCountry, d.country);
    await _setString(SettingsKeys.currencySymbol, d.currencySymbol);
    await _setString(SettingsKeys.taxRate, d.taxRate.toString());
    await _setBool(SettingsKeys.paymentMethodCashEnabled, d.cashEnabled);
    await _setBool(SettingsKeys.paymentMethodCardEnabled, d.cardEnabled);
    await _setString(
      SettingsKeys.defaultOrderType,
      d.profile.has(Capability.dineIn) ? 'dineIn' : 'takeAway',
    );
  }

  Future<void> _setString(String key, String value) =>
      _upsert(key, value, 'string');
  Future<void> _setBool(String key, bool value) =>
      _upsert(key, value.toString(), 'bool');

  Future<void> _upsert(String key, String value, String type) {
    return _db
        .into(_db.appSettingsTable)
        .insertOnConflictUpdate(
          AppSettingsTableCompanion.insert(
            key: key,
            value: value,
            type: Value(type),
          ),
        );
  }

  StarterCatalog _catalogFor(BusinessType type) => switch (type) {
    BusinessType.restaurant => StarterCatalog.restaurant,
    BusinessType.barCafe => StarterCatalog.barCafe,
    BusinessType.quickService => StarterCatalog.quickService,
    BusinessType.festival => StarterCatalog.festival,
  };
}
