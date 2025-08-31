part of 'dependency_injector.dart';

final List<SingleChildWidget> _providers = [
  Provider<StorageService>(create: (context) => SecureStorageService()),
];
