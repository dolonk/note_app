import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import '../../default_sizes/sizes.dart';
import 'package:google_fonts/google_fonts.dart';

class DElevatedButtonTheme {
  DElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: DColors.light,
      backgroundColor: DColors.buttonPrimary,
      disabledForegroundColor: DColors.darkGrey,
      disabledBackgroundColor: DColors.buttonDisabled,
      side: const BorderSide(color: DColors.buttonPrimary),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: DColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DSizes.buttonRadius)),
    ),
  );
}
