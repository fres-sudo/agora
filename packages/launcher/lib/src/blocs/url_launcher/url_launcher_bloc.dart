import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';
import '../../repositories/url_launcher_repository.dart';

part 'url_launcher_bloc.freezed.dart';
part 'url_launcher_event.dart';
part 'url_launcher_state.dart';
part 'url_launcher_state_utils.dart';

sealed class UrlLauncherEffect {
  const UrlLauncherEffect();
}

final class UrlLaunched extends UrlLauncherEffect {
  const UrlLaunched(this.uri);
  final Uri uri;
}

final class UrlLaunchError extends UrlLauncherEffect {
  const UrlLaunchError(this.uri);
  final Uri uri;
}

class UrlLauncherBloc
    extends EffectBloc<UrlLauncherEvent, UrlLauncherState, UrlLauncherEffect> {
  UrlLauncherBloc({required this.urlLauncherRepository})
    : super(const UrlLauncherState.checking()) {
    on<ExecuteUrlLauncherEvent>(_onExecute);
  }
  final UrlLauncherRepository urlLauncherRepository;

  void execute(Uri uri, {LaunchMode mode = LaunchMode.platformDefault}) =>
      add(UrlLauncherEvent.execute(uri, mode: mode));

  FutureOr<void> _onExecute(
    ExecuteUrlLauncherEvent event,
    Emitter<UrlLauncherState> emit,
  ) async {
    try {
      emit(const UrlLauncherState.checking());
      final canLaunch = await urlLauncherRepository.canLaunchUrl(event.uri);

      if (canLaunch.unwrap()) {
        emit(const UrlLauncherState.launching());
        final launched = await urlLauncherRepository.launchUrl(
          event.uri,
          mode: event.mode,
        );

        if (launched.unwrap()) {
          emitEffect(UrlLaunched(event.uri));
          emit(const UrlLauncherState.launched());
        } else {
          emitEffect(UrlLaunchError(event.uri));
          emit(const UrlLauncherState.error());
        }
      } else {
        emitEffect(UrlLaunchError(event.uri));
        emit(const UrlLauncherState.error());
      }
    } catch (_) {
      emitEffect(UrlLaunchError(event.uri));
      emit(const UrlLauncherState.error());
    }
  }
}

extension UrlLauncherBlocExtension on BuildContext {
  UrlLauncherBloc get urlLauncherCubit => read<UrlLauncherBloc>();
  UrlLauncherBloc get watchUrlLauncherCubit => watch<UrlLauncherBloc>();
}
