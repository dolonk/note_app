import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../default_sizes/sizes.dart';

class DAppBarTheme {
  DAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: DColors.black, size: DSizes.iconMd),
    actionsIconTheme: IconThemeData(color: DColors.black, size: DSizes.iconMd),
    titleTextStyle: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color: DColors.black),
  );
}
