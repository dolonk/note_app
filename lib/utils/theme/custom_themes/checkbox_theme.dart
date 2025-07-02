import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../default_sizes/sizes.dart';

class DCheckBoxTheme {
  DCheckBoxTheme._();

  /// Customizable Light Text Theme
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DSizes.paddingXs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return DColors.white;
      } else {
        return DColors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return DColors.primary;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
