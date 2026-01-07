import 'package:agora/settings/models/pos_settings/pos_settings.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension PosSettingsFixture on PosSettings {
  static PosSettingsFixtureFactory factory() => PosSettingsFixtureFactory();
}

class PosSettingsFixtureFactory extends FixtureFactory<PosSettings> {
  @override
  FixtureDefinition<PosSettings> definition() => define(
        (faker, [int _ = 0]) => PosSettings(
          currencySymbol: '\$',
          printerIp: '192.168.1.100',
          receiptHeader: faker.company.name(),
          showImages: faker.randomGenerator.boolean(),
          taxRate: 22.0,
        ),
      );
}
