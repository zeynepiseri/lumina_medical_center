import 'package:flutter/material.dart';

extension ColorExtension on Color {
  bool get isDark => computeLuminance() < 0.5;
  bool get isLight => !isDark;
  Color get contrastText => isDark ? Colors.white : Colors.black;
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  Color fade(double value) {
    return withValues(alpha: value);
  }

  Color get subtle => fade(0.1);
}

extension HexStringExtension on String {
  Color get toColor {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }
    buffer.write(replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.black;
    }
  }
}
