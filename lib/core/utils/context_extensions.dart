import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  // --- Device Utilities ---
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1200;
  bool get isDesktop => width >= 1200;

  // --- Responsive Method ---
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // --- Theme Accessors ---
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;

  // --- Extension Accessors ---
  AppSpacing get spacing => theme.extension<AppSpacing>()!;
  AppRadius get radius => theme.extension<AppRadius>()!;
  AppOpacity get opacity => theme.extension<AppOpacity>()!;
  AppLayout get layout => theme.extension<AppLayout>()!;

  // --- Localization ---
  AppLocalizations get loc => AppLocalizations.of(this)!;
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;
}

// --- UI HELPERS (Responsive & Semantic) ---
extension UIHelpersExtension on BuildContext {
  // Vertical Spacing (Responsive Height)
  SizedBox get vSpaceXS => SizedBox(height: spacing.xs.h);
  SizedBox get vSpaceS => SizedBox(height: spacing.s.h);
  SizedBox get vSpaceM => SizedBox(height: spacing.m.h);
  SizedBox get vSpaceL => SizedBox(height: spacing.l.h);
  SizedBox get vSpaceXL => SizedBox(height: spacing.xl.h);
  SizedBox get vSpaceXXL => SizedBox(height: spacing.xxl.h);

  // Horizontal Spacing (Responsive Width)
  SizedBox get hSpaceXS => SizedBox(width: spacing.xs.w);
  SizedBox get hSpaceS => SizedBox(width: spacing.s.w);
  SizedBox get hSpaceM => SizedBox(width: spacing.m.w);
  SizedBox get hSpaceL => SizedBox(width: spacing.l.w);

  // Padding - All Sides (Responsive)
  EdgeInsets get paddingAllS => EdgeInsets.all(spacing.s.w);
  EdgeInsets get paddingAllM => EdgeInsets.all(spacing.m.w);
  EdgeInsets get paddingAllL => EdgeInsets.all(spacing.l.w);

  // Padding - Symmetric
  EdgeInsets get paddingHorizontalM =>
      EdgeInsets.symmetric(horizontal: spacing.m.w);
  EdgeInsets get paddingVerticalM =>
      EdgeInsets.symmetric(vertical: spacing.m.h);

  // Page Padding (Standard Screen Padding)
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: layout.pageMargin.w,
    vertical: layout.pageMargin.h,
  );
}

extension NumExtension on num {
  BorderRadius get radius => BorderRadius.circular(toDouble());

  Duration get ms => Duration(milliseconds: toInt());
  Duration get sec => Duration(seconds: toInt());
}
