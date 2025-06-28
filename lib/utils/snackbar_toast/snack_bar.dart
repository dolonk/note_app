import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../constants/colors.dart';
import '../global_context.dart';

class DSnackBar {
  DSnackBar._();

  /// ✅ Show Success SnackBar
  static void success({required String title, String message = '', int durationInSeconds = 3}) {
    _show(
      title: title,
      message: message,
      backgroundColor: DColors.success,
      duration: durationInSeconds,
      icon: Iconsax.check,
    );
  }

  /// ⚠️ Show Warning SnackBar
  static void warning({required String title, String message = '', int durationInSeconds = 3}) {
    _show(
      title: title,
      message: message,
      backgroundColor: DColors.warning,
      duration: durationInSeconds,
      icon: Iconsax.warning_2,
    );
  }

  /// ❌ Show Error SnackBar
  static void error({required String title, String message = '', int durationInSeconds = 3}) {
    _show(
      title: title,
      message: message,
      backgroundColor: DColors.error,
      duration: durationInSeconds,
      icon: Icons.error,
    );
  }

  /// 🔐 Base SnackBar Builder
  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required int duration,
    required IconData icon,
  }) {
    final context = GlobalContext.context;

    if (context == null) {
      debugPrint('❌ GlobalContext is null! SnackBar not shown.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        duration: Duration(seconds: duration),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                  ),
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(message, style: const TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
