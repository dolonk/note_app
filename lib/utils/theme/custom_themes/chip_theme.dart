import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DChipTheme {
  DChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: DColors.grey.withValues(alpha: (0.4 * 255)),
    labelStyle: GoogleFonts.poppins(color: DColors.black),
    selectedColor: DColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: DColors.white,
  );
}
