part of 'dependency_injector.dart';

final List<BlocProvider> _blocs = [
  BlocProvider<PinBloc>(
    create:
        (context) => PinBloc(storageService: context.read<StorageService>()),
  ),
];
