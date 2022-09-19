import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_project/Utils/constants.dart';

class AppTheme {
  static TextTheme lightMode = TextTheme(
    titleLarge: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: kwhite.withOpacity(0.8),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    titleSmall: GoogleFonts.roboto(
      color: kwhite,
      height: 1.5,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.roboto(
      color: ksecondary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: GoogleFonts.roboto(
      color: ksecondary,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: GoogleFonts.roboto(
      color: ksecondary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.roboto(
      color: kblack,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: kwhite.withOpacity(0.7),
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.roboto(
      color: kblack.withOpacity(0.7),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: GoogleFonts.roboto(
      color: kblack.withOpacity(0.8),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: kblack.withOpacity(0.8),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: GoogleFonts.roboto(
      color: kblack.withOpacity(0.8),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.roboto(
      color: kblack.withOpacity(0.4),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextTheme darkMode = TextTheme(
    titleLarge: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: GoogleFonts.roboto(
      color: kwhite.withOpacity(0.8),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.roboto(
      color: ksecondary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: GoogleFonts.roboto(
      color: ksecondary,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: GoogleFonts.roboto(
      color: ksecondary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.roboto(
      color: kwhite,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
  static light() {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: kwhite,
        textTheme: lightMode,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kblack),
        textSelectionTheme: TextSelectionThemeData(selectionColor: kprimary));
  }

  static dark() {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: kblack,
        textTheme: lightMode,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kprimary));
  }
}
