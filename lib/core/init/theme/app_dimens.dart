import 'package:flutter/material.dart';
import 'dart:ui';

class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xs; // 4
  final double s; // 8
  final double m; // 16
  final double l; // 24
  final double xl; // 32
  final double xxl; // 48
  final double xxxl; // 64

  const AppSpacing({
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  @override
  ThemeExtension<AppSpacing> copyWith({
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
    );
  }

  @override
  ThemeExtension<AppSpacing> lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      s: lerpDouble(s, other.s, t)!,
      m: lerpDouble(m, other.m, t)!,
      l: lerpDouble(l, other.l, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
    );
  }

  static const regular = AppSpacing(
    xs: 4,
    s: 8,
    m: 16,
    l: 24,
    xl: 32,
    xxl: 48,
    xxxl: 64,
  );
}

class AppRadius extends ThemeExtension<AppRadius> {
  final double small; // 4
  final double medium; // 8
  final double large; // 16
  final double xl; // 24
  final double xxl; // 32
  final double circular; // 999

  const AppRadius({
    required this.small,
    required this.medium,
    required this.large,
    required this.xl,
    required this.xxl,
    required this.circular,
  });

  @override
  ThemeExtension<AppRadius> copyWith({
    double? small,
    double? medium,
    double? large,
    double? xl,
    double? xxl,
    double? circular,
  }) {
    return AppRadius(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      circular: circular ?? this.circular,
    );
  }

  @override
  ThemeExtension<AppRadius> lerp(ThemeExtension<AppRadius>? other, double t) {
    if (other is! AppRadius) return this;
    return AppRadius(
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      circular: lerpDouble(circular, other.circular, t)!,
    );
  }

  static const regular = AppRadius(
    small: 4,
    medium: 8,
    large: 16,
    xl: 24,
    xxl: 32,
    circular: 999,
  );
}

class AppLayout extends ThemeExtension<AppLayout> {
  final double buttonHeight; // 56
  final double buttonHeightSmall; // 40
  final double inputHeight; // 56
  final double iconSmall; // 16
  final double iconMedium; // 24
  final double iconLarge; // 32
  final double pageMargin; // 16 or 24

  const AppLayout({
    required this.buttonHeight,
    required this.buttonHeightSmall,
    required this.inputHeight,
    required this.iconSmall,
    required this.iconMedium,
    required this.iconLarge,
    required this.pageMargin,
  });

  @override
  ThemeExtension<AppLayout> copyWith({
    double? buttonHeight,
    double? buttonHeightSmall,
    double? inputHeight,
    double? iconSmall,
    double? iconMedium,
    double? iconLarge,
    double? pageMargin,
  }) {
    return AppLayout(
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonHeightSmall: buttonHeightSmall ?? this.buttonHeightSmall,
      inputHeight: inputHeight ?? this.inputHeight,
      iconSmall: iconSmall ?? this.iconSmall,
      iconMedium: iconMedium ?? this.iconMedium,
      iconLarge: iconLarge ?? this.iconLarge,
      pageMargin: pageMargin ?? this.pageMargin,
    );
  }

  @override
  ThemeExtension<AppLayout> lerp(ThemeExtension<AppLayout>? other, double t) {
    if (other is! AppLayout) return this;
    return AppLayout(
      buttonHeight: lerpDouble(buttonHeight, other.buttonHeight, t)!,
      buttonHeightSmall: lerpDouble(
        buttonHeightSmall,
        other.buttonHeightSmall,
        t,
      )!,
      inputHeight: lerpDouble(inputHeight, other.inputHeight, t)!,
      iconSmall: lerpDouble(iconSmall, other.iconSmall, t)!,
      iconMedium: lerpDouble(iconMedium, other.iconMedium, t)!,
      iconLarge: lerpDouble(iconLarge, other.iconLarge, t)!,
      pageMargin: lerpDouble(pageMargin, other.pageMargin, t)!,
    );
  }

  static const regular = AppLayout(
    buttonHeight: 56,
    buttonHeightSmall: 40,
    inputHeight: 56,
    iconSmall: 16,
    iconMedium: 24,
    iconLarge: 32,
    pageMargin: 16,
  );
}
