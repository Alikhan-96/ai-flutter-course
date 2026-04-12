import 'package:app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('release checklist screen shows core release tasks', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ReleaseChecklistApp());

    expect(find.text('Lesson 42: Release Checklist'), findsOneWidget);
    expect(
      find.textContaining('Android versionName/versionCode updated'),
      findsOneWidget,
    );
    expect(find.text('flutter build appbundle --release'), findsOneWidget);
  });
}
