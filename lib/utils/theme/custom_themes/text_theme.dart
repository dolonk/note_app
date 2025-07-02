import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DTextTheme {
  DTextTheme._();

  static TextTheme lightTextTheme = GoogleFonts.poppinsTextTheme().copyWith(
    displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: DColors.textPrimary),
    displayMedium: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: DColors.textPrimary),
    displaySmall: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: DColors.textPrimary),

    headlineLarge: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: DColors.textPrimary),
    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: DColors.textPrimary),
    headlineSmall: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: DColors.textPrimary),

    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: DColors.textPrimary),
    titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: DColors.textPrimary),
    titleSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: DColors.textPrimary),

    bodyLarge: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: DColors.bodyTextColor),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: DColors.bodyTextColor),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: DColors.bodyTextColor),

    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: DColors.bodyTextColor),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: DColors.bodyTextColor),
    labelSmall: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: DColors.bodyTextColor),
  );
}
