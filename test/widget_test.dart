import 'package:flutter_test/flutter_test.dart';

import 'package:amit_porfolio/core/constants/app_constants.dart';
import 'package:amit_porfolio/core/routes/app_routes.dart';

void main() {
  test('Portfolio constants smoke test', () {
    expect(AppConstants.developerName, contains('Amit'));
    expect(AppRoutes.testimonials, '/testimonials');
  });
}
