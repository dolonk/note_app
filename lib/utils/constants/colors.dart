import 'package:flutter/material.dart';

class DColors {
  DColors._();

  // 🔷 Primary Theme Colors
  static const Color primary = Color(0xff004368);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFB0C7FF);

  // 🔤 Text Colors
  static const Color textPrimary = Color(0xFF7B7B7B);
  static const Color textSecondary = Color(0xFF004368);
  static const bodyTextColor = Colors.black87;
  static const Color textWhite = Colors.white;

  // 🗂️ Card Text Colors
  static const Color cardTextPrimary = Color(0xFF181818);
  static const Color cardTextSecondary = Color(0xFF004368);

  // 🎨 Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // 🧱 Container Backgrounds
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color get darkContainer => white.withOpacity(0.1); // getter better for readability


  // 🔘 Buttons
  static const Color buttonPrimary = Color(0xff004368);
  static const Color buttonSecondary = Color(0xff6C757D);
  static const Color textButtonPrimary = Color(0xE035707D);
  static const Color buttonDisabled = Color(0xffC4C4C4);

  // 🛑 Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // ⚠️ Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // ⚫ Neutral Colors
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
