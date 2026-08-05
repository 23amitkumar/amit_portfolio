import 'package:flutter/material.dart';

export 'package:get/get.dart';

/// Useful extensions on BuildContext and numbers.
extension PortfolioContext on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
}

extension DoubleExtensions on double {
  Widget get verticalSpace => SizedBox(height: this);
  Widget get horizontalSpace => SizedBox(width: this);
}

extension IntExtensions on int {
  Widget get verticalSpace => SizedBox(height: toDouble());
  Widget get horizontalSpace => SizedBox(width: toDouble());
}
