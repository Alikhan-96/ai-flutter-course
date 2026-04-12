import 'dart:async';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('list screen goes from empty state to loading to loaded items', (
    WidgetTester tester,
  ) async {
    final repository = FakeTasksRepository();
    final fetchCompleter = Completer<List<Task>>();
    repository.fetchTasksHandler = () => fetchCompleter.future;

    await tester.pumpWidget(TaskApp(repository: repository));

    expect(find.byKey(const Key('emptyState')), findsOneWidget);

    await tester.tap(find.byKey(const Key('loadTasksButton')));
    await tester.pump();

    expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);

    fetchCompleter.complete(<Task>[
      const Task(
        id: '1',
        title: 'Test Task',
        description: 'Loaded from fake repository',
      ),
    ]);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Test Task'), findsOneWidget);
  });

  testWidgets('add button adds item to list after entering text', (
    WidgetTester tester,
  ) async {
    final repository = FakeTasksRepository();

    await tester.pumpWidget(TaskApp(repository: repository));

    await tester.enterText(find.byKey(const Key('taskInput')), 'New Task');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);
  });

  testWidgets('error state shows text and snackbar when loading fails', (
    WidgetTester tester,
  ) async {
    final repository = FakeTasksRepository()
      ..fetchTasksHandler = () async {
        throw Exception('Backend offline');
      };

    await tester.pumpWidget(TaskApp(repository: repository));

    await tester.tap(find.byKey(const Key('loadTasksButton')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('errorMessage')), findsOneWidget);
    expect(find.textContaining('Backend offline'), findsWidgets);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('tapping a task opens the details screen', (
    WidgetTester tester,
  ) async {
    final repository = FakeTasksRepository()
      ..fetchTasksHandler = () async {
        return const <Task>[
          Task(
            id: '42',
            title: 'Open details',
            description: 'Navigation target',
          ),
        ];
      };

    await tester.pumpWidget(TaskApp(repository: repository));

    await tester.tap(find.byKey(const Key('loadTasksButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('taskItem-42')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('taskDetails')), findsOneWidget);
    expect(find.text('Open details'), findsOneWidget);
    expect(find.text('Navigation target'), findsOneWidget);
  });
}

class FakeTasksRepository implements TasksRepository {
  Future<List<Task>> Function()? fetchTasksHandler;
  Future<Task> Function(String title)? addTaskHandler;

  final List<Task> _tasks = <Task>[];

  @override
  Future<Task> addTask(String title) async {
    if (addTaskHandler != null) {
      return addTaskHandler!(title);
    }

    final task = Task(
      id: (_tasks.length + 1).toString(),
      title: title,
      description: 'Created in widget test',
    );
    _tasks.add(task);
    return task;
  }

  @override
  Future<List<Task>> fetchTasks() async {
    if (fetchTasksHandler != null) {
      return fetchTasksHandler!();
    }

    return List<Task>.from(_tasks);
  }
}
