import '../../domain/entities/task.dart';
import '../dto/task_dto.dart';

const _defaultTitle = 'Untitled task';
final _defaultCreatedAt = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

extension TaskDtoMapper on TaskDto {
  Task toDomain() {
    return Task(
      id: id,
      title: title?.trim().isNotEmpty == true ? title!.trim() : _defaultTitle,
      isDone: isDone ?? false,
      createdAt: createdAtMilliseconds == null
          ? _defaultCreatedAt
          : DateTime.fromMillisecondsSinceEpoch(
              createdAtMilliseconds!,
              isUtc: true,
            ),
    );
  }
}

extension TaskMapper on Task {
  TaskDto toDto() {
    return TaskDto(
      id: id,
      title: title,
      isDone: isDone,
      createdAtMilliseconds: createdAt.toUtc().millisecondsSinceEpoch,
    );
  }
}
