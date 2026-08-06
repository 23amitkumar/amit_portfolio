import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'screen_size.dart' as screen_size;

enum ScreenType { mobile, tablet, desktop }

/// Responsive layout utilities.
class Responsive {
  Responsive._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  /// Layout width adjusted for mobile browsers that request the desktop site.
  ///
  /// In that mode the layout viewport can be ~980px while the physical screen
  /// is still ~390px, which makes grids and cards render too small.
  static double effectiveWidth(BuildContext context) {
    final layoutWidth = width(context);
    if (!kIsWeb) return layoutWidth;

    final deviceWidth = screen_size.deviceScreenWidth;
    if (deviceWidth <= 0) return layoutWidth;

    if (deviceWidth < AppConstants.tabletBreakpoint && layoutWidth > deviceWidth) {
      return deviceWidth;
    }

    return layoutWidth;
  }

  static ScreenType screenType(BuildContext context) {
    final w = effectiveWidth(context);
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
    return effectiveWidth(context) >= AppConstants.tabletBreakpoint;
  }

  /// True when mouse hover effects should be enabled.
  static bool supportsHover(BuildContext context) {
    if (kIsWeb) return !isMobile(context);
    return isDesktop(context);
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
    final w = effectiveWidth(context);
    return w > AppConstants.maxContentWidth ? AppConstants.maxContentWidth : w;
  }
}
