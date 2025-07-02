import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../default_sizes/sizes.dart';

class DOutlinedButtonTheme {
  DOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: DColors.dark,
      side: const BorderSide(color: DColors.borderPrimary),
      textStyle: GoogleFonts.poppins(fontSize: 16, color: DColors.black, fontWeight: FontWeight.w600),
      padding: EdgeInsets.symmetric(vertical: DSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DSizes.buttonRadius)),
    ),
  );
}
