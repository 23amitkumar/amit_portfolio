import 'package:flutter_test/flutter_test.dart';

import 'package:amit_porfolio/main.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Amit'), findsWidgets);
  });
}
