import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'custom_themes/alert_dialog_theme.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/progress_indicator_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class DAppTheme {
  DAppTheme._();

  /// -- Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    disabledColor: DColors.grey,
    brightness: Brightness.light,
    primaryColor: DColors.primary,
    textTheme: DTextTheme.lightTextTheme,
    chipTheme: DChipTheme.lightChipTheme,
    scaffoldBackgroundColor: DColors.white,
    appBarTheme: DAppBarTheme.lightAppBarTheme,
    fontFamily: GoogleFonts.poppins().fontFamily,
    checkboxTheme: DCheckBoxTheme.lightCheckboxTheme,
    dialogTheme: DAlertDialogTheme.alertDialogThemeTheme,
    bottomSheetTheme: DBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: DElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: DOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: DTextFormFieldTheme.lightInputDecorationTheme,
    progressIndicatorTheme: DProgressIndicatorTheme.lightProgressIndicatorTheme,
  );
}
