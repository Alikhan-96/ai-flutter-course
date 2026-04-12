import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class AddTaskUseCase {
  const AddTaskUseCase(this._repository);

  final TasksRepository _repository;

  Future<void> call(Task task) async {
    final trimmedTitle = task.title.trim();

    if (trimmedTitle.isEmpty) {
      throw const TaskValidationException('Task title cannot be empty');
    }

    await _repository.addTask(task.copyWith(title: trimmedTitle));
  }
}

class TaskValidationException implements Exception {
  const TaskValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
