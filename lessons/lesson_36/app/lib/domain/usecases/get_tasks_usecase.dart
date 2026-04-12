import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  const GetTasksUseCase(this.repository);

  final TaskRepository repository;

  Future<List<TaskEntity>> call() => repository.getTasks();
}
