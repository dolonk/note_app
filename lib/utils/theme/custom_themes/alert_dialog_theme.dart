import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

class DAlertDialogTheme {
  DAlertDialogTheme._();
  static DialogTheme alertDialogThemeTheme = DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: DColors.white,
    contentTextStyle: GoogleFonts.poppins(color: DColors.primary),
  );
}
