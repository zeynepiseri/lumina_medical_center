import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final Color topBarColor;
  final bool? overrideStatusBarIconsLight;

  const BaseScreen({
    super.key,
    required this.body,
    this.backgroundColor,
    required this.topBarColor,
    this.overrideStatusBarIconsLight,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBackgroundDark = overrideStatusBarIconsLight != null
        ? overrideStatusBarIconsLight!
        : topBarColor.isDark;
    final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isBackgroundDark
          ? Brightness.light
          : Brightness.dark,
      statusBarBrightness: isBackgroundDark
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: isBackgroundDark
          ? Brightness.light
          : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        extendBodyBehindAppBar: true,
        extendBody: true,

        body: body,
      ),
    );
  }
}

extension ColorBrightness on Color {
  bool get isDark => computeLuminance() < 0.5;
  bool get isLight => !isDark;
}
