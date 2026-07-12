import 'package:flutter/material.dart';

/// Raw, brightness-agnostic color ramps — the single source of truth for every
/// pixel of color in the design system.
///
/// **Do not consume [AppPalette] directly in widgets.** It has no notion of
/// light vs dark. Instead read semantic tokens via `context.colors` (see
/// [AppColors]), which map these primitives onto meaning (background, primary,
/// border, …) per [Brightness]. Reaching for a raw ramp inside a widget is the
/// bug this layer exists to prevent.
abstract final class AppPalette {
  // Absolutes
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);
  static const Color transparent = Color(0x00000000);

  // Brand green — kept for callers that want a decorative accent outside the
  // token system. Not the semantic "primary" (see AppColors), which resolves
  // to a neutral shade for the shadcn/Notion-style grey look.
  static const Color primary50 = Color(0xffF2FAF7);
  static const Color primary100 = Color(0xffDAF4E6);
  static const Color primary200 = Color(0xffBEEDD2);
  static const Color primary300 = Color(0xff99E4B8);
  static const Color primary400 = Color(0xff6AD896);
  static const Color primary500 = Color(0xff34CB6F);
  static const Color primary600 = Color(0xff2EB362);
  static const Color primary700 = Color(0xff289E56);
  static const Color primary800 = Color(0xff218347);
  static const Color primary900 = Color(0xff1A6637);

  // Neutral (gray)
  static const Color neutral0 = white;
  static const Color neutral50 = Color(0xffFAFAFA);
  static const Color neutral100 = Color(0xffF7F7F7);
  static const Color neutral200 = Color(0xffE5E5E5);
  static const Color neutral300 = Color(0xffD7D7D7);
  static const Color neutral400 = Color(0xffA3A3A3);
  static const Color neutral500 = Color(0xff757575);
  static const Color neutral600 = Color(0xff525252);
  static const Color neutral700 = Color(0xff464646);
  static const Color neutral800 = Color(0xff282828);
  static const Color neutral900 = Color(0xff141414);
  static const Color neutral950 = Color(0xff0A0A0A);

  // Success
  static const Color success100 = Color(0xffDEF7EC);
  static const Color success500 = Color(0xff17B26A);
  static const Color success600 = Color(0xff079455);
  static const Color success700 = Color(0xff046C4E);

  // Error / destructive
  static const Color error100 = Color(0xffFEEDEA);
  static const Color error200 = Color(0xffFAC8BC);
  static const Color error300 = Color(0xffF5886F);
  static const Color error400 = Color(0xffF37153);
  static const Color error500 = Color(0xffF04D28);
  static const Color error700 = Color(0xffC81E1E);

  // Warning
  static const Color warning100 = Color(0xffFFE5B0);
  static const Color warning200 = Color(0xffFFE5B0);
  static const Color warning300 = Color(0xffFFC754);
  static const Color warning400 = Color(0xffFFBC33);
  static const Color warning500 = Color(0xffFFAB00);
  static const Color warning600 = Color(0xffD97706);

  // Info
  static const Color info100 = Color(0xffE8F4FF);
  static const Color info200 = Color(0xffB9DDFE);
  static const Color info300 = Color(0xff68B5FC);
  static const Color info400 = Color(0xff4AA6FC);
  static const Color info500 = Color(0xff1D90FB);
}
