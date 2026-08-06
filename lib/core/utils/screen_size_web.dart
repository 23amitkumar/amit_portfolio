import 'package:web/web.dart' as web;

/// Physical screen width in CSS pixels (stable even when mobile browsers
/// request the desktop site and inflate the layout viewport).
double get deviceScreenWidth => web.window.screen.width.toDouble();

double get deviceScreenHeight => web.window.screen.height.toDouble();
