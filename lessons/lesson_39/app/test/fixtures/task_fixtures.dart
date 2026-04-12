import 'package:app/domain/entities/task.dart';

class TaskFixtures {
  static const taskId = 'task-1';
  static final createdAt = DateTime.utc(2024, 1, 15, 10, 30);
  static final anotherCreatedAt = DateTime.utc(2024, 2, 1, 8, 0);
  static final epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  static Map<String, dynamic> dtoJsonWithIntTimestamp() {
    return <String, dynamic>{
      'id': taskId,
      'title': 'Write mapper tests',
      'is_done': true,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  static Map<String, dynamic> dtoJsonWithIsoStringTimestamp() {
    return <String, dynamic>{
      'id': 'task-iso',
      'title': 'Check ISO parsing',
      'is_done': false,
      'created_at': anotherCreatedAt.toIso8601String(),
    };
  }

  static Map<String, dynamic> dtoJsonWithDateTimeTimestamp() {
    return <String, dynamic>{
      'id': 'task-date-time',
      'title': 'DateTime object payload',
      'is_done': true,
      'created_at': anotherCreatedAt,
    };
  }

  static Map<String, dynamic> dtoJsonWithNullFields() {
    return <String, dynamic>{
      'id': 'task-null',
      'title': null,
      'is_done': null,
      'created_at': null,
    };
  }

  static Map<String, dynamic> dtoJsonWithBlankTitle() {
    return <String, dynamic>{
      'id': 'task-blank',
      'title': '   ',
      'is_done': false,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  static Task validTask({String title = 'Write use case tests'}) {
    return Task(
      id: 'task-use-case',
      title: title,
      isDone: false,
      createdAt: createdAt,
    );
  }
}
