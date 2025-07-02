import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import '../../default_sizes/sizes.dart';

class DTextFormFieldTheme {
  DTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: DColors.darkGrey,
    suffixIconColor: DColors.darkGrey,
    errorStyle: GoogleFonts.poppins(fontStyle: FontStyle.normal),
    floatingLabelStyle: GoogleFonts.poppins(color: DColors.black.withAlpha(8)),
    labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: DColors.black),
    hintStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xffA1A1A1)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: DColors.grey),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: DColors.grey),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: DColors.dark),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: DColors.warning),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: DColors.warning),
    ),
  );
}
