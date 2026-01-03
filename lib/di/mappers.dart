part of 'dependency_injector.dart';

final List<SingleChildWidget> _mappers = [
  Provider<LaunchModeMapper>(create: (context) => LaunchModeMapper()),
];
