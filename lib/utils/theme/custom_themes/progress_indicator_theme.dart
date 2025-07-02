import '../../constants/colors.dart';
import 'package:flutter/material.dart';

class DProgressIndicatorTheme {
  DProgressIndicatorTheme._();

  /// Light theme for progress indicators
  static ProgressIndicatorThemeData lightProgressIndicatorTheme = ProgressIndicatorThemeData(
    color: DColors.primary,
    linearTrackColor: Colors.grey.shade800,
    circularTrackColor: Colors.grey.shade700,
    linearMinHeight: 4.0,
  );
}
