import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:agora/core/enums/launch_mode.dart';
import 'package:agora/core/repositories/url_launcher_repository.dart';

part 'url_launcher_bloc.freezed.dart';
part 'url_launcher_event.dart';
part 'url_launcher_state.dart';

class UrlLauncherBloc extends Bloc<UrlLauncherEvent, UrlLauncherState> {
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
          emit(const UrlLauncherState.launched());
        } else {
          emit(const UrlLauncherState.error());
        }
      } else {
        emit(const UrlLauncherState.error());
      }
    } catch (_) {
      emit(const UrlLauncherState.error());
    }
  }
}

extension UrlLauncherBlocExtension on BuildContext {
  UrlLauncherBloc get urlLauncherCubit => read<UrlLauncherBloc>();
  UrlLauncherBloc get watchUrlLauncherCubit => watch<UrlLauncherBloc>();
}
