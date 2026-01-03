import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:agora/core/misc/sp_keys.dart';
import 'package:agora/core/services/persistence/persistence_service.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';
part 'theme_state_utils.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.persistenceService})
    : super(const ThemeState.setting());

  final PersistenceService persistenceService;

  FutureOr<void> load() {
    try {
      emit(const ThemeState.setting());
      final modeStr = persistenceService.getString(SPKeys.theme);
      final mode = modeStr != null ? ThemeMode.values.byName(modeStr) : null;
      emit(ThemeState.setted(mode ?? ThemeMode.system));
    } catch (_) {
      emit(const ThemeState.errorsetting());
    }
  }

  FutureOr<void> toggle(Brightness brightness) async {
    try {
      emit(const ThemeState.setting());
      final newMode =
          brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light;
      await persistenceService.saveString(SPKeys.theme, newMode.name);
      emit(ThemeState.setted(newMode));
    } catch (_) {
      emit(const ThemeState.errorsetting());
    }
  }
}
