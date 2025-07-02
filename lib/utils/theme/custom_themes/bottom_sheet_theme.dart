import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class DBottomSheetTheme {
  DBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    dragHandleColor: DColors.primary,
    backgroundColor: DColors.white,
    modalBackgroundColor: DColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
  );
}
