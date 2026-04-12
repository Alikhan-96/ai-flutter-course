import 'package:app/domain/usecases/add_task_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_tasks_repository.dart';
import 'fixtures/task_fixtures.dart';

void main() {
  group('AddTaskUseCase', () {
    test('adds a task through the repository', () async {
      final repository = FakeTasksRepository();
      final useCase = AddTaskUseCase(repository);
      final task = TaskFixtures.validTask(title: '  Write tests with AAA  ');

      await useCase(task);

      expect(repository.addCalled, isTrue);
      expect(repository.addedTask?.title, 'Write tests with AAA');
    });

    test('throws expected validation message for empty title', () async {
      final repository = FakeTasksRepository();
      final useCase = AddTaskUseCase(repository);
      final task = TaskFixtures.validTask(title: '   ');

      await expectLater(
        () => useCase(task),
        throwsA(
          isA<TaskValidationException>().having(
            (exception) => exception.message,
            'message',
            'Task title cannot be empty',
          ),
        ),
      );
      expect(repository.addCalled, isFalse);
    });

    test('propagates repository failures with expected message', () async {
      final repository = FakeTasksRepository(
        errorToThrow: Exception('Repository failed to save task'),
      );
      final useCase = AddTaskUseCase(repository);

      await expectLater(
        () => useCase(TaskFixtures.validTask()),
        throwsA(
          isA<Exception>().having(
            (exception) => exception.toString(),
            'message',
            'Exception: Repository failed to save task',
          ),
        ),
      );
      expect(repository.addCalled, isTrue);
    });
  });
}
