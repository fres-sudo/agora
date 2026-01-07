import 'dart:async';

import 'package:agora/core/misc/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/settings/repositories/settings_repository.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

/// Cubit for managing app settings.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(const SettingsState.loading());

  final SettingsRepository _settingsRepository;
  StreamSubscription<List<AppSetting>>? _subscription;

  // ============================================================
  // PUBLIC METHODS
  // ============================================================

  /// Load all settings.
  Future<void> load() async {
    emit(const SettingsState.loading());

    await _subscription?.cancel();

    _subscription = _settingsRepository.watchAllSettings().listen(
      (settings) {
        if (!isClosed) {
          emit(
            SettingsState.loaded(
              settings: Map.fromEntries(
                settings.map((s) => MapEntry(s.key, s.value)),
              ),
            ),
          );
        }
      },
      onError: (error) {
        if (!isClosed) {
          emit(SettingsState.error(message: error.toString()));
        }
      },
    );
  }

  /// Update a single setting.
  Future<void> update(String key, String value) async {
    // Optimistic update
    final currentSettings = state.maybeMap(
      loaded: (s) => s.settings,
      orElse: () => <String, String>{},
    );

    emit(SettingsState.loaded(settings: {...currentSettings, key: value}));

    final result = await _settingsRepository.setString(key, value);

    result.when(
      success: (_) {
        // Stream will confirm the update
      },
      error: (error) {
        // Revert on error
        emit(
          SettingsState.error(
            message: 'Failed to save setting: ${error.toString()}',
          ),
        );
      },
    );
  }

  /// Update an integer setting.
  Future<void> updateInt(String key, int value) async {
    await update(key, value.toString());
  }

  /// Update a boolean setting.
  Future<void> updateBool(String key, bool value) async {
    await update(key, value.toString());
  }

  /// Update a double setting.
  Future<void> updateDouble(String key, double value) async {
    await update(key, value.toString());
  }

  /// Get a string setting value.
  String? getString(String key) {
    return state.maybeMap(loaded: (s) => s.settings[key], orElse: () => null);
  }

  /// Get an integer setting value.
  int? getInt(String key) {
    final value = getString(key);
    return value != null ? int.tryParse(value) : null;
  }

  /// Get a boolean setting value.
  bool getBool(String key, {bool defaultValue = false}) {
    final value = getString(key);
    return value == 'true' ? true : (value == 'false' ? false : defaultValue);
  }

  /// Get a double setting value.
  double? getDouble(String key) {
    final value = getString(key);
    return value != null ? double.tryParse(value) : null;
  }

  /// Delete a setting.
  Future<void> delete(String key) async {
    final result = await _settingsRepository.deleteSetting(key);

    result.when(
      success: (_) {
        // Stream will update automatically
      },
      error: (error) {
        emit(
          SettingsState.error(
            message: 'Failed to delete setting: ${error.toString()}',
          ),
        );
      },
    );
  }

  /// Reset all settings to defaults.
  Future<void> reset() async {
    emit(const SettingsState.loading());
    // Implementation depends on default settings defined elsewhere
    await load();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension SettingsCubitExtension on BuildContext {
  SettingsCubit get settingsCubit => read<SettingsCubit>();
  SettingsCubit get watchSettingsCubit => watch<SettingsCubit>();
}
