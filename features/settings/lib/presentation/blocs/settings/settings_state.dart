part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const SettingsState._();

  /// Loading settings.
  const factory SettingsState.loading() = _Loading;

  /// Loaded with settings map.
  const factory SettingsState.loaded({
    required Map<String, String> settings,
  }) = SettingsLoaded;

  /// Saving a setting.
  const factory SettingsState.saving({
    required Map<String, String> settings,
  }) = _Saving;

  /// Error state.
  const factory SettingsState.error({
    required String message,
  }) = _Error;

  /// Returns true if settings are loaded.
  bool get isLoaded => this is SettingsLoaded || this is _Saving;

  /// Returns the settings map.
  Map<String, String> get settings => maybeMap(
        loaded: (s) => s.settings,
        saving: (s) => s.settings,
        orElse: () => {},
      );
}
