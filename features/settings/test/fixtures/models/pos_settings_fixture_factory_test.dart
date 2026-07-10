import 'package:feature_settings/feature_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pos_settings_fixture_factory.dart';

void main() {
  test('PosSettingsFixtureFactory produces a well-formed PosSettings', () {
    final settings = PosSettingsFixture.factory().makeSingle();

    expect(settings, isA<PosSettings>());
    expect(settings.currencySymbol, '\$');
    expect(settings.taxRate, 22.0);
  });
}
