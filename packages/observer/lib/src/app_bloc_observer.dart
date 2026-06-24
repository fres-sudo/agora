import 'package:bloc/bloc.dart';
import 'package:talker/talker.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({required this.talker});

  final Talker talker;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    talker.verbose('[BlocObserver] onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    talker.verbose('[BlocObserver] onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    talker.error(
      '[BlocObserver] onError -- ${bloc.runtimeType}',
      error,
      stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    talker.verbose('[BlocObserver] onClose -- ${bloc.runtimeType}');
  }
}
