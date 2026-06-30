import 'package:config/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFlavor.fromName', () {
    test('parses known names case-insensitively', () {
      expect(AppFlavor.fromName('dev'), AppFlavor.dev);
      expect(AppFlavor.fromName('DEV'), AppFlavor.dev);
      expect(AppFlavor.fromName('staging'), AppFlavor.staging);
      expect(AppFlavor.fromName('stg'), AppFlavor.staging);
      expect(AppFlavor.fromName('prod'), AppFlavor.prod);
      expect(AppFlavor.fromName('production'), AppFlavor.prod);
    });

    test('defaults to dev for null/unknown', () {
      expect(AppFlavor.fromName(null), AppFlavor.dev);
      expect(AppFlavor.fromName(''), AppFlavor.dev);
      expect(AppFlavor.fromName('nonsense'), AppFlavor.dev);
    });

    test('exposes convenience predicates', () {
      expect(AppFlavor.dev.isDev, isTrue);
      expect(AppFlavor.prod.isProd, isTrue);
      expect(AppFlavor.staging.isNonProduction, isTrue);
      expect(AppFlavor.prod.isNonProduction, isFalse);
    });
  });

  group('BootstrapMode.fromName', () {
    test('parses hybrid synonyms', () {
      expect(BootstrapMode.fromName('hybrid'), BootstrapMode.hybrid);
      expect(BootstrapMode.fromName('cloud'), BootstrapMode.hybrid);
      expect(BootstrapMode.fromName('online'), BootstrapMode.hybrid);
    });

    test('defaults to local (offline-safe) for null/unknown', () {
      expect(BootstrapMode.fromName(null), BootstrapMode.local);
      expect(BootstrapMode.fromName(''), BootstrapMode.local);
      expect(BootstrapMode.fromName('local'), BootstrapMode.local);
      expect(BootstrapMode.fromName('whatever'), BootstrapMode.local);
    });
  });

  group('AppConfig.fromEnvironment (no dart-defines)', () {
    // With no --dart-define supplied the build must still yield a runnable,
    // fully-local dev configuration.
    test('uses offline-safe defaults', () {
      final config = AppConfig.fromEnvironment();

      expect(config.flavor, AppFlavor.dev);
      expect(config.appName, 'Agora');
      expect(config.apiBaseUrl, isEmpty);
      expect(config.wsBaseUrl, isEmpty);
      expect(config.bootstrapMode, BootstrapMode.local);
      expect(config.tierName, 'free');
      expect(config.enableLogging, isTrue);
      expect(config.enableInspector, isFalse);
      expect(config.hasApiBaseUrl, isFalse);
      expect(config.hasWsBaseUrl, isFalse);
    });
  });

  group('AppConfig value semantics', () {
    test('copyWith overrides selected fields only', () {
      const base = AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Agora',
        apiBaseUrl: '',
        wsBaseUrl: '',
        bootstrapMode: BootstrapMode.local,
        tierName: 'free',
        enableLogging: true,
        enableInspector: false,
      );

      final updated = base.copyWith(
        flavor: AppFlavor.prod,
        bootstrapMode: BootstrapMode.hybrid,
        apiBaseUrl: 'https://api.example.com',
      );

      expect(updated.flavor, AppFlavor.prod);
      expect(updated.bootstrapMode, BootstrapMode.hybrid);
      expect(updated.apiBaseUrl, 'https://api.example.com');
      // untouched
      expect(updated.appName, 'Agora');
      expect(updated.tierName, 'free');
    });

    test('equality and hashCode are value-based', () {
      const a = AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Agora',
        apiBaseUrl: '',
        wsBaseUrl: '',
        bootstrapMode: BootstrapMode.local,
        tierName: 'free',
        enableLogging: true,
        enableInspector: false,
      );
      const b = AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Agora',
        apiBaseUrl: '',
        wsBaseUrl: '',
        bootstrapMode: BootstrapMode.local,
        tierName: 'free',
        enableLogging: true,
        enableInspector: false,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
