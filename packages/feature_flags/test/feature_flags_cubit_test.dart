import 'package:bloc_test/bloc_test.dart';
import 'package:config/config.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utils/utils.dart';

/// Minimal in-memory [PersistenceService] for exercising tier overrides.
class _FakePersistence implements PersistenceService {
  final Map<String, Object?> _store = {};

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<void> saveString(String key, String value) async =>
      _store[key] = value;

  @override
  Future<void> remove(String key) async => _store.remove(key);

  // ---- unused members for these tests --------------------------------------
  @override
  Future<void> clear() async => _store.clear();
  @override
  bool? getBool(String key) => _store[key] as bool?;
  @override
  double? getDouble(String key) => _store[key] as double?;
  @override
  int? getInt(String key) => _store[key] as int?;
  @override
  List<String>? getStringList(String key) => _store[key] as List<String>?;
  @override
  Future<void> saveBool(String key, bool value) async => _store[key] = value;
  @override
  Future<void> saveDouble(String key, double value) async =>
      _store[key] = value;
  @override
  Future<void> saveInt(String key, int value) async => _store[key] = value;
  @override
  Future<void> saveStringList(String key, List<String> value) async =>
      _store[key] = value;
}

AppConfig _configWithTier(String tier) => AppConfig(
  flavor: AppFlavor.dev,
  appName: 'Agora',
  apiBaseUrl: '',
  wsBaseUrl: '',
  bootstrapMode: BootstrapMode.local,
  tierName: tier,
  enableLogging: true,
  enableInspector: false,
);

void main() {
  group('FeatureFlagsRepositoryImpl', () {
    test('resolves the compile-time default tier when no override', () {
      final repo = FeatureFlagsRepositoryImpl(
        persistenceService: _FakePersistence(),
        config: _configWithTier('free'),
      );

      expect(repo.tier, SubscriptionTier.free);
      expect(repo.flags, FeatureFlags.free);
    });

    test('a persisted override wins over the compile-time default', () {
      final persistence = _FakePersistence();
      persistence._store[SPKeys.subscriptionTier] = 'paidPro';

      final repo = FeatureFlagsRepositoryImpl(
        persistenceService: persistence,
        config: _configWithTier('free'),
      );

      expect(repo.tier, SubscriptionTier.paidPro);
    });

    test('overrideTier persists and clearOverride reverts to default', () async {
      final persistence = _FakePersistence();
      final repo = FeatureFlagsRepositoryImpl(
        persistenceService: persistence,
        config: _configWithTier('paidBasic'),
      );

      await repo.overrideTier(SubscriptionTier.paidPro);
      expect(repo.tier, SubscriptionTier.paidPro);
      expect(persistence.getString(SPKeys.subscriptionTier), 'paidPro');

      await repo.clearOverride();
      expect(repo.tier, SubscriptionTier.paidBasic); // back to config default
      expect(persistence.getString(SPKeys.subscriptionTier), isNull);
    });
  });

  group('FeatureFlagsCubit', () {
    FeatureFlagsRepository buildRepo(String tier) =>
        FeatureFlagsRepositoryImpl(
          persistenceService: _FakePersistence(),
          config: _configWithTier(tier),
        );

    test('initial state reflects the repository flags', () {
      final cubit = FeatureFlagsCubit(repository: buildRepo('free'));
      expect(cubit.state, FeatureFlags.free);
      expect(cubit.isEnabled(Feature.kitchenSync), isFalse);
      cubit.close();
    });

    blocTest<FeatureFlagsCubit, FeatureFlags>(
      'setTier emits the upgraded flags',
      build: () => FeatureFlagsCubit(repository: buildRepo('free')),
      act: (cubit) => cubit.setTier(SubscriptionTier.paidPro),
      expect: () => const [FeatureFlags(tier: SubscriptionTier.paidPro)],
      verify: (cubit) {
        expect(cubit.isEnabled(Feature.aiDemandForecast), isTrue);
      },
    );

    blocTest<FeatureFlagsCubit, FeatureFlags>(
      'resetTier reverts to the compile-time default',
      build: () => FeatureFlagsCubit(repository: buildRepo('free')),
      act: (cubit) async {
        await cubit.setTier(SubscriptionTier.paidPro);
        await cubit.resetTier();
      },
      expect: () => const [
        FeatureFlags(tier: SubscriptionTier.paidPro),
        FeatureFlags.free,
      ],
    );
  });
}
