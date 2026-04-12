import 'package:app/data/dto/task_dto.dart';
import 'package:app/data/mappers/task_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/task_fixtures.dart';

void main() {
  group('Task mapper', () {
    test('maps DTO with integer timestamp to domain', () {
      final dto = TaskDto.fromJson(TaskFixtures.dtoJsonWithIntTimestamp());

      final task = dto.toDomain();

      expect(task.id, TaskFixtures.taskId);
      expect(task.title, 'Write mapper tests');
      expect(task.isDone, isTrue);
      expect(task.createdAt, TaskFixtures.createdAt);
    });

    test('maps DTO with ISO timestamp string to domain', () {
      final dto = TaskDto.fromJson(
        TaskFixtures.dtoJsonWithIsoStringTimestamp(),
      );

      final task = dto.toDomain();

      expect(task.id, 'task-iso');
      expect(task.title, 'Check ISO parsing');
      expect(task.isDone, isFalse);
      expect(task.createdAt, TaskFixtures.anotherCreatedAt);
    });

    test('maps DTO with DateTime payload to domain', () {
      final dto = TaskDto.fromJson(TaskFixtures.dtoJsonWithDateTimeTimestamp());

      final task = dto.toDomain();

      expect(task.id, 'task-date-time');
      expect(task.title, 'DateTime object payload');
      expect(task.isDone, isTrue);
      expect(task.createdAt, TaskFixtures.anotherCreatedAt);
    });

    test('uses defaults for null and blank mapper values', () {
      final nullDto = TaskDto.fromJson(TaskFixtures.dtoJsonWithNullFields());
      final blankTitleDto = TaskDto.fromJson(
        TaskFixtures.dtoJsonWithBlankTitle(),
      );

      final nullTask = nullDto.toDomain();
      final blankTask = blankTitleDto.toDomain();

      expect(nullTask.title, 'Untitled task');
      expect(nullTask.isDone, isFalse);
      expect(nullTask.createdAt, TaskFixtures.epoch);
      expect(blankTask.title, 'Untitled task');
    });

    test('maps domain model back to DTO json with snake case fields', () {
      final dto = TaskFixtures.validTask().toDto();

      expect(dto.toJson(), <String, dynamic>{
        'id': 'task-use-case',
        'title': 'Write use case tests',
        'is_done': false,
        'created_at': TaskFixtures.createdAt.millisecondsSinceEpoch,
      });
    });
  });
}
