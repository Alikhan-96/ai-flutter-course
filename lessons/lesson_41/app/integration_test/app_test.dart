import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login, list, add, and logout flow uses test dependencies', (
    WidgetTester tester,
  ) async {
    final dependencies = AppDependencies.test(
      apiClient: FakeApiClient(
        initialTasks: const <Map<String, dynamic>>[
          <String, dynamic>{'id': '1', 'title': 'Existing task'},
        ],
      ),
      database: InMemoryLocalDatabase(),
    );

    expect(dependencies.apiClient, isA<FakeApiClient>());
    expect(dependencies.database, isA<InMemoryLocalDatabase>());

    await tester.pumpWidget(Lesson41App(dependencies: dependencies));

    await tester.enterText(find.byKey(const Key('email')), 'test@mail.com');
    await tester.enterText(find.byKey(const Key('password')), '123456');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.text('Existing task'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('taskInput')), 'New Task');
    await tester.tap(find.byKey(const Key('addButton')));
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);

    await tester.tap(find.byKey(const Key('logoutButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('loginButton')), findsOneWidget);
    expect(find.text('New Task'), findsNothing);
  });
}
