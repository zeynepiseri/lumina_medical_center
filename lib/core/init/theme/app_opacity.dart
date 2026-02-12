import 'package:flutter/material.dart';
import 'dart:ui';

class AppOpacity extends ThemeExtension<AppOpacity> {
  final double faint; // 0.05
  final double subtle; // 0.1
  final double medium; // 0.3
  final double high; // 0.6
  final double barrier; // 0.7

  const AppOpacity({
    required this.faint,
    required this.subtle,
    required this.medium,
    required this.high,
    required this.barrier,
  });

  @override
  ThemeExtension<AppOpacity> copyWith({
    double? faint,
    double? subtle,
    double? medium,
    double? high,
    double? barrier,
  }) {
    return AppOpacity(
      faint: faint ?? this.faint,
      subtle: subtle ?? this.subtle,
      medium: medium ?? this.medium,
      high: high ?? this.high,
      barrier: barrier ?? this.barrier,
    );
  }

  @override
  ThemeExtension<AppOpacity> lerp(ThemeExtension<AppOpacity>? other, double t) {
    if (other is! AppOpacity) return this;
    return AppOpacity(
      faint: lerpDouble(faint, other.faint, t)!,
      subtle: lerpDouble(subtle, other.subtle, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      high: lerpDouble(high, other.high, t)!,
      barrier: lerpDouble(barrier, other.barrier, t)!,
    );
  }

  static const regular = AppOpacity(
    faint: 0.05,
    subtle: 0.1,
    medium: 0.3,
    high: 0.6,
    barrier: 0.7,
  );
}
