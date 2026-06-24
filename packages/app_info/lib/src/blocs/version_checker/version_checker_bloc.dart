import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';
import '../../repositories/version_checker_repository.dart';

part 'version_checker_bloc.freezed.dart';
part 'version_checker_event.dart';
part 'version_checker_state.dart';
part 'version_checker_state_utils.dart';

sealed class VersionCheckerEffect {
  const VersionCheckerEffect();
}

final class VersionCheckerErrorEffect extends VersionCheckerEffect {
  const VersionCheckerErrorEffect();
}

class VersionCheckerBloc
    extends
        EffectBloc<
          VersionCheckerEvent,
          VersionCheckerState,
          VersionCheckerEffect
        > {
  VersionCheckerBloc({required this.versionCheckerRepository})
    : super(const VersionCheckerState.gettingAppInfo()) {
    on<GetAppInfoVersionCheckerEvent>(_onGetAppInfo);
  }
  final VersionCheckerRepository versionCheckerRepository;

  void getAppInfo() => add(const VersionCheckerEvent.getAppInfo());

  FutureOr<void> _onGetAppInfo(
    GetAppInfoVersionCheckerEvent event,
    Emitter<VersionCheckerState> emit,
  ) async {
    emit(const VersionCheckerState.gettingAppInfo());
    try {
      final version = await versionCheckerRepository.currentVersion;
      final build = await versionCheckerRepository.currentBuild;
      final platform = await versionCheckerRepository.currentPlatform;

      emit(
        VersionCheckerState.gotAppInfo(
          version: version,
          build: build,
          platform: platform,
        ),
      );
    } catch (_) {
      emitEffect(const VersionCheckerErrorEffect());
      emit(const VersionCheckerState.errorGettingAppInfo());
    }
  }
}

extension VersionCheckerBlocExtension on BuildContext {
  VersionCheckerBloc get versionCheckerBloc => read<VersionCheckerBloc>();
  VersionCheckerBloc get watchVersionCheckerBloc => watch<VersionCheckerBloc>();
}
