import 'package:app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLocalDatabase extends Mock implements LocalDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const <Task>[]);
  });

  group('TasksRepository', () {
    test(
      'login delegates to api client and stores session in database',
      () async {
        final apiClient = MockApiClient();
        final database = MockLocalDatabase();
        final repository = TasksRepository(
          apiClient: apiClient,
          database: database,
        );

        when(
          () => apiClient.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
        when(() => database.saveSession(any())).thenAnswer((_) async {});

        await repository.login(email: 'test@mail.com', password: '123456');

        verify(
          () => apiClient.login(email: 'test@mail.com', password: '123456'),
        ).called(1);
        verify(() => database.saveSession('test@mail.com')).called(1);
      },
    );

    test('getTasks loads json from api and caches mapped tasks', () async {
      final apiClient = MockApiClient();
      final database = MockLocalDatabase();
      final repository = TasksRepository(
        apiClient: apiClient,
        database: database,
      );

      when(() => apiClient.getTasks()).thenAnswer(
        (_) async => const <Map<String, dynamic>>[
          <String, dynamic>{'id': '1', 'title': 'Mocked task'},
        ],
      );
      when(() => database.cacheTasks(any())).thenAnswer((_) async {});

      final tasks = await repository.getTasks();

      expect(tasks.single.title, 'Mocked task');
      verify(() => apiClient.getTasks()).called(1);
      verify(
        () => database.cacheTasks(
          any(
            that: isA<List<Task>>().having(
              (list) => list.single.title,
              'first title',
              'Mocked task',
            ),
          ),
        ),
      ).called(1);
    });

    test('getTasks falls back to cached tasks when api fails', () async {
      final apiClient = MockApiClient();
      final database = MockLocalDatabase();
      final repository = TasksRepository(
        apiClient: apiClient,
        database: database,
      );

      when(() => apiClient.getTasks()).thenThrow(Exception('Network error'));
      when(() => database.getCachedTasks()).thenAnswer(
        (_) async => const <Task>[Task(id: '7', title: 'Cached task')],
      );

      final tasks = await repository.getTasks();

      expect(tasks.single.title, 'Cached task');
      verify(() => apiClient.getTasks()).called(1);
      verify(() => database.getCachedTasks()).called(1);
    });

    test('addTask uses mocked api and refreshes cached tasks', () async {
      final apiClient = MockApiClient();
      final database = MockLocalDatabase();
      final repository = TasksRepository(
        apiClient: apiClient,
        database: database,
      );

      when(() => apiClient.addTask('New task')).thenAnswer(
        (_) async => const <String, dynamic>{'id': '3', 'title': 'New task'},
      );
      when(() => database.getCachedTasks()).thenAnswer(
        (_) async => const <Task>[Task(id: '1', title: 'Existing task')],
      );
      when(() => database.cacheTasks(any())).thenAnswer((_) async {});

      final task = await repository.addTask('New task');

      expect(task.title, 'New task');
      verify(() => apiClient.addTask('New task')).called(1);
      verify(
        () => database.cacheTasks(
          any(
            that: isA<List<Task>>().having((list) => list.length, 'length', 2),
          ),
        ),
      ).called(1);
    });
  });
}
