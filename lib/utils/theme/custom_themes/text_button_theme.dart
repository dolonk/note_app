import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class DTextButtonTheme {
  DTextButtonTheme._();

  static final lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: DColors.textButtonPrimary,
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  );
}
