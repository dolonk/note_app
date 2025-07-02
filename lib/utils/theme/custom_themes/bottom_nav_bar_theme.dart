import 'package:flutter/material.dart';

import '../../default_sizes/sizes.dart';

class DPaddingTheme {
  DPaddingTheme._();

  static EdgeInsets bottomNavigationBarPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      DSizes.spaceBtwItems,
      DSizes.spaceBtwItems,
      DSizes.spaceBtwItems,
      DSizes.spaceBtwItems + MediaQuery.of(context).viewPadding.bottom,
    );
  }
}
