import 'package:flutter_test/flutter_test.dart';

import 'package:wisecare_agent/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WiseCareAgentApp());
    await tester.pumpAndSettle();
  });
}
