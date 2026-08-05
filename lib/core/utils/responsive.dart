import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

enum ScreenType { mobile, tablet, desktop }

/// Responsive layout utilities.
class Responsive {
  Responsive._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  static ScreenType screenType(BuildContext context) {
    final w = width(context);
    if (w < AppConstants.mobileBreakpoint) return ScreenType.mobile;
    if (w < AppConstants.tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      screenType(context) == ScreenType.mobile;

  static bool isTablet(BuildContext context) =>
      screenType(context) == ScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      screenType(context) == ScreenType.desktop;

  static bool isWebOrDesktop(BuildContext context) {
    final w = width(context);
    return w >= AppConstants.tabletBreakpoint;
  }

  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (screenType(context)) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  static int columns(BuildContext context) => value(
        context: context,
        mobile: 1,
        tablet: 2,
        desktop: 3,
      );

  static EdgeInsets pagePadding(BuildContext context) => EdgeInsets.symmetric(
        horizontal: value(context: context, mobile: 20.0, tablet: 32.0, desktop: 48.0),
        vertical: value(context: context, mobile: 24.0, tablet: 32.0, desktop: 48.0),
      );

  static double contentWidth(BuildContext context) {
    final w = width(context);
    return w > AppConstants.maxContentWidth ? AppConstants.maxContentWidth : w;
  }
}
