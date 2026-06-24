part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.setting() = SettingThemeState;

  const factory ThemeState.setted(ThemeMode mode) = SettedThemeState;

  const factory ThemeState.errorsetting() = ErrorsettingThemeState;
}
