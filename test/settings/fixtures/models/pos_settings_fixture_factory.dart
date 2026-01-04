import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/settings/models/pos_settings/pos_settings.dart';

extension PosSettingsFixture on PosSettings {
  static PosSettingsFixtureFactory factory() => PosSettingsFixtureFactory();
}

class PosSettingsFixtureFactory extends FixtureFactory<PosSettings> {
  @override
  FixtureDefinition<PosSettings> definition() => define(
    (faker, [int _ = 0]) => PosSettings(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
