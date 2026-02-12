import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Main Colors
  static const Color midnightBlue = Color(0xFF003366);
  static const Color oldGold = Color(0xFFD4AF37);
  static const Color reefGold = Color(0xFF9E801C);
  static const Color slateGray = Color(0xFF6C7B8B);
  static const Color maroon = Color(0xFF800020);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color alto = Color(0xFFDCDCDC);
  static const Color transparent = Colors.transparent;

  // Semantic Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);

  // Dashboard & Charts Colors
  static const Color chartBlue = Color(0xFF26E5FF);
  static const Color chartOrange = Color(0xFFFFA113);
  static const Color chartYellow = Color(0xFFFFCF26);
  static const Color chartRed = Color(0xFFEE2727);
  static const Color chartSoftBlue = Color(0xFFA4CDFF);
  static const Color ratingStar = Colors.amber;

  // Theme Mapping
  static const Color primary = midnightBlue;
  static const Color secondary = oldGold;
  static const Color background = white;
  static const Color surface = white;

  static const Color textPrimary = midnightBlue;
  static const Color textSecondary = slateGray;

  static final Color barrierColor = black.withValues(alpha: 0.7);
  static final Color disabled = slateGray.withValues(alpha: 0.5);
}
