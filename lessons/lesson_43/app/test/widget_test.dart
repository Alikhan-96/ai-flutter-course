import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/app.dart';
import 'package:app/app_config.dart';

void main() {
  setUpAll(() {
    AppConfig.init(Flavor.dev);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
