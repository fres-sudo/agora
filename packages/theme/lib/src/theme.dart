import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static final textTheme = GoogleFonts.plusJakartaSansTextTheme();

  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.primary500,
    scaffoldBackgroundColor: const Color(0xffF7F7F7),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary500,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.neutral100,
      centerTitle: false,
      titleTextStyle: textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      shape: const Border(
        bottom: BorderSide(color: AppColors.neutral200, width: 1),
      ),
      elevation: 0,
    ),
    textTheme: textTheme,
  );
}

abstract class AppColors {
  // Primary colors
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

  // Neutral colors
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

  // Success colors
  static const Color success100 = Color(0xffDEF7EC);
  static const Color success700 = Color(0xff046C4E);

  // Error colors
  static const Color error100 = Color(0xffFEEDEA);
  static const Color error200 = Color(0xffFAC8BC);
  static const Color error300 = Color(0xffF5886F);
  static const Color error400 = Color(0xffF37153);
  static const Color error500 = Color(0xffF04D28);
  static const Color error700 = Color(0xffC81E1E);

  // Warning colors
  static const Color warning100 = Color(0xffFFE5B0);
  static const Color warning200 = Color(0xffFFE5B0);
  static const Color warning300 = Color(0xffFFC754);
  static const Color warning400 = Color(0xffFFBC33);
  static const Color warning500 = Color(0xffFFAB00);
  static const Color warning600 = Color(0xffD97706);

  // Info colors
  static const Color info100 = Color(0xffE8F4FF);
  static const Color info200 = Color(0xffB9DDFE);
  static const Color info300 = Color(0xff68B5FC);
  static const Color info400 = Color(0xff4AA6FC);
  static const Color info500 = Color(0xff1D90FB);
}


