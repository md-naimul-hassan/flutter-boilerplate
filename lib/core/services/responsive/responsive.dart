import 'dart:ui';

import 'package:flutter/material.dart';

class Responsive {
  Responsive._(); // Prevent instantiation

  /// Breakpoints (logical pixels)
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  /// Current Flutter view
  static FlutterView _view(BuildContext context) =>
      View.of(context);

  /// Screen width (logical pixels)
  static double width(BuildContext context) {
    final view = _view(context);
    return view.physicalSize.width / view.devicePixelRatio;
  }

  /// Screen height (logical pixels)
  static double height(BuildContext context) {
    final view = _view(context);
    return view.physicalSize.height / view.devicePixelRatio;
  }

  /// Device type helpers
  static bool isMobile(BuildContext context) =>
      width(context) < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      width(context) >= mobileMaxWidth &&
          width(context) < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      width(context) >= tabletMaxWidth;
}
