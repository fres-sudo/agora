part of 'theme_cubit.dart';

ThemeMode? activeThemeMode(ThemeState state) => switch (state) {
  SettedThemeState() => state.mode,
  _ => null,
};
